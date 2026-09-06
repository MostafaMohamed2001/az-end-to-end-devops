from pathlib import Path

from fastapi import Depends, FastAPI, HTTPException, Request, status
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from sqlalchemy import select, text
from sqlalchemy.orm import Session

from .config import settings
from .database import Base, engine, get_db
from .models import Task
from .schemas import TaskCreate, TaskRead, TaskUpdate


BASE_DIR = Path(__file__).resolve().parent

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.app_name,
    version="1.0.0",
)

app.mount(
    "/static",
    StaticFiles(directory=BASE_DIR / "static"),
    name="static",
)

templates = Jinja2Templates(directory=BASE_DIR / "templates")


@app.get("/", response_class=HTMLResponse)
def home(request: Request):
    return templates.TemplateResponse(
        request=request,
        name="index.html",
        context={
            "app_name": settings.app_name,
            "environment": settings.app_env,
        },
    )


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/ready")
def ready(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {"status": "ready", "database": "reachable"}
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database is not reachable",
        ) from exc


@app.get("/api/tasks", response_model=list[TaskRead])
def list_tasks(db: Session = Depends(get_db)):
    query = select(Task).order_by(Task.created_at.desc())
    return list(db.scalars(query).all())


@app.post(
    "/api/tasks",
    response_model=TaskRead,
    status_code=status.HTTP_201_CREATED,
)
def create_task(payload: TaskCreate, db: Session = Depends(get_db)):
    task = Task(
        title=payload.title,
        description=payload.description,
    )
    db.add(task)
    db.commit()
    db.refresh(task)
    return task


@app.patch("/api/tasks/{task_id}", response_model=TaskRead)
def update_task(
    task_id: int,
    payload: TaskUpdate,
    db: Session = Depends(get_db),
):
    task = db.get(Task, task_id)

    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")

    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(task, field, value)

    db.commit()
    db.refresh(task)
    return task


@app.delete(
    "/api/tasks/{task_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_task(task_id: int, db: Session = Depends(get_db)):
    task = db.get(Task, task_id)

    if task is None:
        raise HTTPException(status_code=404, detail="Task not found")

    db.delete(task)
    db.commit()
    return None
