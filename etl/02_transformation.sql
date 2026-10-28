
-- ============================================================
-- ETL 02 : TRANSFORMATION ET CONTROLES QUALITE
-- ============================================================

USE dw_commerce;

-- Journal des anomalies détectées.
CREATE TABLE IF NOT EXISTS rejets_qualite (
    rejet_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code_vente VARCHAR(30),
    type_anomalie VARCHAR(80) NOT NULL,
    description_anomalie VARCHAR(255),
    date_detection TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Détecter les champs obligatoires manquants.
INSERT INTO rejets_qualite
    (code_vente, type_anomalie, description_anomalie)
SELECT
    code_vente,
    'CHAMP_MANQUANT',
    'Un ou plusieurs champs obligatoires sont absents'
FROM staging_ventes
WHERE code_vente IS NULL
   OR TRIM(code_vente) = ''
   OR date_vente IS NULL
   OR TRIM(date_vente) = ''
   OR code_client IS NULL
   OR TRIM(code_client) = ''
   OR code_produit IS NULL
   OR TRIM(code_produit) = ''
   OR code_magasin IS NULL
   OR TRIM(code_magasin) = ''
   OR quantite IS NULL
   OR prix_unitaire IS NULL
   OR devise IS NULL
   OR statut IS NULL;

-- Détecter les quantités non positives.
INSERT INTO rejets_qualite
    (code_vente, type_anomalie, description_anomalie)
SELECT
    code_vente,
    'QUANTITE_INVALIDE',
    'La quantité doit être strictement positive'
FROM staging_ventes
WHERE quantite IS NOT NULL
  AND quantite <= 0;

-- Détecter les prix non positifs.
INSERT INTO rejets_qualite
    (code_vente, type_anomalie, description_anomalie)
SELECT
    code_vente,
    'PRIX_INVALIDE',
    'Le prix unitaire doit être strictement positif'
FROM staging_ventes
WHERE prix_unitaire IS NOT NULL
  AND prix_unitaire <= 0;

-- Détecter les devises non autorisées.
INSERT INTO rejets_qualite
    (code_vente, type_anomalie, description_anomalie)
SELECT
    code_vente,
    'DEVISE_INVALIDE',
    CONCAT('Devise non autorisée : ', devise)
FROM staging_ventes
WHERE devise IS NOT NULL
  AND devise NOT IN ('USD', 'CDF');

-- Détecter les dates qui ne respectent pas le format attendu.
-- Cette règle suppose un format source YYYY-MM-DD.
INSERT INTO rejets_qualite
    (code_vente, type_anomalie, description_anomalie)
SELECT
    code_vente,
    'DATE_INVALIDE',
    CONCAT('Date absente ou invalide : ', COALESCE(date_vente, 'NULL'))
FROM staging_ventes
WHERE date_vente IS NULL
   OR STR_TO_DATE(date_vente, '%Y-%m-%d') IS NULL;

-- Préparer une vue des lignes de base conformes.
-- La déduplication et les références doivent aussi être validées.
CREATE OR REPLACE VIEW v_ventes_controlees AS
SELECT
    code_vente,
    STR_TO_DATE(date_vente, '%Y-%m-%d') AS date_vente_convertie,
    code_client,
    code_produit,
    code_magasin,
    quantite,
    prix_unitaire,
    devise,
    statut,
    ROUND(quantite * prix_unitaire, 2) AS montant_calcule
FROM staging_ventes
WHERE code_vente IS NOT NULL
  AND TRIM(code_vente) <> ''
  AND date_vente IS NOT NULL
  AND STR_TO_DATE(date_vente, '%Y-%m-%d') IS NOT NULL
  AND code_client IS NOT NULL
  AND code_produit IS NOT NULL
  AND code_magasin IS NOT NULL
  AND quantite > 0
  AND prix_unitaire > 0
  AND devise IN ('USD', 'CDF')
  AND statut IS NOT NULL;

-- Résumé des rejets par catégorie.
SELECT
    type_anomalie,
    COUNT(*) AS nombre_rejets
FROM rejets_qualite
GROUP BY type_anomalie
ORDER BY nombre_rejets DESC;
