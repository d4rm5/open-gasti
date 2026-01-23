# Flujos de Trabajo con AI

Cómo usar open-gasti con herramientas de AI para automatizar la entrada de transacciones.

## OpenCode

### Instalación

```bash
curl -fsSL https://opencode.ai/install | bash
```

### Uso

```bash
cd open-gasti
opencode
```

### Comandos Disponibles

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `/add` | Agregar transacción | `/add gasté 5000 en el super` |
| `/balance` | Ver balances | `/balance` |
| `/query` | Ejecutar query | `/query cuánto gasté este mes` |
| `/report` | Generar reporte | `/report` |
| `/validate` | Validar ledger | `/validate` |

### Ejemplos de `/add`

```
/add gasté 5000 en el super con débito
/add ayer pagué 12000 de internet con tarjeta
/add compré zapatillas en 3 cuotas por 30 lucas con visa
/add 100 dólares de freelance
/add cena con amigos 8500 pesos efectivo
```

### Formato Natural Soportado

El parser entiende:
- Montos: `5000`, `5k`, `5 lucas`, `5 mil`, `100 dólares`
- Fechas: `hoy`, `ayer`, `el lunes`, `15/01`
- Pagos: `débito`, `crédito`, `efectivo`, `mercadopago`
- Cuotas: `en 3 cuotas`, `6 cuotas de 5000`

---

## Takopi (Telegram)

### Instalación

```bash
uv tool install -U takopi
```

### Configuración Inicial

```bash
# Ejecutar wizard
takopi

# Seguir los pasos:
# 1. Crear bot en @BotFather
# 2. Elegir workflow (assistant recomendado)
# 3. Conectar chat
# 4. Elegir engine (opencode)
```

### Registrar Proyecto

```bash
cd open-gasti
takopi init gasti
```

### Usar desde Telegram

Enviar mensaje al bot:

```
/gasti gasté 3000 en uber
/gasti cuánto gasté este mes?
/gasti balance
```

O sin prefijo si configuraste `default_project`:

```
gasté 5000 en el super
```

### Configuración Avanzada

```bash
# Ver configuración
takopi config list

# Cambiar engine por defecto
takopi config set default_engine opencode

# Ver proyecto registrado
takopi config get projects.gasti
```

---

## beancount-mcp (Claude/GPT)

Para usar Claude Desktop o GPT con acceso directo al ledger.

Ver [MCP.md](MCP.md) para la guía completa.

---

## Tips

### 1. Validar siempre

Después de agregar transacciones via AI, validar:

```bash
make check
```

### 2. Revisar en Fava

Abrir Fava para ver las transacciones agregadas:

```bash
make fava
```

### 3. Mantener contexto

El archivo `AGENTS.md` le da contexto al AI sobre:
- Estructura de cuentas
- Formato de transacciones
- Reglas de negocio

Mantenerlo actualizado mejora la precisión.

### 4. Usar tags

Para tracking especial, usar tags:
- `#cuotas` - Compras en cuotas
- `#reembolsable` - Gastos a reembolsar
- `#trabajo` - Gastos laborales

### 5. Voice Notes (Takopi)

Takopi soporta notas de voz:
1. Grabar: "Gasté cinco mil pesos en el supermercado con débito"
2. Whisper transcribe → LLM parsea → Transacción creada
