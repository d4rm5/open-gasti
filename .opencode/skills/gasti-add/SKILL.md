---
name: gasti-add
description: Add transactions to beancount ledger from Spanish natural language. Parses expenses, income, transfers in Argentine pesos (ARS) and dollars (USD). Use when user says 'gasté', 'pagué', 'cobré', 'compré', 'transferí', or any transaction input. Triggers: '/add', '/gasto', '/ingreso', 'gasté', 'pagué'.
---

# gasti-add

Este skill permite agregar transacciones al libro mayor de Beancount a partir de entrada en lenguaje natural en español.

## Workflow

Para procesar un gasto o ingreso, sigue estos pasos:

### Paso 1: Cargar Contexto
Lee siempre el archivo de referencia de cuentas para asegurar que usas nombres de cuentas válidos:
`references/accounts.md`

### Paso 2: Parsear la Entrada
Extrae los siguientes datos del mensaje del usuario:
- **Monto**: Cantidad numérica.
- **Moneda**: ARS por defecto, o USD si se menciona.
- **Payee (Beneficiario)**: Quién recibe o da el dinero.
- **Descripción**: Detalle de la transacción.
- **Medio de Pago**: Identifica si es débito, crédito, efectivo, etc.
- **Categoría**: Mapea el gasto a la categoría correspondiente (ej: Comida -> Expenses:Food).

### Paso 3: Encontrar el Archivo del Mes
Usa el siguiente comando para encontrar el archivo de transacciones del mes actual:
`ls transactions/$(date +%Y)/`
(No asumas nombres de archivos fijos, búscalo dinámicamente).

### Paso 4: Escribir la Transacción
Añade la transacción al final del archivo del mes actual usando el formato Beancount.

### Paso 5: Validar
Es **OBLIGATORIO** validar la sintaxis después de escribir:
`uv run bean-check main.bean`

## Ejemplos de Parseo

- **"gasté 5000 en el super con débito"**
  - Payee: "Supermercado"
  - Cuenta Gasto: `Expenses:Food:Groceries`
  - Cuenta Origen: `Assets:AR:Bank:Primary:ARS`
  - Monto: `5000.00 ARS`

- **"pagué 10000 de internet con crédito"**
  - Payee: "Proveedor Internet"
  - Cuenta Gasto: `Expenses:Services:Internet`
  - Cuenta Origen: `Liabilities:AR:CreditCard:Primary`
  - Monto: `10000.00 ARS`

- **"cobré 500 usd de freelance"**
  - Payee: "Cliente"
  - Cuenta Ingreso: `Income:Freelance:USD`
  - Cuenta Destino: `Assets:AR:Bank:Primary:USD`
  - Monto: `500.00 USD`

- **"compré ropa por 25000 en 3 cuotas"**
  - Payee: "Tienda de Ropa"
  - Cuenta Gasto: `Expenses:Shopping:Clothing`
  - Cuenta Origen: `Liabilities:AR:CreditCard:Primary`
  - Monto: `25000.00 ARS`
  - Tag: `#cuotas`

## Formato de Transacción

Usa este template para las entradas:

```beancount
YYYY-MM-DD * "Payee" "Descripción" #tags
  Cuenta:Gasto:O:Ingreso    MONTO MONEDA
  Cuenta:De:Pago
```

## Manejo de Errores

- **Fallo de Validación**: Si `uv run bean-check` falla, muestra el error al usuario y **elimina o corrige** la transacción fallida. No dejes el archivo con errores.
- **Cuenta No Encontrada**: Si no encuentras una coincidencia clara en `references/accounts.md`, sugiere la cuenta más cercana o pregunta al usuario.
