
import csv
import mysql.connector
from decimal import Decimal, InvalidOperation
from pathlib import Path

# Chemin du fichier CSV
BASE_DIR = Path(__file__).resolve().parent.parent
CSV_FILE = BASE_DIR / "data" / "vente_mysql.csv"

# Connexion locale au serveur MySQL de Codespaces
conn = mysql.connector.connect(
    host="localhost",
    user="tp_user",
    password="TP_Commerce_2026!",
    database="dw_commerce"
)

cursor = conn.cursor()

sql = """
INSERT INTO staging_ventes (
    code_vente, date_vente, code_client, code_produit,
    code_magasin, quantite, prix_unitaire, devise, statut
)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

inserted = 0
errors = []

try:
    with open(CSV_FILE, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f, delimiter=";")

        for line_number, row in enumerate(reader, start=2):
            try:
                quantity = Decimal(row["quantite"].strip().replace(",", "."))
                price_text = row["prix_unitaire"].strip().replace(",", ".")
                price = Decimal(price_text) if price_text else None

                values = (
                    row["code_vente"].strip(),
                    row["date_vente"].strip(),
                    row["code_client"].strip(),
                    row["code_produit"].strip(),
                    row["code_magasin"].strip(),
                    quantity,
                    price,
                    row["devise"].strip(),
                    row["statut"].strip()
                )

                cursor.execute(sql, values)
                inserted += 1

            except (KeyError, ValueError, InvalidOperation) as exc:
                errors.append(f"Ligne {line_number} : {exc}")

    conn.commit()

    print(f"Lignes insérées : {inserted}")
    print(f"Lignes en erreur : {len(errors)}")

    for error in errors[:20]:
        print(error)

except Exception:
    conn.rollback()
    raise

finally:
    cursor.close()
    conn.close()
