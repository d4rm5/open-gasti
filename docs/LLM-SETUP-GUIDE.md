# LLM Setup Guide for open-gasti

This document is for AI assistants (LLMs) helping users set up and configure open-gasti.

## Quick Context

open-gasti is a **starter kit** (template) for personal finance in Argentina:
- Users **clone this repo** to get a pre-configured beancount setup
- Then **customize** accounts, balances, and categories to their situation
- The repo is meant to be forked/cloned, not used as a dependency

Key features:
- Dual currency support: ARS (pesos) and USD (dollars)
- Blue dollar exchange rate integration via API
- Pre-configured expense categories in Spanish
- AI integration via OpenCode/Takopi

## Starter Kit Workflow

When helping a user set up open-gasti, follow this workflow:

### 1. Clone the Template

```bash
# Clone the starter kit
git clone https://github.com/d4rm5/open-gasti.git mi-finanzas
cd mi-finanzas

# Optional: Remove git history to start fresh
rm -rf .git
git init
```

### 2. Install Dependencies

```bash
make install
# or: uv sync
```

### 3. Customize for the User

The key files to personalize:

| File | What to Customize |
|------|-------------------|
| `config/accounts.bean` | Rename `Primary`, `Secondary`, `Wallet` to actual bank names |
| `transactions/balances.bean` | Set real opening balances and start date |
| `prices/manual.bean` | Update initial dollar rate |

### 4. Validate and Start

```bash
make check      # Verify syntax
make fava       # Open web UI
```

## Critical: Command Execution

**ALL beancount commands MUST use `uv run` prefix:**

```bash
# CORRECT
uv run bean-check main.bean
uv run bean-query main.bean "SELECT ..."
uv run fava main.bean

# WRONG (will fail with exit code 127)
bean-check main.bean
fava main.bean
```

Beancount is installed in `.venv` managed by `uv`, not globally.

## Setup Checklist

### 1. Verify Prerequisites

```bash
# Check uv is installed
uv --version

# Check Python (3.13+ required)
uv run python --version
```

If `uv` is missing:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Install Dependencies

```bash
make install
# or: uv sync
```

### 3. Validate Installation

```bash
make validate
```

Expected output should show all checks passing.

### 4. Run Syntax Check

```bash
make check
# or: uv run bean-check main.bean
```

If this fails, there are syntax errors in .bean files.

## File Structure for LLMs

```
main.bean                     # Entry point - includes all other files
config/
  options.bean                # Global settings, operating currency
  accounts.bean               # Account definitions (customize these!)
  queries.bean                # Fava query presets
transactions/
  balances.bean               # Opening balances
  YYYY/MM-month.bean          # Monthly transactions (e.g., 2026/01-january.bean)
prices/
  manual.bean                 # Manual price entries
  auto-generated.bean         # From `make prices` (may not exist initially)
```

## Key Customization Points

When helping users customize, focus on these files:

### 1. Account Names (`config/accounts.bean`)

Users should rename generic accounts to their actual banks:

```beancount
; BEFORE (template)
2020-01-01 open Assets:AR:Bank:Primary:ARS    ARS

; AFTER (customized)
2020-01-01 open Assets:AR:Bank:Galicia:ARS    ARS
```

Common Argentine banks: Galicia, Santander, BBVA, Macro, Nacion, HSBC, Brubank
Common wallets: MercadoPago, Uala, NaranjaX, Lemon

### 2. Opening Balances (`transactions/balances.bean`)

Update the date and amounts:

```beancount
2026-01-01 * "Opening Balance" "Balance inicial"
  Assets:AR:Bank:Galicia:ARS     150000.00 ARS
  Assets:AR:Cash:USD               500.00 USD
  Liabilities:AR:CreditCard:Visa  -25000.00 ARS
  Equity:Opening-Balances
```

### 3. Dollar Rate (`prices/manual.bean` or run `make prices`)

```beancount
2026-01-23 price USD 1450.00 ARS
```

## Transaction Format

```beancount
DATE FLAG "PAYEE" "DESCRIPTION" [#tags]
  EXPENSE_ACCOUNT    AMOUNT CURRENCY
  SOURCE_ACCOUNT
```

Example:
```beancount
2026-01-23 * "Carrefour" "Compras semanales"
  Expenses:Food:Groceries    15000.00 ARS
  Assets:AR:Bank:Galicia:ARS
```

Flags:
- `*` = completed transaction
- `!` = pending verification

## Account Naming Convention

### Assets
| Pattern | Use |
|---------|-----|
| `Assets:AR:Bank:<BankName>:ARS` | Peso bank accounts |
| `Assets:AR:Bank:<BankName>:USD` | Dollar bank accounts |
| `Assets:AR:Cash:ARS` | Cash pesos |
| `Assets:AR:Cash:USD` | Cash dollars |
| `Assets:Investments:<Type>:USD` | Investments |

### Liabilities
| Pattern | Use |
|---------|-----|
| `Liabilities:AR:CreditCard:<Name>` | Credit cards |
| `Liabilities:AR:Loans:<Type>` | Loans |

