# MBF Superset

Apache Superset deployment for server 10.18.136.123.

## Prerequisites

- Docker & Docker Compose installed on the server

## Deployment

1. Copy project files to the server:
```bash
scp -r ./ user@10.18.136.123:/opt/superset/
```

2. SSH into the server:
```bash
ssh user@10.18.136.123
cd /opt/superset
```

3. Edit `.env` file - **change `SUPERSET_SECRET_KEY` and passwords**:
```bash
# Generate a secure secret key
openssl rand -base64 42
```

4. Initialize and start services:
```bash
docker compose up -d
```

5. Access Superset at: `http://10.18.136.123:8088`
   - Default login: admin / admin (change in .env before first deploy)

## Services

| Service | Description |
|---------|-------------|
| superset | Main web application (Gunicorn) |
| superset-worker | Celery worker for async queries |
| superset-worker-beat | Celery beat scheduler |
| postgres | Metadata database |
| redis | Cache and message broker |

## Management

```bash
# View logs
docker compose logs -f superset

# Restart
docker compose restart superset

# Stop all
docker compose down

# Stop and remove data
docker compose down -v
```