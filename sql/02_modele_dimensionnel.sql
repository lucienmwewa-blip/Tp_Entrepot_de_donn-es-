
-- =========================================================
-- TP DATA WAREHOUSE COMMERCE - ISC LUBUMBASHI
-- Etape 3 : modele dimensionnel en etoile
-- SGBD : MySQL 8.0+
-- =========================================================

USE dw_commerce;

-- 1. Dimension Date
CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    date_complete DATE NOT NULL UNIQUE,
    jour INT NOT NULL,
    mois INT NOT NULL,
    trimestre INT NOT NULL,
    annee INT NOT NULL
);

-- 2. Dimension Client
CREATE TABLE IF NOT EXISTS dim_client (
    client_key INT AUTO_INCREMENT PRIMARY KEY,
    code_client VARCHAR(30) NOT NULL UNIQUE,
    segment VARCHAR(100),
    ville VARCHAR(100)
);

-- 3. Dimension Produit
CREATE TABLE IF NOT EXISTS dim_produit (
    produit_key INT AUTO_INCREMENT PRIMARY KEY,
    code_produit VARCHAR(30) NOT NULL UNIQUE,
    nom_produit VARCHAR(150),
    categorie VARCHAR(100),
    prix_catalogue_usd DECIMAL(12,2)
);

-- 4. Dimension Magasin
CREATE TABLE IF NOT EXISTS dim_magasin (
    magasin_key INT AUTO_INCREMENT PRIMARY KEY,
    code_magasin VARCHAR(30) NOT NULL UNIQUE,
    nom_magasin VARCHAR(150),
    ville VARCHAR(100)
);

-- 5. Dimension Statut
CREATE TABLE IF NOT EXISTS dim_statut (
    statut_key INT AUTO_INCREMENT PRIMARY KEY,
    statut VARCHAR(50) NOT NULL UNIQUE
);

-- 6. Table de faits des ventes
CREATE TABLE IF NOT EXISTS fait_ventes (
    vente_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    code_vente VARCHAR(30) NOT NULL UNIQUE,

    date_key INT NOT NULL,
    client_key INT NOT NULL,
    produit_key INT NOT NULL,
    magasin_key INT NOT NULL,
    statut_key INT NOT NULL,

    quantite DECIMAL(12,2) NOT NULL,
    prix_unitaire DECIMAL(12,2) NOT NULL,
    devise VARCHAR(3) NOT NULL,
    montant_ligne DECIMAL(16,2) NOT NULL,

    CONSTRAINT fk_ventes_date
        FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key),

    CONSTRAINT fk_ventes_client
        FOREIGN KEY (client_key)
        REFERENCES dim_client(client_key),

    CONSTRAINT fk_ventes_produit
        FOREIGN KEY (produit_key)
        REFERENCES dim_produit(produit_key),

    CONSTRAINT fk_ventes_magasin
        FOREIGN KEY (magasin_key)
        REFERENCES dim_magasin(magasin_key),

    CONSTRAINT fk_ventes_statut
        FOREIGN KEY (statut_key)
        REFERENCES dim_statut(statut_key),

    CONSTRAINT chk_ventes_quantite
        CHECK (quantite > 0),

    CONSTRAINT chk_ventes_prix
        CHECK (prix_unitaire > 0),

    CONSTRAINT chk_ventes_devise
        CHECK (devise IN ('USD', 'CDF')),

    CONSTRAINT chk_ventes_montant
        CHECK (montant_ligne > 0)
);

-- Index utiles pour les analyses
CREATE INDEX idx_ventes_date
    ON fait_ventes(date_key);

CREATE INDEX idx_ventes_produit
    ON fait_ventes(produit_key);

CREATE INDEX idx_ventes_magasin
    ON fait_ventes(magasin_key);

CREATE INDEX idx_ventes_statut
    ON fait_ventes(statut_key);
