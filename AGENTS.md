# open-gasti - Personal Finance for Argentina

## Project Overview
A beancount-based personal finance system designed for Argentine users 
managing both ARS (pesos) and USD (dollars).

This is a starter kit. Customize accounts, categories, and workflows to match
your financial situation.

## Tech Stack
- **Beancount 3.x**: Double-entry plain-text accounting
- **Fava**: Web UI (local at http://localhost:5000)
- **uv**: Python package management (no pip, no virtualenv)
- **DolarAPI**: Blue dollar exchange rates (https://dolarapi.com)
- **OpenCode/Takopi**: AI-powered transaction entry (optional)

## CRITICAL: Command Execution

**ALL beancount commands MUST be prefixed with `uv run`:**

```bash
# ✅ CORRECT
uv run bean-check main.bean
uv run bean-query main.bean "SELECT ..."
uv run bean-report main.bean balances
uv run fava main.bean

# ❌ WRONG (exit code 127 - command not found)
bean-check main.bean
bean-query main.bean
bean-report main.bean
fava main.bean
```

**Why:** Beancount commands are installed in `.venv` by uv, not globally.

## Key Rules

### Currencies
- Primary: ARS (Argentine Peso)
- Secondary: USD (at blue market rate)
- All net worth calculations convert to USD
- Price directive format: `2026-01-23 price USD 1450.00 ARS`

### Transaction Format
```beancount
2026-01-23 * "Payee" "Description"
  Expenses:Category    1000.00 ARS
  Assets:AR:Bank:Primary:ARS
```

Flags:
- `*` = completed transaction
- `!` = pending verification

### File Structure
```
main.bean                    # Entry point
config/
  options.bean               # Global settings, plugins
  accounts.bean              # Account definitions
  queries.bean               # Fava queries
transactions/
  balances.bean              # Opening balances
  2026/01-january.bean       # Monthly transactions
prices/
  manual.bean                # Manual price entries
  auto-generated.bean        # From `make prices`
scripts/                     # Automation
plugins/                     # Custom plugins
```

### Commands
```bash
make check      # Validate syntax
make fava       # Open web UI
make prices     # Fetch blue dollar rate
make report     # Monthly report
make validate   # Full validation
make update     # Prices + validate
```

## Adding Transactions

### Manual Entry
Edit the current month file (e.g., `transactions/2026/01-january.bean`)

### Via AI (OpenCode)
Use the custom commands:
- `/add gasté 5000 en el super con débito`
- `/balance` - Show current balances
- `/query cuánto gasté este mes`

### Via Telegram (Takopi)
After setup: `/gasti gasté 3000 en uber`

## Account Naming Convention

### Assets
- `Assets:AR:Bank:<Name>:ARS` - Peso bank accounts
- `Assets:AR:Bank:<Name>:USD` - Dollar bank accounts
- `Assets:AR:Cash:ARS` - Cash pesos
- `Assets:Investments:<Type>:USD` - Investments

### Liabilities
- `Liabilities:AR:CreditCard:<Name>` - Credit cards
- `Liabilities:AR:Loans:<Type>` - Loans

### Income
- `Income:AR:Trabajo` - Salary
- `Income:Freelance:USD` - Freelance in dollars

### Expenses
Categories: Food, Transport, Shopping, Services, Entertainment, Health, 
Education, Technology, Gifts, FeesAndTaxes, Other

## Installments (Cuotas)
Use the `#cuotas` tag for tracking:
```beancount
2026-01-23 * "Store" "Compra en 3 cuotas (1/3)" #cuotas
  Expenses:Shopping    10000.00 ARS
  Liabilities:AR:CreditCard:Primary
```

Query pending installments in Fava: `cuotas-pendientes`

## Common Queries

### Run queries using:
```bash
uv run bean-query main.bean "YOUR QUERY HERE"
```

### Useful queries:

**Gastos del mes actual:**
```sql
SELECT
  root(account, 2) AS categoria,
  sum(convert(position, 'ARS')) AS total_ars
WHERE account ~ 'Expenses' 
  AND year = YEAR(today()) 
  AND month = MONTH(today())
GROUP BY categoria
ORDER BY total_ars DESC
```

**Patrimonio neto en USD:**
```sql
SELECT
  root(account, 2) AS tipo,
  account,
  sum(convert(position, 'USD')) AS balance_usd
WHERE account ~ 'Assets|Liabilities'
GROUP BY tipo, account
ORDER BY balance_usd DESC
```

**Top gastos del mes:**
```sql
SELECT
  date,
  payee,
  narration,
  sum(convert(position, 'ARS')) AS monto
WHERE account ~ 'Expenses'
  AND year = YEAR(today())
  AND month = MONTH(today())
GROUP BY date, payee, narration
ORDER BY monto DESC
LIMIT 10
```

## Price Updates
```bash
# Fetch current blue dollar rate
make prices

# Then uncomment in main.bean:
# include "prices/auto-generated.bean"
```

## Validation
Always validate after adding transactions:
```bash
make check
```

For full validation including dependencies and Fava:
```bash
make validate
```
