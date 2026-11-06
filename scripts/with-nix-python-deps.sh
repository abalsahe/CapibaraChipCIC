#!/usr/bin/env bash
# Run a command inside a temporary Nix shell that provides common Python libraries.
# It does not modify shell.nix, flake.nix, Conda, or the system Python installation.
set -euo pipefail

if [[ $# -eq 0 ]]; then
    cat >&2 <<'USAGE'
Usage:
  ./with-nix-python-deps.sh <command> [args...]

Examples:
  ./with-nix-python-deps.sh python timming.py
  ./with-nix-python-deps.sh python cocotb/chip_top_tb.py
  ./with-nix-python-deps.sh python -c 'import numpy, pandas; print(numpy.__version__)'
USAGE
    exit 2
fi

# The child shell uses a Nix-packaged Python with these modules. Add/remove
# package names here as required; PyYAML is imported in Python as `yaml`.
PYTHON_ENV='python3.withPackages (ps: with ps; [ numpy pandas matplotlib scipy pyyaml cocotb pytest rich tabulate ])'

# Quote every argument so spaces and shell metacharacters are passed safely.
printf -v COMMAND '%q ' "$@"

# Do not use --pure: preserve access to the EDA binaries from the active
# LibreLane nix-shell. The nested shell prepends its own Python environment,
# so the `python` command will not resolve to Anaconda's interpreter.
exec nix-shell -p "$PYTHON_ENV" --run "$COMMAND"
