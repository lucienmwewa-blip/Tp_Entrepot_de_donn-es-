
# Journal des traitements ETL — Data Warehouse Commerce

## 1. Objectif

Ce journal assure la traçabilité des opérations d'extraction, de transformation et de chargement (ETL) des données commerciales. Il permet de suivre les volumes traités, de documenter les anomalies et de vérifier les résultats de chaque étape.

## 2. Informations à enregistrer

Pour chaque exécution, les informations suivantes doivent être consignées :

- Identifiant du traitement.
- Date et heure de début et de fin.
- Étape du processus ETL.
- Nombre de lignes extraites.
- Nombre de lignes contrôlées.
- Nombre de lignes validées.
- Nombre de lignes rejetées.
- Nombre de lignes chargées.
- Anomalies détectées.
- Statut du traitement.
- Commentaires éventuels.

## 3. Tableau de suivi des traitements

| ID | Date d'exécution | Étape ETL | Lignes extraites | Lignes validées | Lignes rejetées | Lignes chargées | Statut | Observations |
|---|---|---|---:|---:|---:|---:|---|---|
| ETL-001 | À renseigner | Extraction | À mesurer | N/A | N/A | N/A | À exécuter | Importation des données sources |
| ETL-002 | À renseigner | Transformation | À mesurer | À mesurer | À mesurer | N/A | À exécuter | Contrôles qualité et traitement des anomalies |
| ETL-003 | À renseigner | Chargement | N/A | À mesurer | À mesurer | À mesurer | À exécuter | Chargement des dimensions et de la table de faits |

Les valeurs indiquées comme « À mesurer » ou « À exécuter » sont des éléments à compléter après l'exécution réelle des scripts SQL. Elles ne constituent pas des résultats expérimentaux.

## 4. Suivi de l'extraction

L'extraction consiste à récupérer les données du fichier Excel source ou des fichiers CSV préparés pour leur importation dans MySQL.

Les contrôles portent sur :

- Le nombre de lignes extraites.
- La présence des en-têtes attendus.
- La cohérence des formats de colonnes.
- La disponibilité des fichiers sources.

## 5. Suivi de la transformation

La transformation permet de contrôler et de préparer les données avant leur chargement.

Les anomalies recherchées comprennent :

- Les doublons de codes de vente.
- Les champs obligatoires manquants.
- Les dates invalides.
- Les quantités nulles ou négatives.
- Les prix unitaires manquants ou non positifs.
- Les références clients, produits ou magasins inconnues.
- Les devises non autorisées.
- Les incohérences dans les statuts ou les montants.

Chaque anomalie doit être documentée avec le code de vente concerné, son type et sa description.

Une même ligne peut présenter plusieurs anomalies. Le nombre total d'anomalies peut donc être supérieur au nombre de lignes rejetées.

## 6. Suivi du chargement

Le chargement consiste à intégrer les données validées dans les tables de l'entrepôt `dw_commerce`.

Les dimensions concernées sont :

- `dim_date`
- `dim_client`
- `dim_produit`
- `dim_magasin`
- `dim_statut`

La table de faits concernée est :

- `fait_ventes`

Après le chargement, les contrôles doivent vérifier le nombre de lignes intégrées, l'unicité des codes de vente, la validité des clés étrangères et la cohérence des montants.

## 7. Réconciliation des volumes

Le rapprochement des volumes doit permettre d'expliquer la différence entre les données sources et les données chargées.

La règle générale est :

**Nombre de lignes sources = nombre de lignes retenues + nombre de lignes exclues**, en tenant compte des doublons, des corrections, des rejets et des transformations éventuelles.

Le nombre de lignes effectivement chargées doit être comparé au nombre de lignes admissibles, après prise en compte des contraintes d'intégration.

Les résultats doivent être obtenus à partir des comptages réels dans MySQL.

## 8. Statuts des traitements

Les statuts utilisés sont :

- **À exécuter** : traitement non encore lancé.
- **En cours** : traitement en cours d'exécution.
- **Réussi** : traitement terminé et contrôles satisfaits.
- **Échec** : erreur bloquante rencontrée.
- **À vérifier** : traitement terminé, mais contrôles complémentaires nécessaires.

Un traitement ne doit être déclaré réussi qu'après vérification effective de son résultat.

## 9. Traçabilité des rejets

Chaque rejet devrait comporter les informations suivantes :

| Champ | Description |
|---|---|
| `code_vente` | Identifiant de la vente concernée |
| `type_anomalie` | Catégorie de l'anomalie |
| `description_anomalie` | Explication du problème détecté |
| `date_detection` | Date de détection |
| `decision_traitement` | Correction, exclusion ou mise en attente |

Les rejets doivent être conservés pour faciliter leur analyse et leur éventuelle correction.

## 10. État d'avancement du projet

Les scripts SQL et la documentation du processus ETL sont en préparation dans le dépôt GitHub.

Les dates d'exécution, les volumes extraits, les nombres de lignes validées et rejetées ainsi que les volumes chargés seront renseignés après l'exécution réelle et la validation des traitements dans MySQL.

À ce stade, les résultats d'exécution restent à confirmer.
