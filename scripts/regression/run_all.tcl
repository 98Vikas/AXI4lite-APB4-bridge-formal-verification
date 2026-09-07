#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR"

echo "Starting formal verification..."
./scripts/jaspergold/run_formal.sh

echo "Starting simulation compile/run..."
./scripts/xcelium/run_directed.sh

echo "Regression completed."
