let
    FetchDataFromApi = (RelativePath as text, ResultsFieldName as text, TotalFieldName as text) =>
        let
            // Function to get the total number from the API response
            RetrieveTotalCount = (FieldName as text) =>
            let
                ApiResponse = HttpClientGetRequest(
                    RelativePath, GetQueryParameters(), GetHeadersParametersWithAccessToken()
                ),
                TotalCount = Record.Field(ApiResponse, FieldName)
            in
                TotalCount,

            // Function to get a page based on the index
            FetchPage = (FieldName as text, PageIndex as number) =>
                let
                    Offset = (PageIndex ?? 0) * API_PAGINATION_LIMIT,
                    QueryParams = GetQueryParameters(Offset),
                    AuthHeaders = GetHeadersParametersWithAccessToken(),
                    ApiResponse = HttpClientGetRequest(RelativePath, QueryParams, AuthHeaders),
                    Results = Record.Field(ApiResponse, FieldName)
                in
                    Results,

            // Function to get all by iterating through pages
            GetAllData = () =>
                let
                    TotalProducts = RetrieveTotalCount(TotalFieldName),
                    MaxCount = List.Max({API_PAGINATION_LIMIT, TotalProducts}),
                    TotalPages = Number.RoundUp(MaxCount / API_PAGINATION_LIMIT),
                    PageIndices = {0..TotalPages - 1},
                    AllPages = List.Transform(PageIndices, each FetchPage(ResultsFieldName, _)),
                    CombinedPages = List.Union(AllPages),
                    DataTable = Table.FromList(CombinedPages, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
                    ColumnIndices = List.Positions(Table.ColumnNames(DataTable)),
                    RecordColumnIndex = List.First(
                        List.Select(
                            ColumnIndices, each Type.Is(Value.Type(Record.FieldValues(DataTable{0}){_}), type record)
                        )
                    ),
                    RecordColumnName = Table.ColumnNames(DataTable){RecordColumnIndex},
                    RecordFieldNames = Record.FieldNames(Record.FieldValues(DataTable{0}){RecordColumnIndex}),
                    ExpandedTable = Table.ExpandRecordColumn(
                        DataTable, RecordColumnName, RecordFieldNames, RecordFieldNames
                    )
                in
                    ExpandedTable
        in
            GetAllData()
in
    FetchDataFromApi