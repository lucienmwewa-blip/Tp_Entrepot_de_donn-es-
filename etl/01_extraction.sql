
-- ============================================================
-- ETL 01 : EXTRACTION ET PREPARATION DES DONNEES
-- Projet : Data Warehouse Commerce
-- SGBD : MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS dw_commerce
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE dw_commerce;

-- Table temporaire logique de préparation des ventes.
-- Les dates sont conservées en texte pour permettre
-- de détecter les dates invalides avant conversion.

CREATE TABLE IF NOT EXISTS staging_ventes (
    code_vente       VARCHAR(30),
    date_vente       VARCHAR(50),
    code_client      VARCHAR(30),
    code_produit     VARCHAR(30),
    code_magasin     VARCHAR(30),
    quantite         DECIMAL(12,2),
    prix_unitaire    DECIMAL(12,2),
    devise           VARCHAR(10),
    statut           VARCHAR(50)
);

-- Vérifier le volume importé.
SELECT COUNT(*) AS nombre_lignes_extraites
FROM staging_ventes;

-- Examiner les premières lignes.
SELECT *
FROM staging_ventes
LIMIT 20;

-- Examiner les valeurs de statut.
SELECT statut, COUNT(*) AS nombre_lignes
FROM staging_ventes
GROUP BY statut
ORDER BY nombre_lignes DESC;

-- Examiner les devises présentes.
SELECT devise, COUNT(*) AS nombre_lignes
FROM staging_ventes
GROUP BY devise
ORDER BY devise;

-- Vérifier les doublons de code de vente.
SELECT
    code_vente,
    COUNT(*) AS occurrences
FROM staging_ventes
WHERE code_vente IS NOT NULL
GROUP BY code_vente
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;
