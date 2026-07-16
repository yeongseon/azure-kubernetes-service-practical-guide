FROM python:3.12.10-slim-bookworm AS builder

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /build

COPY requirements.txt ./requirements.txt

RUN python -m pip install --upgrade pip==24.2 && \
    python -m pip wheel --wheel-dir /build/wheels --requirement requirements.txt

FROM python:3.12.10-slim-bookworm AS runtime

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup --uid 1000 appuser

COPY requirements.txt ./requirements.txt
COPY --from=builder /build/wheels /wheels

RUN python -m pip install --upgrade pip==24.2 && \
    python -m pip install --no-index --find-links /wheels --requirement requirements.txt && \
    rm -rf /wheels

COPY src ./src

USER 1000:1000

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
