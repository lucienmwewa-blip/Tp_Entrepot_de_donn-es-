
USE dw_commerce;

-- REQUÊTE 1 : Chiffre d'affaires par magasin et par devise
SELECT
    m.nom_magasin,
    f.devise,
    SUM(f.montant_ligne) AS chiffre_affaires,
    COUNT(*) AS nombre_lignes_vente
FROM fait_ventes f
JOIN dim_magasin m ON f.magasin_key = m.magasin_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Paid'
GROUP BY m.nom_magasin, f.devise
ORDER BY f.devise, chiffre_affaires DESC;


-- REQUÊTE 2 : Chiffre d'affaires par catégorie de produit
SELECT
    p.categorie,
    f.devise,
    SUM(f.montant_ligne) AS chiffre_affaires
FROM fait_ventes f
JOIN dim_produit p ON f.produit_key = p.produit_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Paid'
GROUP BY p.categorie, f.devise
ORDER BY f.devise, chiffre_affaires DESC;


-- REQUÊTE 3 : Classement des produits par quantité vendue
SELECT
    p.code_produit,
    p.nom_produit,
    SUM(f.quantite) AS quantite_totale_vendue
FROM fait_ventes f
JOIN dim_produit p ON f.produit_key = p.produit_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Paid'
GROUP BY p.code_produit, p.nom_produit
ORDER BY quantite_totale_vendue DESC
LIMIT 10;


-- REQUÊTE 4 : Évolution mensuelle du chiffre d'affaires
SELECT
    d.annee,
    d.mois,
    f.devise,
    SUM(f.montant_ligne) AS chiffre_affaires
FROM fait_ventes f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Paid'
GROUP BY d.annee, d.mois, f.devise
ORDER BY d.annee, d.mois, f.devise;


-- REQUÊTE 5 : Répartition des ventes selon le statut
SELECT
    s.statut,
    f.devise,
    COUNT(*) AS nombre_lignes,
    SUM(f.montant_ligne) AS montant_total
FROM fait_ventes f
JOIN dim_statut s ON f.statut_key = s.statut_key
GROUP BY s.statut, f.devise
ORDER BY s.statut, f.devise;


-- REQUÊTE 6 : Principaux clients par montant d'achat
SELECT
    c.code_client,
    c.segment,
    c.ville,
    f.devise,
    SUM(f.montant_ligne) AS montant_achats
FROM fait_ventes f
JOIN dim_client c ON f.client_key = c.client_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Paid'
GROUP BY c.code_client, c.segment, c.ville, f.devise
ORDER BY f.devise, montant_achats DESC
LIMIT 10;
