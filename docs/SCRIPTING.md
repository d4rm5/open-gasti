# Escribir Plugins Custom

Guía para crear plugins de Beancount personalizados.

## Estructura Básica

```python
# plugins/mi_plugin.py
from beancount.core import data

__plugins__ = ["mi_funcion"]

def mi_funcion(entries, options_map):
    """
    Plugin de Beancount.
    
    Args:
        entries: Lista de todas las directivas del ledger
        options_map: Opciones de configuración de Beancount
    
    Returns:
        tuple: (entries modificadas, lista de errores)
    """
    errors = []
    new_entries = []
    
    for entry in entries:
        if isinstance(entry, data.Transaction):
            # Tu lógica aquí
            pass
    
    return entries + new_entries, errors
```

## Habilitar Plugin

En `config/options.bean`:

```beancount
plugin "plugins.mi_plugin"
```

---

## Ejemplo: Savings Rate Tracker

Trackear qué porcentaje del ingreso estás invirtiendo.

```python
# plugins/savings_rate.py
"""
Track monthly savings rate: invested / income
"""
from beancount.core import data
from decimal import Decimal as D
from collections import defaultdict
import datetime

__plugins__ = ["track_savings_rate"]

TARGET_RATE = D("0.70")  # Meta: 70%


def track_savings_rate(entries, options_map):
    errors = []
    new_entries = []
    
    # Acumular por mes
    monthly = defaultdict(lambda: {"income": D(0), "invested": D(0)})
    
    for entry in entries:
        if not isinstance(entry, data.Transaction):
            continue
        
        key = (entry.date.year, entry.date.month)
        
        for posting in entry.postings:
            if posting.units is None:
                continue
            
            # Trackear ingresos en USD
            if posting.account.startswith("Income:Freelance"):
                if posting.units.currency == "USD":
                    # Income es negativo en beancount
                    monthly[key]["income"] -= posting.units.number
            
            # Trackear inversiones en USD
            if posting.account.startswith("Assets:Investments"):
                if posting.units.currency == "USD":
                    monthly[key]["invested"] += posting.units.number
    
    # Generar notas para cada mes
    for (year, month), stats in sorted(monthly.items()):
        if stats["income"] <= 0:
            continue
        
        rate = stats["invested"] / stats["income"]
        pct = rate * 100
        status = "✅" if rate >= TARGET_RATE else "⚠️"
        
        note = data.Note(
            meta=data.new_metadata("<plugin>", 0),
            date=datetime.date(year, month, 28),
            account="Assets:Investments:Stocks:USD",
            comment=f"{status} Savings: {pct:.1f}% (${stats['invested']:.0f}/${stats['income']:.0f})",
            tags=frozenset(),
            links=frozenset(),
        )
        new_entries.append(note)
    
    return entries + new_entries, errors
```

---

## Ejemplo: Budget Enforcer

Alertar cuando una categoría supera el presupuesto mensual.

```python
# plugins/budget_enforcer.py
"""
Warn when monthly spending exceeds budget.
"""
from beancount.core import data
from decimal import Decimal as D
from collections import defaultdict

__plugins__ = ["enforce_budget"]

# Presupuestos mensuales en ARS
BUDGETS = {
    "Expenses:Food": D("100000"),
    "Expenses:Entertainment": D("30000"),
    "Expenses:Shopping": D("50000"),
}


def enforce_budget(entries, options_map):
    errors = []
    
    # Acumular gastos por categoría y mes
    spending = defaultdict(lambda: defaultdict(D))
    
    for entry in entries:
        if not isinstance(entry, data.Transaction):
            continue
        
        key = (entry.date.year, entry.date.month)
        
        for posting in entry.postings:
            if posting.units is None:
                continue
            if posting.units.currency != "ARS":
                continue
            
            for budget_account in BUDGETS:
                if posting.account.startswith(budget_account):
                    spending[key][budget_account] += posting.units.number
    
    # Verificar presupuestos
    for (year, month), categories in spending.items():
        for account, spent in categories.items():
            budget = BUDGETS.get(account, D(0))
            if spent > budget:
                error = data.ValidationError(
                    meta=data.new_metadata("<budget>", 0),
                    message=f"{year}-{month:02d}: {account} exceeded budget "
                            f"(${spent:,.0f} > ${budget:,.0f})",
                    entry=None,
                )
                errors.append(error)
    
    return entries, errors
```

---

## Ejemplo: Duplicate Detector

Detectar transacciones posiblemente duplicadas.

```python
# plugins/duplicate_detector.py
"""
Warn about possible duplicate transactions.
"""
from beancount.core import data
from collections import defaultdict

__plugins__ = ["detect_duplicates"]


def detect_duplicates(entries, options_map):
    errors = []
    
    # Agrupar por (fecha, payee, monto)
    seen = defaultdict(list)
    
    for entry in entries:
        if not isinstance(entry, data.Transaction):
            continue
        
        # Calcular "signature" de la transacción
        total = sum(
            abs(p.units.number) 
            for p in entry.postings 
            if p.units is not None
        ) / 2  # Dividir por 2 porque se cuenta doble
        
        key = (entry.date, entry.payee, round(total, 2))
        seen[key].append(entry)
    
    # Reportar duplicados
    for key, txns in seen.items():
        if len(txns) > 1:
            date, payee, amount = key
            error = data.ValidationError(
                meta=txns[0].meta,
                message=f"Possible duplicate: {date} {payee} ${amount}",
                entry=txns[0],
            )
            errors.append(error)
    
    return entries, errors
```

---

## Tips

### Tipos de Entries

```python
from beancount.core import data

# Transacción
isinstance(entry, data.Transaction)

# Balance assertion
isinstance(entry, data.Balance)

# Open account
isinstance(entry, data.Open)

# Price
isinstance(entry, data.Price)

# Note
isinstance(entry, data.Note)
```

### Crear Nuevas Entries

```python
# Crear una nota
note = data.Note(
    meta=data.new_metadata("<plugin>", 0),
    date=datetime.date.today(),
    account="Assets:Bank",
    comment="Mi comentario",
    tags=frozenset(),
    links=frozenset(),
)

# Crear un error/warning
error = data.ValidationError(
    meta=data.new_metadata("<plugin>", 0),
    message="Mensaje de error",
    entry=None,
)
```

### Debug

```bash
# Ver output del plugin
uv run bean-check main.bean

# Query para verificar notas generadas
uv run bean-query main.bean "SELECT * WHERE type = 'Note'"
```

---

## Más Recursos

- [Beancount Scripting Guide](https://beancount.github.io/docs/beancount_scripting_plugins.html)
- [Beancount API Reference](https://beancount.github.io/docs/api_reference/)
