# Modèle dimensionnel en étoile — Data Warehouse Commerce

## 1. Processus métier étudié

Le processus métier retenu est la vente commerciale. L'entrepôt de données doit permettre d'analyser les ventes selon plusieurs axes : le temps, les clients, les produits, les magasins et les statuts des transactions.

## 2. Grain de la table de faits

Le grain retenu est **une ligne de vente par code de vente**. Chaque enregistrement de la table de faits représente une transaction commerciale au niveau de détail défini par le fichier source.

Cette définition devra être confirmée avec la structure réelle des données. Si un même code de vente peut comporter plusieurs lignes correspondant à des produits différents, le grain devra être précisé et la clé d'unicité adaptée.

## 3. Table de faits

### `fait_ventes`

Cette table centrale contient les mesures commerciales et les clés étrangères qui relient les faits aux dimensions.

| Attribut | Rôle |
|---|---|
| `vente_key` | Clé primaire technique |
| `code_vente` | Identifiant de la vente dans la source |
| `date_key` | Référence à la dimension Date |
| `client_key` | Référence à la dimension Client |
| `produit_key` | Référence à la dimension Produit |
| `magasin_key` | Référence à la dimension Magasin |
| `statut_key` | Référence à la dimension Statut |
| `quantite` | Quantité vendue |
| `prix_unitaire` | Prix unitaire de la ligne |
| `devise` | Devise de la transaction |
| `montant_ligne` | Montant de la ligne de vente |

## 4. Dimensions

### 4.1 `dim_date`

Cette dimension permet d'analyser les ventes dans le temps.

Attributs principaux : `date_key`, `date_complete`, `jour`, `mois`, `trimestre`, `annee`.

Hiérarchie temporelle : année → trimestre → mois → jour.

### 4.2 `dim_client`

Cette dimension permet d'étudier les ventes selon les caractéristiques des clients.

Attributs principaux : `client_key`, `code_client`, `segment`, `ville`.

Axes d'analyse : client, segment et ville.

### 4.3 `dim_produit`

Cette dimension décrit les produits commercialisés.

Attributs principaux : `produit_key`, `code_produit`, `nom_produit`, `categorie`, `prix_catalogue_usd`.

Hiérarchie disponible : catégorie → produit.

Le champ `prix_catalogue_usd` devra être utilisé uniquement si la devise USD est bien celle du prix catalogue dans la source.

### 4.4 `dim_magasin`

Cette dimension permet de comparer les points de vente.

Attributs principaux : `magasin_key`, `code_magasin`, `nom_magasin`, `ville`.

Axes d'analyse : magasin et ville.

### 4.5 `dim_statut`

Cette dimension décrit l'état de la transaction.

Attributs principaux : `statut_key`, `statut`.

Elle permet notamment de distinguer les ventes payées, annulées et en attente.

## 5. Mesures et règles d'analyse

Les principales mesures sont :

- Quantité vendue : somme des quantités des ventes validées et payées.
- Chiffre d'affaires analytique : somme des montants des ventes payées.
- Nombre de lignes de vente : nombre d'enregistrements correspondant aux critères de l'analyse.

Les mesures financières doivent être agrégées séparément par devise tant qu'aucun taux de change documenté n'est disponible.

## 6. Relations du modèle

La table `fait_ventes` est reliée aux cinq dimensions par des clés étrangères. Chaque dimension fournit un axe d'analyse et la table de faits fournit les mesures.

Le modèle en étoile simplifie les requêtes analytiques et facilite la production des indicateurs de performance.

## 7. Limites et validations nécessaires

Le modèle est une proposition de conception. Avant son implémentation définitive, il faut vérifier les noms de colonnes de la source, le grain réel des transactions, les types de données, les références inconnues et les règles de calcul du montant.

Les relations et contraintes doivent ensuite être testées dans MySQL après la création et le chargement des tables.
