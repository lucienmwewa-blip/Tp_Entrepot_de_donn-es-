
# Architecture de l'entrepôt de données Commerce

## 1. Introduction

Le présent document décrit l'architecture proposée pour la conception d'un entrepôt de données consacré à l'analyse des ventes commerciales. Le projet s'inscrit dans le cadre du cours d'Entrepôts de données du Master complémentaire à l'Institut Supérieur de Commerce (ISC) de Lubumbashi.

L'objectif est de structurer les données commerciales afin d'améliorer leur qualité, de faciliter leur exploitation et de soutenir la prise de décision.

## 2. Objectifs de l'architecture

L'architecture proposée vise à :

- Centraliser les données relatives aux ventes.
- Contrôler et améliorer la qualité des données sources.
- Séparer les données opérationnelles des données analytiques.
- Faciliter les analyses multidimensionnelles.
- Produire des indicateurs de performance commerciale.
- Préparer les données pour la réalisation d'un tableau de bord décisionnel.

## 3. Sources de données

Les données sources proviennent du classeur Excel fourni pour le TP.

Selon la structure réelle du classeur, les données peuvent comprendre :

- Les transactions commerciales.
- Les informations relatives aux clients.
- Les informations relatives aux produits et aux catégories.
- Les informations relatives aux magasins.
- Les statuts des transactions.

Les données sources sont conservées sans modification afin de garantir leur traçabilité. Des copies de travail peuvent être exportées au format CSV pour préparer leur importation dans MySQL.

## 4. Composantes de l'architecture

### 4.1. Couche des sources

Cette couche contient le fichier Excel original et les éventuels fichiers CSV dérivés. Elle constitue le point de départ du processus d'alimentation.

### 4.2. Zone de préparation (Staging)

La zone de préparation reçoit les données extraites avant leur intégration dans l'entrepôt.

La table `staging_ventes` est prévue pour accueillir les transactions commerciales brutes.

Cette zone facilite :

- La détection des doublons.
- L'identification des valeurs manquantes.
- La vérification des dates.
- Le contrôle des quantités et des prix.
- La détection des références inconnues.
- La vérification des devises et des statuts.

### 4.3. Processus ETL

Le processus ETL comprend trois phases :

**Extraction (Extract)**

Lecture des données provenant des fichiers sources et transfert vers la zone de préparation.

**Transformation (Transform)**

Contrôle des données, détection des anomalies, validation des références, harmonisation des formats et isolation des lignes rejetées.

**Chargement (Load)**

Insertion des données validées dans les dimensions et dans la table de faits de l'entrepôt.

### 4.4. Couche de stockage analytique

La base de données `dw_commerce` constitue l'entrepôt de données.

Le modèle dimensionnel proposé comprend une table de faits et cinq dimensions :

- `fait_ventes` : mesures et références des transactions.
- `dim_date` : informations calendaires.
- `dim_client` : caractéristiques des clients.
- `dim_produit` : produits et catégories.
- `dim_magasin` : magasins et villes.
- `dim_statut` : état des transactions.

### 4.5. Couche analytique et décisionnelle

Cette couche exploite les données validées au moyen de requêtes SQL.

Les analyses prévues portent notamment sur :

- Le chiffre d'affaires par magasin et par devise.
- Le chiffre d'affaires par catégorie de produit.
- Le classement des produits selon les quantités vendues.
- L'évolution mensuelle des ventes.
- La répartition des ventes par statut.
- Le classement des clients selon les montants d'achat.

Les résultats pourront ensuite alimenter un tableau de bord décisionnel.

## 5. Schéma général de l'architecture

Le flux logique proposé est le suivant :

```text
Fichier Excel source
        |
        v
Exportation éventuelle en CSV
        |
        v
Zone de préparation : staging_ventes
        |
        v
Processus ETL
Extraction - Transformation - Chargement
        |
        +--------------------------+
        |                          |
        v                          v
Contrôles qualité             Gestion des rejets
        |
        v
Dimensions de l'entrepôt
        |
        v
Table de faits : fait_ventes
        |
        v
Requêtes SQL analytiques
        |
        v
Indicateurs de performance (KPI)
        |
        v
Tableau de bord décisionnel
```

Ce schéma représente le fonctionnement cible. Il ne signifie pas que toutes les étapes ont déjà été exécutées.

## 6. Règles de qualité et de gestion des données

Les règles suivantes sont prévues :

- Détecter les codes de vente dupliqués.
- Identifier les champs obligatoires manquants.
- Vérifier la validité des dates.
- Écarter des analyses les quantités et les prix non valides.
- Contrôler l'existence des références clients, produits et magasins.
- Accepter uniquement les devises prévues dans le modèle.
- Documenter les rejets et les motifs d'exclusion.
- Conserver une trace des volumes extraits, validés et rejetés.

Les données présentant des anomalies bloquantes ne doivent pas être intégrées aux analyses avant leur résolution ou leur qualification.

## 7. Précautions relatives aux analyses financières

Les ventes payées sont utilisées pour les analyses du chiffre d'affaires. Les ventes annulées et en attente sont analysées séparément.

Les montants en USD et en CDF doivent être agrégés séparément en l'absence d'un taux de change documenté.

Le calcul du montant d'une ligne doit également être vérifié par rapport aux règles et aux valeurs du fichier source.

## 8. Technologies prévues

- **Excel** : consultation initiale des données sources.
- **CSV** : format intermédiaire pour l'importation.
- **GitHub** : gestion du code SQL et documentation du projet.
- **MySQL** : stockage et exploitation des données.
- **SQL** : contrôles qualité, transformations et analyses.

## 9. État d'avancement

L'architecture et les scripts SQL ont été préparés dans le dépôt GitHub.

L'installation ou la disponibilité de MySQL, l'importation des données sources, l'exécution des scripts et la validation des résultats restent à confirmer.

Les indicateurs et les résultats définitifs seront renseignés après exécution effective des traitements.

## 10. Conclusion

L'architecture proposée organise le passage des données commerciales brutes vers un entrepôt structuré en étoile. Elle vise à garantir la qualité des données et à faciliter les analyses multidimensionnelles nécessaires au pilotage de l'activité commerciale.

Sa validation finale dépendra de l'exécution du processus ETL et de la vérification des résultats dans MySQL.
