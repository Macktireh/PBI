let
    GetData = (NumberCsvColumns as number, optional CsvDelimiter as text) =>
        let
            // Obtient les données locales à partir d'un fichier CSV
            LocalData = GetProductsDataFromCsv(NumberCsvColumns, (CsvDelimiter ?? ",")),
            // Obtient les données de test à partir de l'API
            TestingData = GetProductsDataFromApi(),
            // Obtient les données de production à partir de PostgreSQL
            ProductionData = GetDataFromPostgreSQL(SQLQuery),
            // Sélectionne les données en fonction de l'environnement (production, test ou local)
            Data = if IsProduction then ProductionData else if IsTesting then TestingData else LocalData
        in
            Data
in
    GetData
