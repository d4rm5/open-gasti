# Beancount Query Reference

This document maps common Spanish questions to pre-configured queries in `config/queries.bean`.

## Pre-built Queries (config/queries.bean)

| Query Name | Spanish Triggers | Description |
|------------|-----------------|-------------|
| `net-worth-usd` | patrimonio, neto, cuánto valgo | Total assets and liabilities converted to USD. |
| `gastos-mes-actual` | cuánto gasté este mes, gastos mes | Monthly expenses grouped by category in ARS. |
| `cuotas-pendientes` | cuotas, pagos pendientes, #cuotas | Transactions tagged with #cuotas occurring today or in the future. |
| `burn-rate-mensual` | burn rate, gasto promedio, mensual | Average monthly expenses over the last 12 months. |
| `ingresos-vs-gastos` | ingresos vs gastos, balance, gano más | Monthly comparison of Income vs Expenses in ARS. |
| `deudas-tarjetas` | deuda tarjeta, cuánto debo, visa, amex | Current balance of all credit card accounts. |
| `transacciones-recientes`| transacciones, movimientos, qué compré | All transactions from the last 30 days. |
| `savings-rate` | tasa de ahorro, ahorro, cuánto ahorré | Tracking of USD savings/investments vs Income. |
| `balance-por-moneda` | balance moneda, cuántos dólares tengo | Total assets grouped by currency (ARS, USD). |
| `top-gastos-mes` | top gastos, gastos más grandes | Top 10 largest expenses for the current month. |

## BQL Syntax Quick Reference

Use these components to build custom queries:

- **SELECT**: Fields to return (date, payee, account, position, sum(position)).
- **FROM**: (Implicit in `bean-query`).
- **WHERE**: Filter by account (`account ~ 'Expenses'`), date (`date >= 2026-01-01`), or tag (`'cuotas' IN tags`).
- **GROUP BY**: Aggregate results by field (`root(account, 2)`, `currency`).
- **ORDER BY**: Sort results (`date DESC`, `sum(position)`).
- **CONVERT**: Change currency (`convert(position, 'USD')`).

## Execution Examples

```bash
# Execute a pre-built query
uv run bean-query main.bean "gastos-mes-actual"

# Execute a custom BQL query
uv run bean-query main.bean "SELECT account, sum(position) WHERE account ~ 'Expenses' GROUP BY account"
```
