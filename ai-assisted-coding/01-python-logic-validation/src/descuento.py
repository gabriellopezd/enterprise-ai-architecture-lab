def calcular_compra(valor_compra: float) -> tuple[float, float]:
    """Return discount and final total using the exercise threshold."""
    if valor_compra >= 200000:
        descuento = valor_compra * 0.10
    else:
        descuento = 0.0
    total_pagar = valor_compra - descuento
    return descuento, total_pagar


def main() -> None:
    valor_compra = float(input("Ingrese el valor de la compra: "))
    descuento, total_pagar = calcular_compra(valor_compra)

    print(f"Valor de la compra: ${valor_compra:,.0f}")
    print(f"Descuento aplicado: ${descuento:,.0f}")
    print(f"Total a pagar: ${total_pagar:,.0f}")


if __name__ == "__main__":
    main()
