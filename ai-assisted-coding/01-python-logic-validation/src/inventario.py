def evaluar_reposicion(cantidad_disponible: int, nivel_minimo: int) -> str:
    """Return the inventory decision for the provided stock levels."""
    if cantidad_disponible <= nivel_minimo:
        return "Se requiere reposición"
    return "Inventario suficiente"


def main() -> None:
    cantidad_disponible = int(input("Ingrese la cantidad disponible: "))
    nivel_minimo = int(input("Ingrese el nivel mínimo de inventario: "))
    print(evaluar_reposicion(cantidad_disponible, nivel_minimo))


if __name__ == "__main__":
    main()
