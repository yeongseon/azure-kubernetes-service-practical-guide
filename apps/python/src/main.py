# pyright: reportMissingImports=false, reportUnknownVariableType=false, reportUnknownMemberType=false, reportUntypedFunctionDecorator=false
from __future__ import annotations

from pathlib import Path
from typing import Final

from fastapi import FastAPI

APP_NAME: Final[str] = "aks-keyvault-csi-sample"
APP_VERSION: Final[str] = "0.1.0"
SECRET_PATH: Final[Path] = Path("/mnt/secrets-store/app-secret")

app = FastAPI(title=APP_NAME, version=APP_VERSION)


@app.get("/")
def root() -> dict[str, str]:
    return {"app": APP_NAME, "version": APP_VERSION}


@app.get("/healthz")
def healthz() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/readyz")
def readyz() -> dict[str, str]:
    return {"status": "ready"}


@app.get("/secret")
def secret_status() -> dict[str, int | bool | str]:
    if not SECRET_PATH.exists() or not SECRET_PATH.is_file():
        return {
            "secretPresent": False,
            "secretLength": 0,
            "secretPath": str(SECRET_PATH),
        }

    secret_length = len(SECRET_PATH.read_text(encoding="utf-8").strip())
    return {
        "secretPresent": secret_length > 0,
        "secretLength": secret_length,
        "secretPath": str(SECRET_PATH),
    }
