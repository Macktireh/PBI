let
    // Fonction pour obtenir les données des produits à partir d'un fichier CSV
    GetProductsDataFromCsv = (NumberCsvColumns as number, optional Delimiter as text) =>
        let
            // Lit le contenu du fichier CSV à partir de l'URL spécifiée
            Source = Csv.Document(
                Web.Contents(CSV_FILE_URL),
                [
                    // Utilise le délimiteur spécifié ou une virgule par défaut
                    Delimiter = (Delimiter ?? ","),
                    // Nombre de colonnes dans le fichier CSV
                    Columns = NumberCsvColumns,
                    // Encodage du fichier CSV
                    Encoding = 1252,
                    // Style de guillemets
                    QuoteStyle = QuoteStyle.None
                ]
            ),
            // Promeut la première ligne en tant qu'en-têtes de colonne
            PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
            // Applique la transformation de la table de produits
            TransformedProductTable = TransformProductTable(PromotedHeaders)
        in
            TransformedProductTable,
    // Fonction pour transformer la table de produits
    TransformProductTable = (ProductTable as table) as table =>
        let
            // Remplace les points par des virgules dans les colonnes spécifiées
            ReplacedValue = Table.ReplaceValue(
                ProductTable,
                ".",
                ",",
                Replacer.ReplaceText,
                {"price", "discount_percentage", "rating", "weight", "width", "height", "depth"}
            ),
            // Change le type des colonnes pour correspondre aux types de données appropriés
            ChangedType = Table.TransformColumnTypes(
                ReplacedValue,
                {
                    {"id", Int64.Type},
                    {"title", type text},
                    {"description", type text},
                    {"price", type number},
                    {"category", type text},
                    {"discount_percentage", type number},
                    {"rating", type number},
                    {"stock", Int64.Type},
                    {"brand", type text},
                    {"sku", type text},
                    {"weight", Int64.Type},
                    {"width", type number},
                    {"height", type number},
                    {"depth", type number},
                    {"warranty_information", type text},
                    {"shipping_information", type text},
                    {"availability_status", type text},
                    {"return_policy", type text},
                    {"minimum_order_quantity", Int64.Type},
                    {"thumbnail", type text},
                    {"barcode", Int64.Type},
                    {"qr_code", type text},
                    {"created_at", type datetime},
                    {"updated_at", type datetime},
                    {"tags", type text}
                }
            )
        in
            ChangedType
in
    GetProductsDataFromCsv
