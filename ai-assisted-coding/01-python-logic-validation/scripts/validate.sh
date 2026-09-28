#!/usr/bin/env bash
set -euo pipefail

echo "PYTHON_VERSION=$(python3 --version 2>&1)"

python3 -m py_compile src/*.py
echo "SYNTAX_COMPILE=PASS"

python3 -m unittest discover -s tests -v
echo "UNIT_TESTS=PASS"

inventory_low=$(printf "5\n10\n" | python3 src/inventario.py)
echo "$inventory_low" | grep -F "Se requiere reposición" >/dev/null
echo "INVENTORY_REPLENISHMENT_CASE=PASS"

inventory_high=$(printf "20\n10\n" | python3 src/inventario.py)
echo "$inventory_high" | grep -F "Inventario suficiente" >/dev/null
echo "INVENTORY_SUFFICIENT_CASE=PASS"

grade_excellent=$(printf "95\n" | python3 src/calificaciones.py)
echo "$grade_excellent" | grep -F "Excelente" >/dev/null
grade_approved=$(printf "80\n" | python3 src/calificaciones.py)
echo "$grade_approved" | grep -F "Aprobado" >/dev/null
grade_failed=$(printf "60\n" | python3 src/calificaciones.py)
echo "$grade_failed" | grep -F "No aprobado" >/dev/null
echo "GRADE_BRANCHES=PASS"

discount_yes=$(printf "300000\n" | python3 src/descuento.py)
echo "$discount_yes" | grep -F 'Descuento aplicado: $30,000' >/dev/null
echo "$discount_yes" | grep -F 'Total a pagar: $270,000' >/dev/null

discount_no=$(printf "100000\n" | python3 src/descuento.py)
echo "$discount_no" | grep -F 'Descuento aplicado: $0' >/dev/null
echo "$discount_no" | grep -F 'Total a pagar: $100,000' >/dev/null
echo "DISCOUNT_BRANCHES=PASS"

echo
echo "VALIDATION_RESULT=PASS"
