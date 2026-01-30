---
name: gasti-query
description: Natural language queries for beancount personal finance. Translates Spanish questions to BQL and executes with bean-query. Use for queries like 'cuánto gasté este mes', 'gastos por categoría', 'transacciones recientes'. Triggers: '/query', 'cuánto', 'gasté', 'ingresos', 'gastos'.
---

# gasti-query

Natural language interface for querying your personal finances in Beancount.

## Workflow

1. **Parse Spanish question**: Identify the intent (expenses, income, net worth, etc.) and time period.
2. **Translate to BQL**: Map the intent to a Beancount Query Language (BQL) statement or a pre-defined query name.
3. **Execute**: Run the query using the `uv run` prefix.
   ```bash
   uv run bean-query main.bean "QUERY_NAME_OR_BQL"
   ```

## Pre-built Queries

Always check `references/queries.md` for the full list of available pre-configured queries.

## Common Spanish-to-BQL Translations

- **"cuánto gasté este mes"** -> Use `gastos-mes-actual`
- **"gastos por categoría"** -> `SELECT root(account, 2) AS categoria, sum(position) WHERE account ~ 'Expenses' GROUP BY categoria`
- **"transacciones recientes"** -> Use `transacciones-recientes` (last 30 days)
- **"patrimonio neto"** -> Use `net-worth-usd`

## CRITICAL Rules

- **ALWAYS** prefix beancount commands with `uv run`.
- **NEVER** use `bean-query` directly.
- Use `main.bean` as the target file for all queries.
