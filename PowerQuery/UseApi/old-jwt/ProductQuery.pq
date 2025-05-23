let
    Source = GetProductData(25),
    AddedStarColumn = Table.AddColumn(
        Source,
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
