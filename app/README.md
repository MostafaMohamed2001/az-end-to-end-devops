# Apex Task Board — Python Monolith

A single Python application containing both frontend and backend, designed so you can build **one container image**.

## Stack

- FastAPI — backend/API
- Jinja2 — server-rendered frontend
- SQLAlchemy — ORM
- PostgreSQL — database
- HTML/CSS/JavaScript — frontend assets served by FastAPI

## Architecture

```text
Browser
   |
   v
FastAPI App :8000
   | \
   |  \--> HTML / CSS / JS frontend
   |
   \-----> REST API /api/tasks
              |
              v
          PostgreSQL
```

Only the application goes inside your image. PostgreSQL should stay external, for example Azure Database for PostgreSQL Flexible Server.

## Local setup

Create a PostgreSQL database first, then:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Edit `.env` with your PostgreSQL connection string:

```env
DATABASE_URL=postgresql+psycopg://apexadmin:YOUR_PASSWORD@localhost:5432/apexdb
```

Run:

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Open:

```text
http://localhost:8000
```

Swagger:

```text
http://localhost:8000/docs
```

Health endpoints:

```text
GET /health
GET /ready
```

## Containerization target

You only need **one application Dockerfile**.

Runtime command:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

Expose:

```text
8000
```

Inject `DATABASE_URL` at runtime. Never bake the PostgreSQL password into the image.

For AKS:

```text
Ingress/LoadBalancer
       |
       v
Apex App Deployment
(one image, multiple replicas)
       |
       v
Azure PostgreSQL Flexible Server
```
