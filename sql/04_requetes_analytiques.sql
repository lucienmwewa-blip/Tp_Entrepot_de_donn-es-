USE dw_commerce;

-- REQUETE 1 : Ventes par magasin et categorie de produit
SELECT
    m.nom_magasin,
    p.categorie,
    f.devise,
    COUNT(*) AS nombre_ventes,
    ROUND(SUM(f.montant_ligne), 2) AS montant_total
FROM fait_ventes f
JOIN dim_magasin m ON f.magasin_key = m.magasin_key
JOIN dim_produit p ON f.produit_key = p.produit_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Payée'
GROUP BY m.nom_magasin, p.categorie, f.devise
ORDER BY m.nom_magasin, p.categorie, f.devise;

-- REQUETE 2 : Classement des produits par quantite vendue
SELECT
    p.code_produit,
    p.nom_produit,
    p.categorie,
    f.devise,
    SUM(f.quantite) AS quantite_vendue
FROM fait_ventes f
JOIN dim_produit p ON f.produit_key = p.produit_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Payée'
GROUP BY p.code_produit, p.nom_produit, p.categorie, f.devise
ORDER BY quantite_vendue DESC;

-- REQUETE 3 : Evolution mensuelle des ventes payees
SELECT
    d.annee,
    d.mois,
    f.devise,
    COUNT(*) AS nombre_ventes,
    ROUND(SUM(f.montant_ligne), 2) AS montant_total
FROM fait_ventes f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Payée'
GROUP BY d.annee, d.mois, f.devise
ORDER BY d.annee, d.mois, f.devise;

-- REQUETE 4 : Performance des magasins
SELECT
    m.nom_magasin,
    f.devise,
    COUNT(*) AS nombre_ventes_payees,
    ROUND(SUM(f.montant_ligne), 2) AS montant_total
FROM fait_ventes f
JOIN dim_magasin m ON f.magasin_key = m.magasin_key
JOIN dim_statut s ON f.statut_key = s.statut_key
WHERE s.statut = 'Payée'
GROUP BY m.nom_magasin, f.devise
ORDER BY f.devise, montant_total DESC;

-- REQUETE 5 : Recherche des codes de vente repetes dans la source
SELECT
    code_vente,
    COUNT(*) AS occurrences
FROM staging_ventes
GROUP BY code_vente
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, code_vente;

