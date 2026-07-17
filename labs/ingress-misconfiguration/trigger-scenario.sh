#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LAB_IMAGE="${IMAGE_REPOSITORY:?Set IMAGE_REPOSITORY to a valid sample-app image reference.}"
export APP_HOSTNAME="${APP_HOSTNAME:-ingress-lab.example.com}"

python3 - <<'PY' "$SCRIPT_DIR/workload/namespace.yaml" | kubectl apply --filename -
import sys
from pathlib import Path
print(Path(sys.argv[1]).read_text(), end="")
PY

python3 - <<'PY' "$SCRIPT_DIR/workload/broken.yaml" | kubectl apply --filename -
import os
import sys
from pathlib import Path
print(os.path.expandvars(Path(sys.argv[1]).read_text()), end="")
PY
