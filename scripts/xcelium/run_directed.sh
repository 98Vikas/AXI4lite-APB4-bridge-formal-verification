#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR"

xrun -64bit -sv -f scripts/xcelium/compile.f -top bridge_smoke_tb
