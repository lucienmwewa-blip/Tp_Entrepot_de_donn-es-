
-- =========================================================
-- TP DATA WAREHOUSE COMMERCE - ISC LUBUMBASHI
-- Etape 4 : controles de qualite
-- MySQL 8.0+
--
-- PRE-REQUIS :
-- Les tables de staging doivent etre chargees depuis Excel.
-- Colonnes attendues dans staging_ventes :
-- code_vente, date_vente, code_client, code_produit,
-- code_magasin, quantite, prix_unitaire, devise, statut.
-- =========================================================

USE dw_commerce;

-- 1. Zone de staging : exemple de structure brute.
-- date_vente est en texte pour permettre de reperer
-- les dates invalides sans bloquer l'importation.

CREATE TABLE IF NOT EXISTS staging_ventes (
    code_vente VARCHAR(30),
    date_vente VARCHAR(50),
    code_client VARCHAR(30),
    code_produit VARCHAR(30),
    code_magasin VARCHAR(30),
    quantite DECIMAL(12,2),
    prix_unitaire DECIMAL(12,2),
    devise VARCHAR(10),
    statut VARCHAR(50)
);

-- 2. Table de journalisation des anomalies.

CREATE TABLE IF NOT EXISTS rejets_qualite (
    rejet_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code_vente VARCHAR(30),
    type_anomalie VARCHAR(100) NOT NULL,
    description_anomalie VARCHAR(500),
    date_detection TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Volume total des donnees importees.

SELECT COUNT(*) AS nombre_lignes_source
FROM staging_ventes;

-- 4. Codes de vente dupliques.

SELECT
    code_vente,
    COUNT(*) AS occurrences
FROM staging_ventes
GROUP BY code_vente
HAVING code_vente IS NULL
    OR TRIM(code_vente) = ''
    OR COUNT(*) > 1;

-- 5. Valeurs manquantes essentielles.

SELECT *
FROM staging_ventes
WHERE code_vente IS NULL OR TRIM(code_vente) = ''
   OR date_vente IS NULL OR TRIM(date_vente) = ''
   OR code_client IS NULL OR TRIM(code_client) = ''
   OR code_produit IS NULL OR TRIM(code_produit) = ''
   OR code_magasin IS NULL OR TRIM(code_magasin) = ''
   OR quantite IS NULL
   OR prix_unitaire IS NULL
   OR devise IS NULL OR TRIM(devise) = ''
   OR statut IS NULL OR TRIM(statut) = '';

-- 6. Quantites nulles ou negatives.

SELECT *
FROM staging_ventes
WHERE quantite IS NULL OR quantite <= 0;

-- 7. Prix unitaires non positifs ou manquants.

SELECT *
FROM staging_ventes
WHERE prix_unitaire IS NULL OR prix_unitaire <= 0;

-- 8. Devises non autorisees.

SELECT *
FROM staging_ventes
WHERE devise IS NULL
   OR UPPER(TRIM(devise)) NOT IN ('USD', 'CDF');

-- 9. Dates invalides au format AAAA-MM-JJ.
-- Adapter ce controle si le fichier source utilise
-- un autre format de date.

SELECT *
FROM staging_ventes
WHERE date_vente IS NOT NULL
  AND TRIM(date_vente) <> ''
  AND (
      STR_TO_DATE(date_vente, '%Y-%m-%d') IS NULL
      OR DATE_FORMAT(
          STR_TO_DATE(date_vente, '%Y-%m-%d'),
          '%Y-%m-%d'
      ) <> date_vente
  );

-- 10. References clients absentes du referentiel.

SELECT s.*
FROM staging_ventes s
LEFT JOIN dim_client d
    ON TRIM(s.code_client) = d.code_client
WHERE d.code_client IS NULL;

-- 11. References produits absentes du referentiel.

SELECT s.*
FROM staging_ventes s
LEFT JOIN dim_produit d
    ON TRIM(s.code_produit) = d.code_produit
WHERE d.code_produit IS NULL;

-- 12. References magasins absentes du referentiel.

SELECT s.*
FROM staging_ventes s
LEFT JOIN dim_magasin d
    ON TRIM(s.code_magasin) = d.code_magasin
WHERE d.code_magasin IS NULL;

-- FIN DES CONTROLES
-- Les resultats doivent etre examines avant le chargement.
-- Ne pas supprimer automatiquement les lignes source.
