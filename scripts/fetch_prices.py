#!/usr/bin/env python3
"""
Fetch dollar rates from DolarAPI.

API: https://dolarapi.com/

Usage:
    uv run python scripts/fetch_prices.py
    uv run python scripts/fetch_prices.py --all  # Fetch all dollar types

Output:
    - Writes to prices/auto-generated.bean
    - Prints current rates to stdout
"""

import argparse
import sys
from datetime import date
from pathlib import Path

import requests

# DolarAPI - Current rates
DOLARAPI_BASE = "https://dolarapi.com/v1"
DOLARAPI_DOLARES = f"{DOLARAPI_BASE}/dolares"

# Dollar types available
CASAS = ["oficial", "blue", "bolsa", "contadoconliqui", "mayorista", "cripto"]


def fetch_current_rate(casa: str = "blue") -> dict | None:
    """Fetch current rate from DolarAPI."""
    try:
        response = requests.get(f"{DOLARAPI_BASE}/dolares/{casa}", timeout=10)
        response.raise_for_status()
        data = response.json()
        return {
            "casa": data["casa"],
            "nombre": data.get("nombre", casa.title()),
            "compra": data["compra"],
            "venta": data["venta"],
            "fecha": data.get("fechaActualizacion", str(date.today())),
        }
    except requests.RequestException as e:
        print(f"Error fetching from DolarAPI: {e}", file=sys.stderr)
        return None


def fetch_all_current_rates() -> list[dict]:
    """Fetch all current dollar rates."""
    try:
        response = requests.get(DOLARAPI_DOLARES, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        print(f"Error fetching all rates: {e}", file=sys.stderr)
        return []


def write_prices(rates: list[dict], primary_casa: str = "blue") -> None:
    """Write price directives to auto-generated.bean file."""
    today = date.today()
    output_file = Path(__file__).parent.parent / "prices" / "auto-generated.bean"
    output_file.parent.mkdir(parents=True, exist_ok=True)

    lines = [
        "; ═══════════════════════════════════════════════════════════════",
        f"; Auto-generated prices - {today}",
        "; Source: DolarAPI (https://dolarapi.com)",
        "; Run: make prices",
        "; ═══════════════════════════════════════════════════════════════",
        "",
    ]

    # Find the primary rate (usually blue) for USD price directive
    primary_rate = None
    for rate in rates:
        if rate.get("casa") == primary_casa:
            primary_rate = rate
            break

    if primary_rate:
        venta = primary_rate["venta"]
        lines.append(f"; USD at {primary_casa} rate (venta)")
        lines.append(f"{today} price USD {venta:.2f} ARS")
        lines.append("")

    # Add comments with all rates for reference
    lines.append("; ─────────────────────────────────────────────────────────────────")
    lines.append("; All rates (for reference):")
    lines.append("; ─────────────────────────────────────────────────────────────────")
    for rate in rates:
        casa = rate.get("casa", "unknown")
        nombre = rate.get("nombre", casa.title())
        compra = rate.get("compra", 0)
        venta = rate.get("venta", 0)
        lines.append(f"; {nombre}: compra={compra:.2f}, venta={venta:.2f}")

    lines.append("")
    output_file.write_text("\n".join(lines))
    print(f"✓ Wrote prices to {output_file}")


def main() -> None:
    """Main entry point."""
    parser = argparse.ArgumentParser(description="Fetch Argentine dollar rates")
    parser.add_argument("--all", action="store_true", help="Fetch all dollar types, not just blue")
    parser.add_argument(
        "--casa",
        default="blue",
        choices=CASAS,
        help="Primary dollar type for price directive (default: blue)",
    )
    args = parser.parse_args()

    print("Fetching dollar rates from DolarAPI...")
    print()

    if args.all:
        rates = fetch_all_current_rates()
        if not rates:
            print("Failed to fetch rates", file=sys.stderr)
            sys.exit(1)
    else:
        rate = fetch_current_rate(args.casa)
        if not rate:
            print("Failed to fetch rates", file=sys.stderr)
            sys.exit(1)
        rates = [rate]

    # Display rates
    print("Cotizaciones actuales:")
    print("─" * 50)
    for rate in rates:
        casa = rate.get("casa", "unknown")
        nombre = rate.get("nombre", casa.title())
        compra = rate.get("compra", 0)
        venta = rate.get("venta", 0)
        print(f"  {nombre:20} │ Compra: ${compra:>10,.2f} │ Venta: ${venta:>10,.2f}")
    print("─" * 50)
    print()

    write_prices(rates, primary_casa=args.casa)


if __name__ == "__main__":
    main()
