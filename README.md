# open-gasti 🇦🇷

Starter kit de finanzas personales para Argentina usando [Beancount](https://beancount.github.io/) + [Fava](https://beancount.github.io/fava/).

Diseñado para manejar **pesos (ARS)** y **dólares (USD)** con cotización blue automática.

## Features

- ✅ Estructura lista para usar con cuentas argentinas
- ✅ Cotización dólar blue automática via [DolarAPI](https://dolarapi.com/)
- ✅ Queries pre-configuradas en español para Fava
- ✅ Soporte para cuotas con tag `#cuotas`
- ✅ Integración con AI (OpenCode/Takopi) para agregar transacciones
- ✅ Todo manejado con `uv` (sin pip, sin virtualenv manual)

## Quick Start

### 1. Requisitos

```bash
# Instalar uv (si no lo tenés)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Python 3.13+
uv python install 3.13
```

### 2. Clonar y configurar

```bash
git clone https://github.com/d4rm5/open-gasti.git
cd open-gasti

# Instalar dependencias
make install

# Validar que todo funcione
make check
```

### 3. Personalizar

1. Editar `config/accounts.bean` - Renombrar `Primary`, `Secondary`, `Wallet` a tus bancos reales
2. Editar `transactions/balances.bean` - Poner tus balances iniciales
3. Editar `prices/manual.bean` - Ajustar cotización inicial

### 4. Usar

```bash
# Abrir interfaz web
make fava
# → http://localhost:5000

# Actualizar cotización dólar
make prices

# Validar después de agregar transacciones
make check
```

## Comandos

| Comando | Descripción |
|---------|-------------|
| `make install` | Instalar dependencias |
| `make check` | Validar sintaxis |
| `make fava` | Abrir Fava (http://localhost:5000) |
| `make prices` | Obtener cotización dólar blue |
| `make validate` | Validación completa |
| `make update` | Precios + validación |
| `make report` | Generar reporte mensual |
| `make balance` | Ver balances |
| `make net-worth` | Ver patrimonio en USD |

## Estructura

```
open-gasti/
├── main.bean                    # Archivo principal
├── config/
│   ├── options.bean             # Configuración global
│   ├── accounts.bean            # Definición de cuentas
│   └── queries.bean             # Queries para Fava
├── transactions/
│   ├── balances.bean            # Balances iniciales
│   └── 2026/01-january.bean     # Transacciones mensuales
├── prices/
│   └── manual.bean              # Precios manuales
├── scripts/                     # Automatización
├── plugins/                     # Plugins custom
└── .opencode/                   # Integración AI
```

## Agregar Transacciones

### Manual

Editar el archivo del mes actual (ej: `transactions/2026/01-january.bean`):

```beancount
2026-01-23 * "Supermercado" "Compras semanales"
  Expenses:Food:Groceries    15000.00 ARS
  Assets:AR:Bank:Primary:ARS
```

### Con AI (OpenCode)

```bash
# En el proyecto
opencode

# Luego usar comandos:
/add gasté 5000 en el super con débito
/balance
/query cuánto gasté este mes
```

### Con Telegram (Takopi)

```bash
# Registrar proyecto
takopi init gasti

# Desde Telegram:
/gasti gasté 3000 en uber
```

## Cuotas

Para trackear compras en cuotas, usar el tag `#cuotas`:

```beancount
2026-01-23 * "Tienda" "Zapatillas 3 cuotas (1/3)" #cuotas
  Expenses:Shopping:Clothing    30000.00 ARS
  Liabilities:AR:CreditCard:Primary
```

Ver cuotas pendientes en Fava: query `cuotas-pendientes`

## Cotización Dólar

El script usa [ArgentinaDatos API](https://argentinadatos.com/) para obtener el dólar blue:

```bash
# Solo blue (default)
make prices

# Todas las cotizaciones
uv run python scripts/fetch_prices.py --all

# Otra casa (oficial, bolsa, etc.)
uv run python scripts/fetch_prices.py --casa oficial
```

## Documentación

- [SETUP.md](docs/SETUP.md) - Guía de instalación detallada
- [ACCOUNTS.md](docs/ACCOUNTS.md) - Explicación de cuentas
- [WORKFLOWS.md](docs/WORKFLOWS.md) - Flujos de trabajo con AI
- [SCRIPTING.md](docs/SCRIPTING.md) - Escribir plugins custom
- [MCP.md](docs/MCP.md) - Integración con Claude/GPT
- [LLM-SETUP-GUIDE.md](docs/LLM-SETUP-GUIDE.md) - Guía para asistentes AI que configuren este repo

## API Utilizada

- **[DolarAPI](https://dolarapi.com/)** - Cotización actual del dólar (blue, oficial, bolsa, CCL, etc.)

## Licencia

MIT
