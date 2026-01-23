# Integración MCP (Model Context Protocol)

Usar Claude Desktop, GPT, u otros LLMs con acceso directo al ledger.

## ¿Qué es MCP?

[Model Context Protocol](https://modelcontextprotocol.io/) permite que LLMs interactúen con herramientas externas. Con beancount-mcp, Claude/GPT pueden:

- Ejecutar queries BQL
- Ver balances y transacciones
- Agregar nuevas transacciones

## Instalación

```bash
# Instalar con soporte MCP
uv sync --extra mcp

# O directamente
uv add beancount-mcp
```

## Claude Desktop

### Configurar

Editar `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "beancount": {
      "command": "uvx",
      "args": [
        "beancount-mcp",
        "--transport=stdio",
        "/ruta/completa/a/open-gasti/main.bean"
      ]
    }
  }
}
```

### Usar

Reiniciar Claude Desktop. Ahora podés:

1. "¿Cuál es mi patrimonio neto?"
2. "¿Cuánto gasté en comida este mes?"
3. "Agregá una transacción: gasté 5000 en el super"

## OpenCode

El proyecto ya viene configurado en `.opencode/opencode.json`:

```json
{
  "mcp": {
    "servers": {
      "beancount": {
        "command": "uvx",
        "args": ["beancount-mcp", "--transport=stdio", "./main.bean"]
      }
    }
  }
}
```

## Herramientas Disponibles

### beancount_query

Ejecutar queries BQL:

```
Ejecutá: SELECT account, sum(position) WHERE account ~ 'Assets'
```

### beancount_submit

Agregar transacciones:

```
Agregá esta transacción:
2026-01-23 * "Supermercado" "Compras"
  Expenses:Food:Groceries  5000 ARS
  Assets:AR:Bank:Primary:ARS
```

## SSE Transport (Remoto)

Para acceso remoto, usar SSE transport:

```bash
# Iniciar servidor
uvx beancount-mcp --transport=sse --port=8080 main.bean
```

Luego conectar desde cualquier cliente MCP compatible.

## Seguridad

⚠️ **Importante**: beancount-mcp tiene acceso de lectura/escritura al ledger.

- Solo usar en ambiente local/seguro
- No exponer el servidor SSE públicamente
- Revisar transacciones agregadas por el LLM

## Troubleshooting

### "beancount-mcp not found"

```bash
uvx beancount-mcp --help
```

Si falla:
```bash
uv tool install beancount-mcp
```

### "File not found"

Usar ruta absoluta en la configuración:
```json
"args": ["beancount-mcp", "--transport=stdio", "/Users/tu-usuario/open-gasti/main.bean"]
```

### Ver logs

```bash
uvx beancount-mcp --transport=stdio --debug main.bean
```
