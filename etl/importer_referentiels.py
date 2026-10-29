import csv
from decimal import Decimal
from pathlib import Path
import mysql.connector

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"

conn = mysql.connector.connect(
    host="localhost",
    user="tp_user",
    password="TP_Commerce_2026!",
    database="dw_commerce"
)

cursor = conn.cursor()

def lire_csv(nom_fichier):
    chemin = DATA_DIR / nom_fichier
    with open(chemin, encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f, delimiter=";"))

try:
    clients = lire_csv("clients.csv")
    produits = lire_csv("produits.csv")
    magasins = lire_csv("magasin.csv")

    for r in clients:
        cursor.execute("""
            INSERT INTO dim_client (code_client, segment, ville)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE
            segment = VALUES(segment), ville = VALUES(ville)
        """, (r["code_client"].strip(), r["segment"].strip(), r["ville"].strip()))

    for r in produits:
        prix = r["prix_catalogue_usd"].strip().replace(",", ".")
        cursor.execute("""
            INSERT INTO dim_produit
            (code_produit, nom_produit, categorie, prix_catalogue_usd)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE
            nom_produit = VALUES(nom_produit),
            categorie = VALUES(categorie),
            prix_catalogue_usd = VALUES(prix_catalogue_usd)
        """, (
            r["code_produit"].strip(),
            r["nom_produit"].strip(),
            r["categorie"].strip(),
            Decimal(prix) if prix else None
        ))

    for r in magasins:
        cursor.execute("""
            INSERT INTO dim_magasin (code_magasin, nom_magasin, ville)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE
            nom_magasin = VALUES(nom_magasin), ville = VALUES(ville)
        """, (
            r["code_magasin"].strip(),
            r["nom_magasin"].strip(),
            r["ville"].strip()
        ))

    conn.commit()
    print("Clients lus :", len(clients))
    print("Produits lus :", len(produits))
    print("Magasins lus :", len(magasins))
    print("Chargement des référentiels terminé.")

except Exception:
    conn.rollback()
    raise

finally:
    cursor.close()
    conn.close()