### Income
| Pattern | Use |
|---------|-----|
| `Income:AR:Trabajo` | Salary |
| `Income:Freelance:USD` | Freelance in dollars |
| `Income:AR:Reintegros` | Refunds |

### Expenses
Categories available:
- `Expenses:Food` (Groceries, Restaurants, Delivery, FastFood)
- `Expenses:Transport`
- `Expenses:Shopping` (Clothing, Personal)
- `Expenses:Services` (Subscriptions, Internet)
- `Expenses:Entertainment` (Sports)
- `Expenses:Health` (Supplements)
- `Expenses:Education`
- `Expenses:Technology`
- `Expenses:Gifts`
- `Expenses:FeesAndTaxes`
- `Expenses:Other`

## Common Queries

### Monthly expenses by category
```bash
uv run bean-query main.bean "
SELECT
  root(account, 2) AS categoria,
  sum(convert(position, 'ARS')) AS total_ars
WHERE account ~ 'Expenses' 
  AND year = YEAR(today()) 
  AND month = MONTH(today())
GROUP BY categoria
ORDER BY total_ars DESC
"
```

### Net worth in USD
```bash
uv run bean-query main.bean "
SELECT
  sum(convert(position, 'USD')) AS total
WHERE account ~ 'Assets|Liabilities'
"
```

### Recent transactions
```bash
uv run bean-query main.bean "
SELECT date, payee, narration, position
WHERE account ~ 'Expenses'
ORDER BY date DESC
LIMIT 10
"
```

## Installments (Cuotas)

Argentine credit cards commonly have installment payments. Track with `#cuotas` tag:

```beancount
2026-01-23 * "Garbarino" "Heladera 12 cuotas (1/12)" #cuotas
  Expenses:Shopping    50000.00 ARS
  Liabilities:AR:CreditCard:Visa
```

Query pending installments:
```bash
uv run bean-query main.bean "
SELECT date, payee, narration, position
WHERE 'cuotas' IN tags
ORDER BY date
"
```

## Validation Commands

Always validate after changes:

```bash
# Quick syntax check
make check

# Full validation (syntax + dependencies + fava)
make validate
```

## Common Errors and Fixes

### "Account does not exist"
The account used in a transaction wasn't opened. Add it to `config/accounts.bean`:
```beancount
2020-01-01 open Assets:AR:Bank:NewBank:ARS    ARS
```

### "Transaction does not balance"
Amounts don't sum to zero. Either:
- Add the missing leg
- Let beancount calculate one leg by omitting the amount

### "Invalid currency"
Account is restricted to specific currencies. Check the account definition.

### "Duplicate transaction"
Same transaction appears twice. Check for duplicate entries.

## Adding New Month

Create new transaction file for each month:

```bash
# Example: February 2026
touch transactions/2026/02-february.bean
```

Add include to `main.bean`:
```beancount
include "transactions/2026/02-february.bean"
```

## Price Updates

Update dollar rate:
```bash
make prices
```

This fetches the current blue dollar rate and saves to `prices/auto-generated.bean`.

To use it, ensure `main.bean` includes:
```beancount
include "prices/auto-generated.bean"
```

## LLM-Specific Tips

1. **This is a starter kit** - users clone it and customize, not install as dependency
2. **Always run `make check` after any .bean file modification**
3. **Use `uv run` prefix for ALL beancount commands**
4. **Dates format: YYYY-MM-DD** (e.g., 2026-01-23)
5. **Currency codes: ARS for pesos, USD for dollars**
6. **Amounts: Use period as decimal separator, two decimal places** (e.g., 1500.00)
7. **Indentation: Two spaces for transaction legs**
8. **When in doubt, validate with `uv run bean-check main.bean`**

## Customization Checklist

When helping a user personalize their cloned repo:

- [ ] Rename bank accounts in `config/accounts.bean` (Primary → actual bank name)
- [ ] Set opening balances in `transactions/balances.bean`
- [ ] Update start date to when user begins tracking
- [ ] Run `make prices` to get current dollar rate
- [ ] Add any additional accounts the user needs
- [ ] Remove accounts the user doesn't use
- [ ] Validate with `make check`

## Available Make Commands

| Command | Description |
|---------|-------------|
| `make install` | Install dependencies |
| `make check` | Validate beancount syntax |
| `make validate` | Full validation suite |
| `make fava` | Launch web UI at localhost:5000 |
| `make prices` | Fetch current blue dollar rate |
| `make balance` | Show current balances |
| `make net-worth` | Show net worth in USD |
| `make report` | Generate monthly report |
| `make update` | Prices + validation |

## Example: Full Customization Session

Here's a typical flow when helping a user set up their cloned repo:

```bash
# 1. User cloned the repo
cd mi-finanzas

# 2. Install dependencies
make install

# 3. You help customize accounts.bean
#    - Rename Primary → Galicia
#    - Rename Secondary → Brubank
#    - Rename Wallet → MercadoPago
#    - Add new account for Uala

# 4. You help set opening balances
#    - Update date to today
#    - Set real amounts

# 5. Fetch current dollar rate
make prices

# 6. Validate everything works
make check

# 7. Open Fava to verify
make fava
```

The user now has a personalized finance system based on the open-gasti template.
