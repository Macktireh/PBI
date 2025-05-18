let
    // Fonction pour obtenir des données à partir de PostgreSQL en utilisant une requête SQL
    GetDataFromPostgreSQL = (Query as text) =>
        let
            // Exécute la requête SQL sur la base de données PostgreSQL spécifiée
            Source = Value.NativeQuery(
                PostgreSQL.Database(POSTGRES_HOST, POSTGRES_DB), Query, null, [
                    EnableFolding = true
                ]
            )
        in
            Source
in
    GetDataFromPostgreSQL
