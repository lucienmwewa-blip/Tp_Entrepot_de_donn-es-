# Indicateurs de performance (KPI) — Data Warehouse Commerce

## 1. Objectif

Les indicateurs clés de performance (KPI) permettent de suivre l'activité commerciale à partir des données intégrées dans l'entrepôt de données. Ils facilitent l'analyse des ventes, des produits, des magasins, des clients et des statuts de transaction.

## 2. Tableau des indicateurs

| N° | Indicateur | Formule de calcul | Dimensions d'analyse | Visualisation proposée |
|---|---|---|---|---|
| 1 | Chiffre d'affaires des ventes payées | Somme des montants des ventes payées | Date, magasin, devise | Cartes KPI et histogramme |
| 2 | Chiffre d'affaires par catégorie | Somme des montants payés par catégorie de produit | Catégorie, date, devise | Histogramme comparatif |
| 3 | Quantité vendue | Somme des quantités des ventes payées | Produit, catégorie, date | Tableau de classement |
| 4 | Évolution mensuelle du chiffre d'affaires | Somme des montants payés pour chaque mois | Année, mois, devise | Courbe chronologique |
| 5 | Nombre de ventes par statut | Nombre de lignes de vente pour chaque statut | Statut, date, magasin | Diagramme en barres |
| 6 | Top 10 des clients | Classement décroissant des clients selon le montant payé | Client, segment, ville, devise | Tableau de classement |

## 3. Règles de calcul et d'interprétation

### 3.1 Chiffre d'affaires

Le chiffre d'affaires analytique est calculé en additionnant les montants des ventes dont le statut est « Paid ». Les ventes annulées et en attente sont exclues de cet indicateur.

### 3.2 Comparaison des devises

Les montants libellés en USD et en CDF sont analysés séparément. Aucune addition entre ces devises n'est effectuée en l'absence d'un taux de conversion documenté.

### 3.3 Quantités vendues

Le classement des produits repose sur la somme des quantités associées aux ventes payées et validées.

### 3.4 Nombre de ventes

Le nombre de lignes de vente ne correspond pas nécessairement au nombre de commandes distinctes. Cette distinction doit être prise en compte si une commande peut comporter plusieurs lignes.

## 4. Maquette fonctionnelle du tableau de bord

Le tableau de bord proposé comportera les zones suivantes :

1. **Filtres** : période, magasin, catégorie de produit, statut et devise.
2. **Indicateurs synthétiques** : chiffre d'affaires payé par devise, quantité vendue et nombre de lignes de vente.
3. **Analyse temporelle** : évolution mensuelle du chiffre d'affaires par devise.
4. **Analyse des magasins** : classement des magasins par chiffre d'affaires.
5. **Analyse des produits** : catégories les plus performantes et top 10 des produits par quantité vendue.
6. **Analyse des clients** : principaux clients selon le montant payé.
7. **Qualité des données** : nombre de lignes rejetées et répartition des anomalies détectées.

## 5. Bénéfices décisionnels

Cette solution doit permettre aux responsables commerciaux de repérer les magasins les plus performants, de suivre l'évolution des ventes, d'identifier les produits les plus demandés et de mieux comprendre la répartition des achats entre les clients.

## 6. Limites

Les KPI constituent une proposition de conception. Leurs valeurs numériques ne seront renseignées qu'après le chargement des données et l'exécution des requêtes SQL dans MySQL.
