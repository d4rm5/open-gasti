#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# validate.sh - Full validation suite for open-gasti
# ═══════════════════════════════════════════════════════════════
set -e

echo "═══════════════════════════════════════════════════════════════"
echo "Running validation checks..."
echo "═══════════════════════════════════════════════════════════════"

ERRORS=0

echo ""
echo "[1/5] Checking UV dependencies..."
if uv sync --check 2>/dev/null; then
    echo "  ✓ UV dependencies are in sync"
else
    echo "  ✗ UV dependencies out of sync - run 'make install'"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "[2/5] Checking beancount syntax..."
# bean-check returns 0 even with warnings, check for actual errors
BEAN_OUTPUT=$(uv run bean-check main.bean 2>&1)
BEAN_EXIT=$?
if [ $BEAN_EXIT -eq 0 ]; then
    if echo "$BEAN_OUTPUT" | grep -q "error"; then
        echo "$BEAN_OUTPUT"
        echo "  ✗ Beancount errors found"
        ERRORS=$((ERRORS + 1))
    else
        if [ -n "$BEAN_OUTPUT" ]; then
            echo "  ⚠ Beancount warnings (OK):"
            echo "$BEAN_OUTPUT" | head -5
        fi
        echo "  ✓ Beancount syntax valid"
    fi
else
    echo "$BEAN_OUTPUT"
    echo "  ✗ Beancount check failed"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "[3/5] Testing query system..."
TRANSACTION_COUNT=$(uv run bean-query main.bean "SELECT count(*)" 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
if [ -n "$TRANSACTION_COUNT" ] && [ "$TRANSACTION_COUNT" -gt 0 ] 2>/dev/null; then
    echo "  ✓ Query system working ($TRANSACTION_COUNT transactions)"
else
    echo "  ⚠ No transactions found (this is OK for a new setup)"
fi

echo ""
echo "[4/5] Testing Fava..."
if timeout 3 uv run fava --help > /dev/null 2>&1; then
    echo "  ✓ Fava loads successfully"
else
    echo "  ✗ Fava failed to load"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "[5/5] Checking directory structure..."
REQUIRED_DIRS=("config" "transactions" "prices" "scripts" "plugins")
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✓ $dir/"
    else
        echo "  ✗ $dir/ MISSING"
        ERRORS=$((ERRORS + 1))
    fi
done

echo ""
echo "═══════════════════════════════════════════════════════════════"
if [ $ERRORS -eq 0 ]; then
    echo "✓ All validation checks passed!"
    exit 0
else
    echo "✗ $ERRORS validation check(s) failed"
    exit 1
fi
