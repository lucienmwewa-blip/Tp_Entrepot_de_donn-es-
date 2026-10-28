# Données sources du projet

## Objectif

Ce dossier est destiné à accueillir les fichiers préparés pour l'alimentation de l'entrepôt de données Commerce.

## Fichiers prévus

- `ventes.csv` : données transactionnelles commerciales.
- `clients.csv` : données de référence des clients, si disponibles.
- `produits.csv` : données de référence des produits, si disponibles.
- `magasins.csv` : données de référence des magasins, si disponibles.

## Précautions

Le fichier Excel original est conservé séparément.

Les fichiers CSV doivent être contrôlés avant leur chargement : présence des en-têtes, encodage, séparateur, format des dates, types numériques et cohérence des références.

Les données contenant des informations commerciales confidentielles ou personnelles ne doivent pas être publiées dans un dépôt public.

Le chargement effectif sera réalisé dans un environnement MySQL, après validation des structures et des contrôles de qualité.
