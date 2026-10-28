
-- ============================================================
-- ETL 03 : CHARGEMENT DES DIMENSIONS ET DE LA TABLE DE FAITS
-- ============================================================

USE dw_commerce;

-- ETAPE 1 : Charger les statuts connus.
INSERT IGNORE INTO dim_statut (statut)
SELECT DISTINCT TRIM(statut)
FROM staging_ventes
WHERE statut IS NOT NULL
  AND TRIM(statut) <> '';

-- ETAPE 2 : Préparer la dimension Date.
INSERT IGNORE INTO dim_date (
    date_key,
    date_complete,
    jour,
    mois,
    trimestre,
    annee
)
SELECT DISTINCT
    CAST(DATE_FORMAT(date_convertie, '%Y%m%d') AS UNSIGNED),
    date_convertie,
    DAY(date_convertie),
    MONTH(date_convertie),
    QUARTER(date_convertie),
    YEAR(date_convertie)
FROM (
    SELECT STR_TO_DATE(date_vente, '%Y-%m-%d') AS date_convertie
    FROM staging_ventes
) dates_source
WHERE date_convertie IS NOT NULL;

-- ETAPE 3 : Créer les références minimales des clients.
-- Les attributs descriptifs seront complétés depuis le référentiel.
INSERT IGNORE INTO dim_client (code_client)
SELECT DISTINCT TRIM(code_client)
FROM staging_ventes
WHERE code_client IS NOT NULL
  AND TRIM(code_client) <> '';

-- ETAPE 4 : Créer les références minimales des produits.
INSERT IGNORE INTO dim_produit (code_produit)
SELECT DISTINCT TRIM(code_produit)
FROM staging_ventes
WHERE code_produit IS NOT NULL
  AND TRIM(code_produit) <> '';

-- ETAPE 5 : Créer les références minimales des magasins.
INSERT IGNORE INTO dim_magasin (code_magasin)
SELECT DISTINCT TRIM(code_magasin)
FROM staging_ventes
WHERE code_magasin IS NOT NULL
  AND TRIM(code_magasin) <> '';

-- ETAPE 6 : Charger les ventes admissibles.
-- Conditions :
-- - date valide ;
-- - quantité et prix strictement positifs ;
-- - devise USD ou CDF ;
-- - code de vente unique dans la source ;
-- - références présentes dans toutes les dimensions.

INSERT IGNORE INTO fait_ventes (
    code_vente,
    date_key,
    client_key,
    produit_key,
    magasin_key,
    statut_key,
    quantite,
    prix_unitaire,
    devise,
    montant_ligne
)
SELECT
    st.code_vente,
    CAST(DATE_FORMAT(d.date_convertie, '%Y%m%d') AS UNSIGNED),
    c.client_key,
    p.produit_key,
    m.magasin_key,
    s.statut_key,
    st.quantite,
    st.prix_unitaire,
    st.devise,
    ROUND(st.quantite * st.prix_unitaire, 2)
FROM staging_ventes st
JOIN (
    SELECT code_vente
    FROM staging_ventes
    WHERE code_vente IS NOT NULL
    GROUP BY code_vente
    HAVING COUNT(*) = 1
) ventes_uniques
    ON ventes_uniques.code_vente = st.code_vente
JOIN (
    SELECT
        code_vente,
        STR_TO_DATE(date_vente, '%Y-%m-%d') AS date_convertie
    FROM staging_ventes
) d
    ON d.code_vente = st.code_vente
JOIN dim_client c
    ON c.code_client = st.code_client
JOIN dim_produit p
    ON p.code_produit = st.code_produit
JOIN dim_magasin m
    ON m.code_magasin = st.code_magasin
JOIN dim_statut s
    ON s.statut = TRIM(st.statut)
WHERE d.date_convertie IS NOT NULL
  AND st.quantite > 0
  AND st.prix_unitaire > 0
  AND st.devise IN ('USD', 'CDF')
  AND st.code_vente IS NOT NULL
  AND TRIM(st.code_vente) <> '';

-- ETAPE 7 : Contrôler le résultat du chargement.
SELECT COUNT(*) AS nombre_ventes_chargees
FROM fait_ventes;

SELECT devise, statut, COUNT(*) AS nombre_lignes,
       SUM(montant_ligne) AS montant_total
FROM fait_ventes f
JOIN dim_statut s ON s.statut_key = f.statut_key
GROUP BY devise, statut
ORDER BY devise, statut;
