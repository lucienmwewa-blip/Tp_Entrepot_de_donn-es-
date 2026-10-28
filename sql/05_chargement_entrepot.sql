
USE dw_commerce;

-- ETAPE 1 : Verifier les lignes disponibles dans la zone de staging.
-- La table staging_ventes doit avoir ete creee et chargee au prealable.

SELECT COUNT(*) AS nombre_lignes_source
FROM staging_ventes;


-- ETAPE 2 : Verifier les doublons de codes de vente.
SELECT
    code_vente,
    COUNT(*) AS nombre_occurrences
FROM staging_ventes
WHERE code_vente IS NOT NULL
GROUP BY code_vente
HAVING COUNT(*) > 1
ORDER BY nombre_occurrences DESC;


-- ETAPE 3 : Verifier les valeurs manquantes essentielles.
SELECT COUNT(*) AS lignes_incompletes
FROM staging_ventes
WHERE code_vente IS NULL
   OR date_vente IS NULL
   OR code_client IS NULL
   OR code_produit IS NULL
   OR code_magasin IS NULL
   OR quantite IS NULL
   OR prix_unitaire IS NULL
   OR devise IS NULL
   OR statut IS NULL;


-- ETAPE 4 : Verifier les quantites non positives.
SELECT COUNT(*) AS quantites_invalides
FROM staging_ventes
WHERE quantite <= 0;


-- ETAPE 5 : Verifier les prix non positifs.
SELECT COUNT(*) AS prix_invalides
FROM staging_ventes
WHERE prix_unitaire <= 0;


-- ETAPE 6 : Verifier les devises autorisees.
SELECT devise, COUNT(*) AS nombre_lignes
FROM staging_ventes
GROUP BY devise
ORDER BY devise;


-- ETAPE 7 : Verifier les references clients inconnues.
SELECT
    st.code_client,
    COUNT(*) AS nombre_lignes
FROM staging_ventes st
LEFT JOIN dim_client dc
    ON st.code_client = dc.code_client
WHERE dc.client_key IS NULL
GROUP BY st.code_client;


-- ETAPE 8 : Verifier les references produits inconnues.
SELECT
    st.code_produit,
    COUNT(*) AS nombre_lignes
FROM staging_ventes st
LEFT JOIN dim_produit dp
    ON st.code_produit = dp.code_produit
WHERE dp.produit_key IS NULL
GROUP BY st.code_produit;


-- ETAPE 9 : Verifier les references magasins inconnues.
SELECT
    st.code_magasin,
    COUNT(*) AS nombre_lignes
FROM staging_ventes st
LEFT JOIN dim_magasin dm
    ON st.code_magasin = dm.code_magasin
WHERE dm.magasin_key IS NULL
GROUP BY st.code_magasin;


-- ETAPE 10 : Verifier les statuts presents dans la source.
SELECT statut, COUNT(*) AS nombre_lignes
FROM staging_ventes
GROUP BY statut
ORDER BY statut;
