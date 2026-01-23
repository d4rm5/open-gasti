#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# monthly_report.sh - Generate monthly financial report
# ═══════════════════════════════════════════════════════════════
set -e

MONTH=$(date +%Y-%m)
YEAR=$(date +%Y)
MONTH_NUM=$(date +%m)
OUTPUT_DIR="reports"
OUTPUT_FILE="$OUTPUT_DIR/report-$MONTH.txt"

mkdir -p "$OUTPUT_DIR"

echo "Generating report for $MONTH..."

cat > "$OUTPUT_FILE" <<EOF
═══════════════════════════════════════════════════════════════
REPORTE FINANCIERO MENSUAL - $MONTH
═══════════════════════════════════════════════════════════════

Generado: $(date)

───────────────────────────────────────────────────────────────
1. PATRIMONIO NETO (USD)
───────────────────────────────────────────────────────────────
EOF

uv run bean-query main.bean "
  SELECT 
    root(account, 2) AS tipo,
    sum(convert(position, 'USD')) AS balance_usd
  WHERE account ~ 'Assets|Liabilities'
  GROUP BY tipo
  ORDER BY balance_usd DESC
" >> "$OUTPUT_FILE" 2>/dev/null || echo "Query failed" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<EOF

───────────────────────────────────────────────────────────────
2. BALANCE POR MONEDA
───────────────────────────────────────────────────────────────
EOF

uv run bean-query main.bean "
  SELECT 
    currency,
    sum(position) AS total
  WHERE account ~ 'Assets'
  GROUP BY currency
  ORDER BY currency
" >> "$OUTPUT_FILE" 2>/dev/null || echo "Query failed" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<EOF

───────────────────────────────────────────────────────────────
3. TOP 10 GASTOS DEL MES
───────────────────────────────────────────────────────────────
EOF

uv run bean-query main.bean "
  SELECT 
    account, 
    sum(convert(position, 'ARS')) AS total_ars
  WHERE account ~ 'Expenses' AND year = $YEAR AND month = $MONTH_NUM
  GROUP BY account
  ORDER BY total_ars DESC
  LIMIT 10
" >> "$OUTPUT_FILE" 2>/dev/null || echo "Query failed" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<EOF

───────────────────────────────────────────────────────────────
4. DEUDAS TARJETAS
───────────────────────────────────────────────────────────────
EOF

uv run bean-query main.bean "
  SELECT 
    account,
    sum(position) AS saldo
  WHERE account ~ 'Liabilities:AR:CreditCard'
  GROUP BY account
" >> "$OUTPUT_FILE" 2>/dev/null || echo "Query failed" >> "$OUTPUT_FILE"

echo ""
echo "✓ Report generated: $OUTPUT_FILE"
