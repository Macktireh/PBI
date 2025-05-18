let
    GetURLSearchParams = (optional Offset as number) =>
        let
            _offset = Text.From(if Offset = null then 0 else Offset),
            Query = [
                limit = API_QUERY_PARAM_LIMIT_ITEMS,
                order_by = "year DESC,code",
                refine = API_QUERY_PARAM_REFINE,
                apikey = API_KEY,
                offset = _offset
            ]
        in
            Query
in
    GetURLSearchParams
