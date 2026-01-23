#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# update_all.sh - Update prices and validate
# ═══════════════════════════════════════════════════════════════
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "═══════════════════════════════════════════════════════════════"
echo "Starting update process..."
echo "═══════════════════════════════════════════════════════════════"

echo ""
echo "[1/3] Fetching blue dollar rate..."
uv run python scripts/fetch_prices.py || echo "⚠ Skipping price fetch (error)"

echo ""
echo "[2/3] Validating beancount file..."
if uv run bean-check main.bean; then
    echo "  ✓ Validation passed"
else
    echo "  ✗ Validation failed!"
    exit 1
fi

echo ""
if [ "$(date +%d)" -eq "01" ]; then
    echo "[3/3] Generating monthly report (first day of month)..."
    bash scripts/monthly_report.sh
else
    echo "[3/3] Skipping monthly report (not first day of month)"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "✓ Update complete!"
echo "═══════════════════════════════════════════════════════════════"
