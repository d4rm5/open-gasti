# Cuentas Válidas y Mapeos (Argentina)

Este archivo sirve como referencia para identificar cuentas válidas de Beancount a partir de descripciones en lenguaje natural.

## Lista de Cuentas (Categorizadas)

### Assets (Activos)
- Assets:AR:Bank:Primary:ARS
- Assets:AR:Bank:Primary:USD
- Assets:AR:Bank:Secondary:ARS
- Assets:AR:Bank:Wallet:ARS
- Assets:AR:Cash:ARS
- Assets:AR:Cash:USD
- Assets:Investments:Stocks:USD
- Assets:Investments:Tactical:USD
- Assets:Investments:SelfDev:USD
- Assets:Emergency:USD

### Liabilities (Pasivos)
- Liabilities:AR:CreditCard:Primary
- Liabilities:AR:CreditCard:Secondary
- Liabilities:AR:CreditCard:Wallet
- Liabilities:AR:Loans:Personal
- Liabilities:AR:Loans:Family

### Income (Ingresos)
- Income:AR:Trabajo
- Income:AR:Becas
- Income:AR:Reintegros
- Income:AR:Venta
- Income:AR:Regalo
- Income:AR:Otros
- Income:AR:Interest:ARS
- Income:AR:Interest:USD
- Income:Freelance:USD
- Income:Reintegro
- Income:Otros
- Income:Regalo

### Expenses (Gastos)
- Expenses:Food
- Expenses:Food:Restaurants
- Expenses:Food:Delivery
- Expenses:Food:FastFood
- Expenses:Food:Groceries
- Expenses:Transport
- Expenses:Shopping
- Expenses:Shopping:Clothing
- Expenses:Shopping:Personal
- Expenses:Services
- Expenses:Services:Subscriptions
- Expenses:Services:Internet
- Expenses:Subscriptions
- Expenses:Entertainment
- Expenses:Entertainment:Sports
- Expenses:Recitales
- Expenses:Health
- Expenses:Health:Supplements
- Expenses:Education
- Expenses:Technology
- Expenses:Gifts
- Expenses:FeesAndTaxes
- Expenses:Other
- Expenses:Living:Essential
- Expenses:Living:Quality

### Equity (Patrimonio)
- Equity:Opening-Balances

---

## Mapeos de Alias (Español)

### Categorías de Gastos
- **Comida/Alimentos**: `Expenses:Food` (Supermercado, Restaurant, Delivery, Almuerzo, Cena)
- **Transporte**: `Expenses:Transport` (Uber, Taxi, Colectivo, Nafta, Combustible, Viaje)
- **Compras**: `Expenses:Shopping` (Shopping, Ropa, Vestimenta, Zapatillas)
- **Servicios**: `Expenses:Services` (Luz, Gas, Agua, Internet, Suscripción, Netflix, Spotify)
- **Entretenimiento**: `Expenses:Entertainment` (Cine, Salida, Deporte, Recital, Teatro)
- **Salud**: `Expenses:Health` (Médico, Farmacia, Remedio, Obra Social)
- **Educación**: `Expenses:Education` (Curso, Libro, Universidad, Colegio)
- **Tecnología**: `Expenses:Technology` (Celular, Computadora, Electrónica)
- **Regalos**: `Expenses:Gifts`
- **Impuestos/Comisiones**: `Expenses:FeesAndTaxes` (AFIP, Rentas, Comisión)

### Mapeos de Medios de Pago
- **débito** / **tarjeta de débito** → `Assets:AR:Bank:*` (Ej: `Assets:AR:Bank:Primary:ARS`)
- **crédito** / **tarjeta de crédito** → `Liabilities:AR:CreditCard:*` (Ej: `Liabilities:AR:CreditCard:Primary`)
- **efectivo** → `Assets:AR:Cash:ARS` (o `Assets:AR:Cash:USD`)
- **transferencia** → `Assets:AR:Bank:*` (Ej: `Assets:AR:Bank:Primary:ARS`)
