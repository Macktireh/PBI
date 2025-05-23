let
    Source = FetchDataFromApi("auth/products", "products", "total"),
    RemovedColumns = Table.RemoveColumns(Source, {"reviews", "images"}),
    ExpandedMeta = Table.ExpandRecordColumn(
        RemovedColumns,
        "meta",
        {"createdAt", "updatedAt", "barcode", "qrCode"},
        {"createdAt", "updatedAt", "barcode", "qrCode"}
    ),
    ExpandedDimensions = Table.ExpandRecordColumn(
        ExpandedMeta, "dimensions", {"width", "height", "depth"}, {"width", "height", "depth"}
    ),
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
    ReplacedValue = Table.ReplaceValue(
        ReorderedColumns, each [tags], each Text.Combine([tags], ";"), Replacer.ReplaceValue, {"tags"}
    ),
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
    ),
    AddedStarColumn = Table.AddColumn(
        ChangedType,
        "rating_star",
        each
            if [rating] > 4 then
                "⭐⭐⭐⭐⭐"
            else if [rating] > 3 then
                "⭐⭐⭐⭐"
            else if [rating] > 2 then
                "⭐⭐⭐"
            else if [rating] > 1 then
                "⭐⭐"
            else
                "⭐",
        type text
    ),
    AddedStarIdColumn = Table.AddColumn(AddedStarColumn, "rating_star_id", each Number.RoundUp([rating]), Int32.Type)
in
    AddedStarIdColumn