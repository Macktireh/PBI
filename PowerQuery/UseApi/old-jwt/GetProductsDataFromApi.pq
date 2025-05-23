let
    // Fonction pour obtenir une page de produits en fonction de l'index
    GetPage = (Index as number) =>
        let
            // Calcule le nombre d'éléments à ignorer en fonction de l'index
            skip = Index * API_LIMIT,
            // Obtient les paramètres de requête avec le nombre d'éléments à ignorer
            QueryParameters = GetQueryParameters(skip),
            // Obtient les en-têtes d'authentification avec le jeton d'accès
            AuthHeaders = GetHeadersParametersWithAccessToken(),
            // Envoie une requête HTTP pour obtenir les produits
            Response = HttpClient("auth/products", QueryParameters, AuthHeaders),
            // Extrait les résultats des produits de la réponse
            ProductResults = Response[#"products"]
        in
            ProductResults,
    // Fonction principale pour obtenir tous les produits
    GetProducts = () =>
        let
            // Nombre total de produits à récupérer
            total = 80,
            // Calcule le nombre maximum d'ID de produits à récupérer
            MaxIDCount = List.Max({API_LIMIT, total}),
            // Calcule le nombre de pages nécessaires
            PageCount = Number.RoundUp(MaxIDCount / API_LIMIT),
            // Crée une liste d'indices de pages
            PageIndices = {0..PageCount - 1},
            // Récupère les produits pour chaque page
            Pages = List.Transform(PageIndices, each GetPage(_)),
            // Combine les ID de produits de toutes les pages
            AllProductIDs = List.Union(Pages),
            // Crée une table à partir de la liste d'ID de produits
            ProductTable = Table.FromList(AllProductIDs, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
            // Obtient les indices des noms de colonnes de la table
            ColumnNamesIndex = List.Positions(Table.ColumnNames(ProductTable)),
            // Trouve l'index de la colonne contenant des enregistrements
            RecordColumnIndex = List.First(
                List.Select(
                    ColumnNamesIndex, each Type.Is(Value.Type(Record.FieldValues(ProductTable{0}){_}), type record)
                )
            ),
            // Obtient le nom de la colonne contenant des enregistrements
            RecordColumnName = Table.ColumnNames(ProductTable){RecordColumnIndex},
            // Obtient les noms des champs de l'enregistrement
            RecordFieldNames = Record.FieldNames(Record.FieldValues(ProductTable{0}){RecordColumnIndex}),
            // Développe la colonne d'enregistrements pour inclure les champs de l'enregistrement
            ExpandedProductTable = Table.ExpandRecordColumn(
                ProductTable, RecordColumnName, RecordFieldNames, RecordFieldNames
            ),
            // Applique la transformation de la table de produits
            TransformedProductTable = TransformProductTable(ExpandedProductTable)
        in
            TransformedProductTable,
    // Fonction pour transformer la table de produits
    TransformProductTable = (ProductTable as table) as table =>
        let
            // Supprime les colonnes inutiles
            RemovedColumns = Table.RemoveColumns(ProductTable, {"reviews", "images"}),
            // Développe la colonne 'meta' pour inclure des informations supplémentaires
            ExpandedMeta = Table.ExpandRecordColumn(
                RemovedColumns,
                "meta",
                {"createdAt", "updatedAt", "barcode", "qrCode"},
                {"createdAt", "updatedAt", "barcode", "qrCode"}
            ),
            // Développe la colonne 'dimensions' pour inclure les dimensions du produit
            ExpandedDimensions = Table.ExpandRecordColumn(
                ExpandedMeta, "dimensions", {"width", "height", "depth"}, {"width", "height", "depth"}
            ),
            // Renomme les colonnes pour une meilleure lisibilité
            RenamedColumns = Table.RenameColumns(
                ExpandedDimensions,
                {
                    {"discountPercentage", "discount_percentage"},
                    {"warrantyInformation", "warranty_information"},
                    {"shippingInformation", "shipping_information"},
                    {"availabilityStatus", "availability_status"},
                    {"returnPolicy", "return_policy"},
                    {"minimumOrderQuantity", "minimum_order_quantity"},
                    {"createdAt", "created_at"},
                    {"updatedAt", "updated_at"},
                    {"qrCode", "qr_code"}
                }
            ),
            // Réorganise les colonnes pour une meilleure structure
            ReorderedColumns = Table.ReorderColumns(
                RenamedColumns,
                {
                    "id",
                    "title",
                    "description",
                    "price",
                    "category",
                    "discount_percentage",
                    "rating",
                    "stock",
                    "brand",
                    "sku",
                    "weight",
                    "width",
                    "height",
                    "depth",
                    "warranty_information",
                    "shipping_information",
                    "availability_status",
                    "return_policy",
                    "minimum_order_quantity",
                    "created_at",
                    "updated_at",
                    "barcode",
                    "qr_code",
                    "thumbnail",
                    "tags"
                }
            ),
            // Remplace les valeurs dans la colonne 'tags' par une chaîne de texte
            ReplacedValue = Table.ReplaceValue(
                ReorderedColumns, each [tags], each Text.Combine([tags], ";"), Replacer.ReplaceValue, {"tags"}
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
    GetProducts
