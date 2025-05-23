# Power Query API JWT Client

Ce projet fournit une exemple et solution complète pour récupérer des données produits à partir de différentes sources en utilisant Power Query, avec la prise en charge de l'authentification JWT. Le projet est conçu pour fonctionner dans trois environnements différents : développement, test et production.

## Fonctionnalités

- Récupération de données produits à partir d'un fichier CSV (environnement de développement)
- Récupération de données produits à partir d'une API REST avec authentification JWT (environnement de test)
- Récupération de données produits à partir d'une base de données PostgreSQL (environnement de production)
- Transformation uniformisée des données depuis toutes les sources
- Gestion des jetons JWT (obtention et utilisation pour l'authentification)
- Pagination des résultats d'API

## Structure du Projet

Le projet est composé des fonctions/requêtes suivants :

- `GetData.pq` : Point d'entrée principal qui sélectionne la source de données appropriée selon l'environnement
- `GetProductsDataFromCsv.pq` : Récupère et transforme les données depuis un fichier CSV
- `GetProductsDataFromApi.pq` : Récupère et transforme les données depuis une API REST avec pagination
- `GetDataFromPostgreSQL.pq` : Récupère les données depuis une base de données PostgreSQL
- `IsProduction` : Booléen indiquant si l'environnement est de production
- `IsTesting` : Booléen indiquant si l'environnement est de test
- `GetJwtTokens.pq` : Obtient les jetons JWT (access token et refresh token)
- `GetHeaderParameters.pq` : Configure les en-têtes HTTP de base
- `GetHeadersParametersWithAccessToken.pq` : Configure les en-têtes HTTP avec le token JWT
- `GetQueryParameters.pq` : Configure les paramètres de requête pour l'API
- `HttpClientGetRequest.pq` : Gère les requêtes HTTP GET
- `HttpClientPostRequest.pq` : Gère les requêtes HTTP POST
- `ProductQuery.pq` : Query principale pour manipuler les données produits

## Paramètres Requis

### Paramètres pour l'environnement de développement
- `CSV_FILE_URL` : URL du fichier CSV contenant les données produits

### Paramètres pour l'environnement de test (API)
- `API_BASE_URL` : URL de base de l'API (ex: "https://api.example.com/")
- `API_LOGIN_USERNAME` : Nom d'utilisateur pour l'authentification à l'API
- `API_LOGIN_PASSWORD` : Mot de passe pour l'authentification à l'API
- `API_PAGINATION_SKIP` : Paramètre de pagination pour le nombre d'éléments à ignorer (offset)
- `API_PAGINATION_LIMIT` : Paramètre de pagination pour le nombre d'éléments à récupérer par page

### Paramètres pour l'environnement de production (PostgreSQL)
- `POSTGRES_HOST` : Hôte du serveur PostgreSQL (ex: "localhost" ou adresse IP)
- `POSTGRES_DB` : Nom de la base de données PostgreSQL
- `SQLQuery` : Requête SQL à exécuter sur la base de données PostgreSQL

## Guide d'utilisation

### 1. Configuration des paramètres

Avant d'utiliser ce projet, vous devez configurer les paramètres appropriés selon votre environnement de déploiement. Ces paramètres peuvent être définis dans Power Query.

### 2. Utilisation de la fonction principale

La fonction principale `GetData` prend deux paramètres :
- `NumberCsvColumns` : Nombre de colonnes dans le fichier CSV (obligatoire)
- `CsvDelimiter` : Délimiteur utilisé dans le fichier CSV (optionnel, par défaut ",")

Exemple d'utilisation :
```powerquery
let
    Source = GetData(25, ";")
in
    Source
```

## Structure des données

Les données produits récupérées comportent les champs suivants :

- `id` : Identifiant unique du produit (Int64)
- `title` : Titre du produit (texte)
- `description` : Description du produit (texte)
- `price` : Prix du produit (nombre)
- `category` : Catégorie du produit (texte)
- `discount_percentage` : Pourcentage de remise (nombre)
- `rating` : Note du produit (nombre)
- `stock` : Stock disponible (Int64)
- `brand` : Marque du produit (texte)
- `sku` : Référence SKU du produit (texte)
- `weight` : Poids du produit (Int64)
- `width` : Largeur du produit (nombre)
- `height` : Hauteur du produit (nombre)
- `depth` : Profondeur du produit (nombre)
- `warranty_information` : Informations de garantie (texte)
- `shipping_information` : Informations d'expédition (texte)
- `availability_status` : Statut de disponibilité (texte)
- `return_policy` : Politique de retour (texte)
- `minimum_order_quantity` : Quantité minimale de commande (Int64)
- `created_at` : Date de création (datetime)
- `updated_at` : Date de mise à jour (datetime)
- `barcode` : Code-barres (Int64)
- `qr_code` : Code QR (texte)
- `thumbnail` : URL de l'image miniature (texte)
- `tags` : Tags associés au produit, séparés par des points-virgules (texte)

## Authentification JWT

Le processus d'authentification JWT fonctionne comme suit :

1. `GetJwtTokens.pq` envoie une requête à l'endpoint `/auth/login` avec les identifiants
2. Les tokens JWT (access token et refresh token) sont récupérés
3. `GetHeadersParametersWithAccessToken.pq` ajoute l'access token aux en-têtes HTTP pour les requêtes authentifiées

## Gestion de la pagination

La pagination des résultats d'API est gérée dans `GetProductsDataFromApi.pq` :

1. Calcul du nombre de pages nécessaires basé sur les limites de l'API
2. Récupération séquentielle de chaque page
3. Combinaison des résultats de toutes les pages en une seule table

## Transformation des données

Les données récupérées de diverses sources sont transformées pour assurer une structure cohérente :

- Renommage des colonnes pour une meilleure lisibilité 
- Expansion des structures imbriquées (dimensions, meta)
- Conversion des types de données appropriés
- Normalisation des formats (par exemple, combinaison des tags en une chaîne séparée par des points-virgules)
