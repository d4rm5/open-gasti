# Guía de Instalación

## Requisitos

### Python 3.13+

```bash
# Verificar versión actual
python3 --version

# Si necesitás instalar/actualizar, usar uv:
uv python install 3.13
```

### uv (Package Manager)

```bash
# Instalar uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verificar instalación
uv --version
```

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/d4rm5/open-gasti.git
cd open-gasti
```

### 2. Instalar dependencias

```bash
make install
# o directamente:
uv sync
```

### 3. Verificar instalación

```bash
make validate
```

Deberías ver:
```
[1/5] Checking UV dependencies...
  ✓ UV dependencies are in sync
[2/5] Checking beancount syntax...
  ✓ Beancount syntax valid
...
✓ All validation checks passed!
```

## Configuración Inicial

### 1. Personalizar cuentas

Editar `config/accounts.bean`:

```beancount
; Cambiar "Primary" por tu banco real
; Ejemplo: Assets:AR:Bank:Galicia:ARS
2020-01-01 open Assets:AR:Bank:Primary:ARS  ARS
```

### 2. Establecer balances iniciales

Editar `transactions/balances.bean`:

```beancount
; Poner la fecha en que empezás a trackear
; y los montos reales de tus cuentas
2026-01-01 balance Assets:AR:Bank:Primary:ARS  150000.00 ARS
```

### 3. Actualizar cotización

```bash
make prices
```

Esto crea `prices/auto-generated.bean` con la cotización actual del dólar blue.

Luego descomentar en `main.bean`:
```beancount
include "prices/auto-generated.bean"
```

### 4. Validar

```bash
make check
```

## Abrir Fava

```bash
make fava
```

Abrir http://localhost:5000 en el navegador.

## Integración AI (Opcional)

### OpenCode

```bash
# Instalar opencode
curl -fsSL https://opencode.ai/install | bash

# Usar en el proyecto
cd open-gasti
opencode
```

### Takopi

```bash
# Instalar takopi
uv tool install -U takopi

# Configurar
takopi

# Registrar proyecto
takopi init gasti
```

### beancount-mcp (Claude/GPT)

Ver [MCP.md](MCP.md) para integrar con Claude Desktop o GPT.

## Troubleshooting

### Error: "beancount not found"

```bash
uv sync
```

### Error: "Python 3.13 required"

```bash
uv python install 3.13
```

### Error en sintaxis beancount

```bash
# Ver errores detallados
uv run bean-check main.bean
```

### Fava no abre

```bash
# Probar en modo debug
make fava-debug
```
