from datetime import datetime
from decimal import Decimal
import mysql.connector

DB_CONFIG = {
    "host": "localhost",
    "user": "tp_user",
    "password": "TP_Commerce_2026!",
    "database": "dw_commerce",
}

def convertir_date(valeur):
    try:
        return datetime.strptime(valeur.strip(), "%Y-%m-%d").date()
    except (ValueError, AttributeError):
        return None

conn = mysql.connector.connect(**DB_CONFIG)
cur = conn.cursor(dictionary=True)

try:
    cur.execute("""
        SELECT code_vente, date_vente, code_client, code_produit,
               code_magasin, quantite, prix_unitaire, devise, statut
        FROM staging_ventes
    """)
    ventes = cur.fetchall()

    # Charger les statuts de référence.
    for statut in ("Payée", "En attente", "Annulée"):
        cur.execute(
            "INSERT INTO dim_statut (statut) VALUES (%s) "
            "ON DUPLICATE KEY UPDATE statut = VALUES(statut)",
            (statut,)
        )

    # Préparer les dates valides.
    dates = set()
    for vente in ventes:
        date_valide = convertir_date(vente["date_vente"])
        if date_valide:
            dates.add(date_valide)

    for d in dates:
        date_key = int(d.strftime("%Y%m%d"))
        cur.execute("""
            INSERT INTO dim_date
                (date_key, date_complete, jour, mois, trimestre, annee)
            VALUES (%s, %s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE date_complete = VALUES(date_complete)
        """, (
            date_key, d, d.day, d.month, (d.month - 1) // 3 + 1, d.year
        ))

    conn.commit()

    chargees = 0
    rejetees = 0

    for v in ventes:
        d = convertir_date(v["date_vente"])
        raison = None

        if not d:
            raison = "DATE_INVALIDE"
        elif not v["code_client"] or v["code_client"] == "CL9999":
            raison = "CLIENT_INCONNU"
        elif v["quantite"] is None or v["quantite"] <= 0:
            raison = "QUANTITE_INVALIDE"
        elif v["prix_unitaire"] is None or v["prix_unitaire"] <= 0:
            raison = "PRIX_INVALIDE"
        elif v["devise"] not in ("USD", "CDF"):
            raison = "DEVISE_INVALIDE"

        if raison:
            rejetees += 1
            continue

        cur.execute(
            "SELECT client_key FROM dim_client WHERE code_client = %s",
            (v["code_client"],)
        )
        client = cur.fetchone()

        cur.execute(
            "SELECT produit_key FROM dim_produit WHERE code_produit = %s",
            (v["code_produit"],)
        )
        produit = cur.fetchone()

        cur.execute(
            "SELECT magasin_key FROM dim_magasin WHERE code_magasin = %s",
            (v["code_magasin"],)
        )
        magasin = cur.fetchone()

        cur.execute(
            "SELECT statut_key FROM dim_statut WHERE statut = %s",
            (v["statut"],)
        )
        statut = cur.fetchone()

        if not client or not produit or not magasin or not statut:
            rejetees += 1
            continue

        date_key = int(d.strftime("%Y%m%d"))
        montant = Decimal(str(v["quantite"])) * Decimal(str(v["prix_unitaire"]))

        cur.execute("""
            INSERT INTO fait_ventes
                (code_vente, date_key, client_key, produit_key,
                 magasin_key, statut_key, quantite, prix_unitaire,
                 devise, montant_ligne)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            v["code_vente"], date_key, client["client_key"],
            produit["produit_key"], magasin["magasin_key"],
            statut["statut_key"], v["quantite"], v["prix_unitaire"],
            v["devise"], montant
        ))
        chargees += 1

    conn.commit()
    print("Lignes de staging :", len(ventes))
    print("Ventes chargées :", chargees)
    print("Lignes écartées :", rejetees)

except Exception:
    conn.rollback()
    raise

finally:
    cur.close()
    conn.close()
