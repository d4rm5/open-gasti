# Jerarquía de Cuentas

## Estructura General

```
Assets:         Activos (lo que tenés)
Liabilities:    Pasivos (lo que debés)
Income:         Ingresos
Expenses:       Gastos
Equity:         Patrimonio inicial
```

## Cuentas de Argentina

### Assets (Activos)

```
Assets:AR:Bank:<Banco>:ARS     # Cuenta en pesos
Assets:AR:Bank:<Banco>:USD     # Cuenta en dólares
Assets:AR:Bank:Wallet:ARS      # Billeteras digitales (MP, Ualá)
Assets:AR:Cash:ARS             # Efectivo pesos
Assets:AR:Cash:USD             # Efectivo dólares
```

**Ejemplos de bancos:**
- `Assets:AR:Bank:Galicia:ARS`
- `Assets:AR:Bank:Santander:ARS`
- `Assets:AR:Bank:Brubank:ARS`
- `Assets:AR:Bank:MercadoPago:ARS`

### Liabilities (Pasivos)

```
Liabilities:AR:CreditCard:<Tarjeta>    # Tarjetas de crédito
Liabilities:AR:Loans:<Tipo>            # Préstamos
```

**Ejemplos:**
- `Liabilities:AR:CreditCard:Visa`
- `Liabilities:AR:CreditCard:Mastercard`
- `Liabilities:AR:CreditCard:Naranja`
- `Liabilities:AR:Loans:Personal`

### Income (Ingresos)

```
Income:AR:Trabajo           # Sueldo (ARS o USD)
Income:AR:Aguinaldo         # Aguinaldo
Income:AR:Becas             # Becas
Income:AR:Reintegros        # Cashback, reintegros
Income:AR:Venta             # Ventas
Income:AR:Regalo            # Regalos recibidos
Income:Freelance:USD        # Trabajo freelance en dólares
```

### Expenses (Gastos)

```
Expenses:Food:Groceries         # Supermercado
Expenses:Food:Restaurants       # Restaurantes
Expenses:Food:Delivery          # Delivery
Expenses:Food:FastFood          # Comida rápida

Expenses:Transport              # Transporte general
Expenses:Transport:Uber         # Específico (opcional)

Expenses:Services:Internet      # Internet
Expenses:Services:Phone         # Celular
Expenses:Subscriptions          # Netflix, Spotify, etc.

Expenses:Shopping               # Compras generales
Expenses:Shopping:Clothing      # Ropa
Expenses:Shopping:Personal      # Artículos personales

Expenses:Health                 # Salud general
Expenses:Health:Pharmacy        # Farmacia

Expenses:Entertainment          # Entretenimiento
Expenses:Entertainment:Sports   # Deportes/Gimnasio

Expenses:Education              # Educación
Expenses:Technology             # Tecnología
Expenses:Gifts                  # Regalos
Expenses:FeesAndTaxes           # Impuestos y comisiones
Expenses:Other                  # Otros
```

## Monedas Permitidas

Cada cuenta puede restringir qué monedas acepta:

```beancount
; Solo pesos
2020-01-01 open Assets:AR:Bank:Primary:ARS  ARS

; Solo dólares
2020-01-01 open Assets:AR:Bank:Primary:USD  USD

; Ambas monedas
2020-01-01 open Liabilities:AR:CreditCard:Amex  ARS, USD

; Cualquier moneda (sin restricción)
2020-01-01 open Expenses:Food
```

## Personalización

### Agregar un banco nuevo

En `config/accounts.bean`:

```beancount
2020-01-01 open Assets:AR:Bank:Galicia:ARS  ARS
2020-01-01 open Assets:AR:Bank:Galicia:USD  USD
```

### Agregar una categoría de gasto

```beancount
2020-01-01 open Expenses:Mascotas
2020-01-01 open Expenses:Mascotas:Comida
2020-01-01 open Expenses:Mascotas:Veterinaria
```

### Cerrar una cuenta

Si dejás de usar una cuenta:

```beancount
2026-06-30 close Assets:AR:Bank:BancoViejo:ARS
```

## Convenciones

1. **Usar inglés para nombres de cuenta** (Expenses, Assets, etc.)
2. **Usar AR: para cuentas argentinas** (Assets:AR:Bank)
3. **Especificar moneda en cuentas de banco** (Bank:Name:ARS vs Bank:Name:USD)
4. **CamelCase para nombres** (CreditCard, no credit_card)
5. **Subcategorías con :** (Expenses:Food:Groceries)
