---
name: gasti-balance
description: Check account balances and net worth in USD for beancount personal finance. Use when user asks for balance, patrimonio, saldo, cuánto tengo, or net worth queries. Triggers: '/balance', '/patrimonio', '/saldo', '/net-worth'.
---

# gasti-balance

This skill allows you to quickly check your account balances and net worth using the beancount system.

## Workflow

To check your financial status, use one of the following commands. All beancount-related commands are executed through `uv` to ensure the correct environment.

### Commands

- **Check all account balances:**
  `uv run make balance`

- **Check net worth in USD:**
  `uv run make net-worth`

- **Custom Assets Query:**
  `uv run bean-query main.bean "SELECT account, sum(position) WHERE account ~ 'Assets' GROUP BY account"`

### Spanish Command Aliases

You can also use these triggers:
- `/balance` - Shows all account balances.
- `/patrimonio` - Shows net worth in USD.
- `/saldo` - Shows all account balances.
- `/net-worth` - Shows net worth in USD.
