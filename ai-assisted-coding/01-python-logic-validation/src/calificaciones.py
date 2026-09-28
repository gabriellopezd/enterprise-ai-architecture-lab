def clasificar_calificacion(calificacion: float) -> str:
    """Classify a score using the thresholds from the learning exercise."""
    if calificacion >= 90:
        return "Excelente"
    if calificacion >= 70:
        return "Aprobado"
    return "No aprobado"


def main() -> None:
    calificacion = float(input("Ingrese la calificación entre 0 y 100: "))
    print(clasificar_calificacion(calificacion))


if __name__ == "__main__":
    main()
