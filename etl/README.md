# Processus ETL — Entrepôt de données Commerce

## 1. Objectif

Le processus ETL (Extract, Transform, Load) permet d'extraire les données commerciales, de contrôler leur qualité, de corriger ou d'isoler les anomalies, puis de charger les données validées dans l'entrepôt de données `dw_commerce`.

## 2. Étape d'extraction (Extract)

Les données proviennent du fichier source des ventes et des fichiers de référence associés aux clients, aux produits et aux magasins.

Les données extraites sont conservées dans une zone de préparation appelée `staging_ventes`, avant leur intégration dans les tables dimensionnelles et la table de faits.

## 3. Étape de transformation (Transform)

Les opérations de transformation prévues sont les suivantes :

- Détection des doublons à partir du code de vente.
- Identification des champs obligatoires manquants.
- Vérification de la validité des dates.
- Contrôle des quantités et des prix unitaires.
- Vérification des codes clients, produits et magasins.
- Contrôle des devises autorisées : USD et CDF.
- Vérification de la cohérence entre le statut de la vente et son traitement analytique.
- Calcul du montant de ligne à partir de la quantité et du prix unitaire, après vérification de la règle de calcul applicable aux données sources.

Les lignes présentant des anomalies bloquantes sont isolées dans une table de rejets, avec le code de vente, le type d'anomalie et sa description. Elles ne sont pas intégrées aux analyses tant que leur validité n'est pas établie.

## 4. Étape de chargement (Load)

Après validation, les données sont chargées dans les dimensions suivantes :

- `dim_date` : informations calendaires ;
- `dim_client` : informations sur les clients ;
- `dim_produit` : informations sur les produits et leurs catégories ;
- `dim_magasin` : informations sur les magasins ;
- `dim_statut` : statuts des ventes.

Les ventes validées sont ensuite chargées dans `fait_ventes`, avec les clés étrangères vers les dimensions et les mesures nécessaires aux analyses.

## 5. Contrôles de qualité

Les contrôles portent notamment sur :

- l'unicité du code de vente ;
- la présence des champs obligatoires ;
- la validité des dates ;
- la positivité des quantités et des prix ;
- l'existence des références dans les dimensions ;
- la conformité des devises ;
- la cohérence des montants calculés.

Les anomalies détectées sont documentées et les lignes rejetées sont conservées pour faciliter leur correction et leur traçabilité.

## 6. Traçabilité et journalisation

Pour chaque exécution du processus ETL, il est recommandé d'enregistrer :

- la date et l'heure du traitement ;
- le nombre de lignes extraites ;
- le nombre de lignes validées ;
- le nombre de lignes rejetées ;
- le détail des principales anomalies ;
- le résultat du chargement.

## 7. Précautions analytiques

Les ventes payées sont utilisées pour les analyses du chiffre d'affaires. Les ventes annulées et en attente sont analysées séparément.

Les montants en USD et en CDF restent séparés en l'absence d'un taux de change documenté.

## 8. État de réalisation

La démarche ETL est documentée. L'exécution effective du processus, le chargement des tables et la validation des résultats restent à confirmer dans un environnement MySQL.

Les résultats définitifs seront établis après exécution des scripts et vérification des données chargées.
