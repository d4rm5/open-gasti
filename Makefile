.PHONY: help install sync check validate fava fava-debug prices update report balance net-worth queries clean backup

# Default target
help:
	@echo "╔═══════════════════════════════════════════════════════════════╗"
	@echo "║  open-gasti - Finanzas Personales Argentina                   ║"
	@echo "╚═══════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Comandos disponibles:"
	@echo ""
	@echo "  Configuración:"
	@echo "    make install     Instalar dependencias con UV"
	@echo "    make sync        Sincronizar dependencias desde lock"
	@echo ""
	@echo "  Validación:"
	@echo "    make check       Validar sintaxis beancount"
	@echo "    make validate    Ejecutar suite completa de validación"
	@echo ""
	@echo "  Interfaz:"
	@echo "    make fava        Abrir Fava (http://localhost:5000)"
	@echo "    make fava-debug  Abrir Fava en modo debug"
	@echo "    make queries     Abrir consola de queries"
	@echo ""
	@echo "  Actualización:"
	@echo "    make prices      Obtener cotización dólar blue"
	@echo "    make update      Actualizar todo (precios + validación)"
	@echo ""
	@echo "  Reportes:"
	@echo "    make report      Generar reporte mensual"
	@echo "    make balance     Ver balances actuales"
	@echo "    make net-worth   Ver patrimonio neto en USD"
	@echo ""
	@echo "  Mantenimiento:"
	@echo "    make clean       Limpiar archivos generados"
	@echo "    make backup      Crear backup manual"

# Setup
install:
	uv sync
	@echo "✓ Dependencias instaladas"

sync:
	uv sync
	@echo "✓ Dependencias sincronizadas"

# Validation
check:
	uv run bean-check main.bean

validate:
	bash scripts/validate.sh

# Interface
fava:
	@echo "Abriendo Fava en http://localhost:5000"
	uv run fava main.bean

fava-debug:
	uv run fava main.bean --debug

queries:
	uv run bean-query main.bean

# Updates
prices:
	uv run python scripts/fetch_prices.py

update:
	bash scripts/update_all.sh

# Reports
report:
	bash scripts/monthly_report.sh

balance:
	uv run bean-report main.bean balances

net-worth:
	@echo "Patrimonio Neto (USD):"
	@uv run bean-query main.bean "SELECT sum(convert(position, 'USD')) AS total WHERE account ~ 'Assets|Liabilities'"

# Maintenance
clean:
	rm -rf reports/*.txt reports/*.md
	rm -f prices/auto-generated.bean
	rm -rf __pycache__ .ruff_cache
	@echo "✓ Archivos generados eliminados"

backup:
	@mkdir -p backups/manual-$$(date +%Y%m%d-%H%M%S)
	@cp main.bean backups/manual-$$(date +%Y%m%d-%H%M%S)/
	@cp -r config backups/manual-$$(date +%Y%m%d-%H%M%S)/
	@cp -r transactions backups/manual-$$(date +%Y%m%d-%H%M%S)/
	@cp -r prices backups/manual-$$(date +%Y%m%d-%H%M%S)/
	@echo "✓ Backup creado en backups/manual-$$(date +%Y%m%d-%H%M%S)"
