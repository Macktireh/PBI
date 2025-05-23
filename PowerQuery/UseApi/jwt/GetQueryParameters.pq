let
    // Function for obtaining query parameters, with optional parameters
    GetQueryParameters = (optional Skip as number, optional Query as record) =>
        let
            Query = Record.Combine(
                {[
                    skip = Number.ToText(Skip ?? API_PAGINATION_SKIP),
                    limit = Number.ToText(API_PAGINATION_LIMIT)
                ], (Query ?? [])}
            )
        in
            Query
in
    GetQueryParameters