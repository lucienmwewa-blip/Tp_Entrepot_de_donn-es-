USE dw_commerce;

-- KPI 1 : nombre de ventes payees par devise
SELECT f.devise, COUNT(*) AS nombre_ventes_payees
FROM fait_ventes f
JOIN dim_statut s ON s.statut_key = f.statut_key
WHERE s.statut = 'Payée'
GROUP BY f.devise
ORDER BY f.devise;

-- KPI 2 : montant total des ventes payees par devise
SELECT f.devise, ROUND(SUM(f.montant_ligne), 2) AS montant_total
FROM fait_ventes f
JOIN dim_statut s ON s.statut_key = f.statut_key
WHERE s.statut = 'Payée'
GROUP BY f.devise
ORDER BY f.devise;

-- KPI 3 : dix produits les plus vendus en quantite
SELECT p.code_produit, p.nom_produit,
       SUM(f.quantite) AS quantite_totale
FROM fait_ventes f
JOIN dim_produit p ON p.produit_key = f.produit_key
JOIN dim_statut s ON s.statut_key = f.statut_key
WHERE s.statut = 'Payée'
GROUP BY p.code_produit, p.nom_produit
ORDER BY quantite_totale DESC
LIMIT 10;

-- KPI 4 : montant moyen par vente payee et par devise
SELECT f.devise, ROUND(AVG(f.montant_ligne), 2) AS montant_moyen
FROM fait_ventes f
JOIN dim_statut s ON s.statut_key = f.statut_key
WHERE s.statut = 'Payée'
GROUP BY f.devise
ORDER BY f.devise;

-- KPI 5 : repartition des ventes par statut
SELECT s.statut, COUNT(*) AS nombre_ventes,
       ROUND(100.0 * COUNT(*) /
             (SELECT COUNT(*) FROM fait_ventes), 2) AS pourcentage
FROM fait_ventes f
JOIN dim_statut s ON s.statut_key = f.statut_key
GROUP BY s.statut
ORDER BY nombre_ventes DESC;

-- KPI 6 : montants des ventes payees par magasin et devise
SELECT m.nom_magasin, f.devise,
       COUNT(*) AS nombre_ventes,
       ROUND(SUM(f.montant_ligne), 2) AS montant_total
FROM fait_ventes f
JOIN dim_magasin m ON m.magasin_key = f.magasin_key
JOIN dim_statut s ON s.statut_key = f.statut_key
WHERE s.statut = 'Payée'
GROUP BY m.nom_magasin, f.devise
ORDER BY f.devise, montant_total DESC;
