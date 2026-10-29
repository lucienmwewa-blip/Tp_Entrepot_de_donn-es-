
cat > docs/kpi_tableau_de_bord.md <<'EOF'
# KPI et maquette du tableau de bord commercial

## 1. Objectif

Ce document présente les indicateurs clés de performance (KPI)
retenus pour analyser les ventes commerciales dans l'entrepôt de
données `dw_commerce`.

Le tableau de bord doit faciliter le suivi des ventes, le classement
des produits et la comparaison des performances des magasins.

## 2. Périmètre des analyses

Les analyses financières portent prioritairement sur les ventes
dont le statut est `Payée`.

Les ventes `En attente` et `Annulée` restent disponibles dans
l'entrepôt pour des analyses complémentaires, mais ne sont pas
incluses dans les montants des ventes payées.

Les montants en USD et en CDF doivent toujours être présentés
séparément, car aucun taux de change documenté n'est disponible.

## 3. Indicateurs clés de performance

### KPI 1 — Nombre de ventes payées

**Définition :** nombre de transactions dont le statut est `Payée`.

**Formule :**

Nombre de ventes payées = nombre de lignes de ventes au statut `Payée`.

**Utilité :** mesurer le volume des transactions effectivement payées.

**Dimensions d'analyse :**
- Période (année, trimestre, mois).
- Magasin.
- Catégorie de produit.
- Devise.

**Visualisation recommandée :** carte KPI et graphique d'évolution mensuelle.

### KPI 2 — Montant total des ventes payées

**Définition :** somme des montants des ventes dont le statut est `Payée`.

**Formule :**

Montant total = somme de `montant_ligne` pour les ventes payées.

**Utilité :** suivre le montant des ventes réalisées.

**Dimensions d'analyse :**
- Période.
- Magasin.
- Catégorie de produit.
- Devise.

**Visualisation recommandée :** cartes KPI distinctes pour USD et CDF,
complétées par un graphique en barres par magasin.

**Précaution :** ne pas additionner les montants USD et CDF.

### KPI 3 — Quantité totale vendue

**Définition :** somme des quantités associées aux ventes payées.

**Formule :**

Quantité vendue = somme de `quantite` pour les ventes payées.

**Utilité :** mesurer le volume de produits commercialisés.

**Dimensions d'analyse :**
- Produit.
- Catégorie.
- Magasin.
- Période.

**Visualisation recommandée :** classement des produits en barres
horizontales.

### KPI 4 — Montant moyen par vente payée

**Définition :** montant moyen d'une transaction payée, calculé
séparément pour chaque devise.

**Formule :**

Montant moyen = montant total des ventes payées / nombre de ventes payées.

**Utilité :** comparer la valeur moyenne des transactions.

**Dimensions d'analyse :**
- Magasin.
- Période.
- Catégorie de produit.
- Devise.

**Visualisation recommandée :** carte KPI par devise et comparaison
des magasins.

### KPI 5 — Part des ventes payées

**Définition :** proportion des transactions payées parmi toutes
les transactions enregistrées dans l'entrepôt.

**Formule :**

Part des ventes payées (%) =
(nombre de ventes payées / nombre total de ventes) × 100.

**Utilité :** suivre la répartition des statuts commerciaux.

**Dimensions d'analyse :**
- Période.
- Magasin.
- Devise.

**Visualisation recommandée :** diagramme en anneau ou barres empilées
par statut.

**Précaution :** cet indicateur décrit les transactions présentes
dans le jeu de données. Il ne représente pas nécessairement un taux
de conversion des prospects.

### KPI 6 — Nombre de lignes rejetées lors du contrôle qualité

**Définition :** nombre de lignes identifiées comme non conformes
pendant le traitement ETL.

**Formule :**

Nombre de rejets = nombre de lignes enregistrées dans le journal
des rejets pour l'exécution considérée.

**Utilité :** suivre les problèmes de qualité des données.

**Dimensions d'analyse :**
- Type d'anomalie.
- Exécution du traitement, si cette information est enregistrée.

**Visualisation recommandée :** histogramme par type d'anomalie.

**Précaution :** le journal actuel doit être associé à une exécution
précise pour éviter de compter plusieurs fois les mêmes rejets lors
des relances de l'ETL.

## 4. Dimensions d'analyse

| Dimension | Attributs utiles |
|---|---|
| Date | Jour, mois, trimestre, année |
| Client | Code client, segment, ville |
| Produit | Code produit, nom, catégorie |
| Magasin | Code magasin, nom, ville |
| Statut | Payée, En attente, Annulée |
| Devise | USD, CDF |

## 5. Maquette fonctionnelle du tableau de bord

### Zone A — Indicateurs de synthèse

- Nombre de ventes payées.
- Montant total en USD.
- Montant total en CDF.
- Quantité totale vendue.
- Montant moyen par vente, par devise.
- Nombre de lignes rejetées pour l'exécution ETL considérée.

### Zone B — Évolution temporelle

Graphique en courbes ou en colonnes montrant l'évolution mensuelle
des montants des ventes payées, avec une série distincte pour chaque
devise.

### Zone C — Performance des magasins

Graphique en barres comparant les montants des ventes payées par
magasin. Les devises doivent être affichées dans des graphiques
distincts ou dans des vues séparées.

### Zone D — Analyse des produits

Classement des produits par quantité vendue et tableau détaillé
par catégorie.

### Zone E — Qualité des données

Graphique présentant le nombre de rejets par type d'anomalie,
accompagné du volume total traité lors de l'exécution ETL.

### Filtres proposés

- Année.
- Mois.
- Magasin.
- Catégorie de produit.
- Statut.
- Devise.

## 6. Règles de calcul et d'interprétation

1. Les KPI financiers portent sur les ventes payées, sauf indication
   contraire.
2. Les montants USD et CDF ne sont jamais additionnés ensemble.
3. Les ventes annulées et en attente ne sont pas assimilées à des
   ventes payées.
4. Les résultats dépendent de la qualité et de la couverture des
   données sources.
5. Les indicateurs doivent être recalculés après toute modification
   ou actualisation des données.
6. Les résultats présentés dans le rapport doivent provenir de
   requêtes effectivement exécutées.

## 7. Limites

- Aucun taux de change n'est fourni pour convertir USD et CDF.
- Les données ne permettent pas, à elles seules, de mesurer la marge
  bénéficiaire, faute de coûts documentés.
- Le nombre de ventes payées ne constitue pas un taux de conversion
  des prospects.
- Le suivi historique de la qualité exige un journal ETL distinguant
  les différentes exécutions.

## 8. Conclusion

Les KPI proposés fournissent une base de suivi des ventes, des
performances des magasins, des quantités commercialisées et de la
qualité des données.

La maquette peut être mise en œuvre dans un outil de visualisation
après validation des requêtes SQL et des résultats produits par
l'entrepôt `dw_commerce`.
EOF
