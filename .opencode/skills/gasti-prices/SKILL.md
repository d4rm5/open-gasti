---
name: gasti-prices
description: Fetch and update blue dollar exchange rate from DolarAPI for beancount personal finance. Use when user asks for dollar rate, cotización, dólar blue, actualizar precios, or price updates. Triggers: '/prices', '/dolar', '/cotizacion'.
---

# gasti-prices

Update the Argentine blue dollar exchange rate in your beancount ledger using DolarAPI.

## Workflow

To update the prices, run the `make prices` command. This will fetch the latest blue dollar rate and save it to your ledger.

## Commands

- `make prices`: Fetch the current blue dollar rate (default).
- `uv run python scripts/fetch_prices.py --all`: Fetch all available exchange rates (blue, official, bolsa, etc.).
- `uv run python scripts/fetch_prices.py --casa oficial`: Fetch a specific exchange rate (e.g., official).

## Output

The fetched prices are saved to `prices/auto-generated.bean`.

### Initial Setup

After running the command for the first time, you must ensure that the generated file is included in your main ledger.

Open `main.bean` and uncomment the following line (around line 40):

```beancount
include "prices/auto-generated.bean"
```
