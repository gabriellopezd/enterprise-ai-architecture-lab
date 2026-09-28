import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from inventario import evaluar_reposicion
from calificaciones import clasificar_calificacion
from descuento import calcular_compra


class InventarioTests(unittest.TestCase):
    def test_reposicion_below_minimum(self):
        self.assertEqual(evaluar_reposicion(5, 10), "Se requiere reposición")

    def test_reposicion_at_minimum(self):
        self.assertEqual(evaluar_reposicion(10, 10), "Se requiere reposición")

    def test_inventory_sufficient(self):
        self.assertEqual(evaluar_reposicion(20, 10), "Inventario suficiente")


class CalificacionesTests(unittest.TestCase):
    def test_excelente(self):
        self.assertEqual(clasificar_calificacion(95), "Excelente")

    def test_excelente_boundary(self):
        self.assertEqual(clasificar_calificacion(90), "Excelente")

    def test_aprobado(self):
        self.assertEqual(clasificar_calificacion(80), "Aprobado")

    def test_aprobado_boundary(self):
        self.assertEqual(clasificar_calificacion(70), "Aprobado")

    def test_no_aprobado(self):
        self.assertEqual(clasificar_calificacion(60), "No aprobado")


class DescuentoTests(unittest.TestCase):
    def test_discount_applied(self):
        descuento, total = calcular_compra(300000)
        self.assertEqual(descuento, 30000)
        self.assertEqual(total, 270000)

    def test_discount_threshold(self):
        descuento, total = calcular_compra(200000)
        self.assertEqual(descuento, 20000)
        self.assertEqual(total, 180000)

    def test_no_discount(self):
        descuento, total = calcular_compra(100000)
        self.assertEqual(descuento, 0)
        self.assertEqual(total, 100000)


if __name__ == "__main__":
    unittest.main()
