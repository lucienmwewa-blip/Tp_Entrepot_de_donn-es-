# Résultats d'exécution des KPI

## 1. Environnement
- SGBD : MySQL 8.0.
- Base : dw_commerce.
- Table de faits : fait_ventes.
- Nombre de ventes chargées : 968.
- Nombre de statuts : 3.

## 2. Exécution
Le script sql/05_indicateurs_performance.sql a été exécuté avec succès.

Commande :
sudo mysql < sql/05_indicateurs_performance.sql

## 3. Résultats observés par magasin

| Magasin | Devise | Nombre de ventes | Montant total |
|---|---|---:|---:|
| Magasin_15 | CDF | 8 | 54525.23 |
| Magasin_11 | CDF | 10 | 54510.39 |
| Magasin_09 | CDF | 10 | 48357.50 |
| Magasin_12 | USD | 58 | 378286.83 |
| Magasin_03 | USD | 53 | 274824.16 |
| Magasin_11 | USD | 44 | 263112.21 |

Cet extrait correspond aux résultats visibles dans le terminal.

## 4. Précautions
Les montants USD et CDF sont analysés séparément, faute de taux de change documenté. Les conclusions globales devront reposer sur l'ensemble des résultats SQL, et non sur ce seul extrait.
