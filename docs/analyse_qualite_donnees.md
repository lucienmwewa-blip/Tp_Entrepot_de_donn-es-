
# Analyse de la qualité des données

## Objectif

Évaluer la fiabilité des données commerciales avant leur intégration dans l'entrepôt de données.

## Contrôles à réaliser

- Détection des doublons de ventes.
- Recherche des valeurs manquantes.
- Vérification de la validité des dates.
- Identification des références clients inconnues.
- Contrôle des quantités et des prix.
- Vérification des devises.
- Identification des incohérences métier.

## Résultats

Les résultats seront documentés après l'analyse du fichier source et la validation des règles de qualité.

## Traitement des anomalies

Chaque anomalie devra être identifiée, documentée et corrigée ou placée en rejet selon une règle explicite. Les données sources seront conservées pour assurer la traçabilité.
  

## Résultats du chargement ETL

Le chargement initial a traité 1 000 lignes de la table de staging.
Selon le journal du script, 968 ventes ont été chargées et 32 lignes
ont été écartées.

### Contrôles exécutés sur la table de faits

| Contrôle | Résultat |
|---|---:|
| Ventes chargées | 968 |
| Quantités inférieures ou égales à zéro | 0 |
| Prix unitaires inférieurs ou égaux à zéro | 0 |
| Taux de chargement | 96,8 % |

### Répartition des ventes chargées par devise

| Devise | Nombre de ventes | Montant total |
|---|---:|---:|
| CDF | 193 | 1 054 562,88 CDF |
| USD | 775 | 4 237 458,36 USD |

Les montants en CDF et en USD sont présentés séparément, aucun taux
de change documenté n'étant disponible.

### Anomalies enregistrées

| Type d'anomalie | Nombre |
|---|---:|
| CLIENT_INCONNU | 10 |
| DATE_INVALIDE | 5 |
| DEVISE_INVALIDE | 1 |
| PRIX_INVALIDE | 1 |
| QUANTITE_INVALIDE | 15 |
| Total des anomalies enregistrées | 32 |

Ces résultats décrivent la première exécution du traitement ETL.
Le contrôle des quantités et des prix ne suffit pas à démontrer
l'absence de toutes les autres incohérences possibles.
