let
    GetTotalCount = (fieldName as text) =>
        let
            RelativePath = "",
            Query = GetURLSearchParams(),
            Response = GetJson(RelativePath, Query),
            ValueTotalCount = Record.Field(Response, fieldName)
        in
            ValueTotalCount
in
    GetTotalCount
