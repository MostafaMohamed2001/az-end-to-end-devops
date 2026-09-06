# Your Containerization Task

This is now a **single application**.

You should build one image containing:

```text
FastAPI backend
+ Jinja HTML frontend
+ CSS
+ JavaScript
```

PostgreSQL is NOT inside the application image.

## Container requirements

- Base image: Python slim image
- Install `requirements.txt`
- Copy `app/`
- Expose port `8000`
- Run:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

- Pass `DATABASE_URL` at runtime
- Do not store DB credentials in the Dockerfile
- Prefer a non-root user

## AKS

One Deployment can run multiple replicas of this same image:

```text
Users
  |
Ingress / Service
  |
  +---- Pod 1: Apex image
  +---- Pod 2: Apex image
  +---- Pod 3: Apex image
          |
          v
Azure PostgreSQL Flexible Server
```

Suggested Kubernetes probes:

```text
liveness  -> GET /health
readiness -> GET /ready
```
