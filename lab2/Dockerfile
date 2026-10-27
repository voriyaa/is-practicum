FROM python:3.13.17-slim-bookworm AS builder

WORKDIR /build
COPY app/requirements.txt .
RUN python -m venv /venv && /venv/bin/pip install --no-cache-dir -r requirements.txt


FROM python:3.13.17-slim-bookworm

RUN useradd --uid 10001 --no-create-home --shell /usr/sbin/nologin app

WORKDIR /app
COPY --from=builder /venv /venv
COPY app/app.py .

ENV PATH="/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DB_HOST=localhost \
    DB_PORT=5432

USER app
EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"]

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "app:app"]
