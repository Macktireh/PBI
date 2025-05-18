let
    GetPage = (Index as number) =>
        let
            offset = Index * Number.FromText(API_QUERY_PARAM_LIMIT_ITEMS),
            RelativePath = "",
            Query = GetURLSearchParams(offset),
            Json = GetJson(RelativePath, Query),
            Results = Json[#"results"]
        in
            Results,
    GetData = () =>
        let
            IDCount = List.Max({Number.FromText(API_QUERY_PARAM_LIMIT_ITEMS), GetTotalCount("total_count")}),
            PageCount = Number.RoundUp(IDCount / Number.FromText(API_QUERY_PARAM_LIMIT_ITEMS)),
            PageIndices = {0..PageCount - 1},
            Pages = List.Transform(PageIndices, each GetPage(_)),
            JiraID = List.Union(Pages),
            Table = Table.FromList(JiraID, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
            ColumnNamesIndex = List.Positions(Table.ColumnNames(Table)),
            RecordColumnIndex = List.First(
                List.Select(ColumnNamesIndex, each Type.Is(Value.Type(Record.FieldValues(Table{0}){_}), type record))
            ),
            RecordColumnName = Table.ColumnNames(Table){RecordColumnIndex},
            RecordFieldNames = Record.FieldNames(Record.FieldValues(Table{0}){RecordColumnIndex}),
            ExpandedColumn = Table.ExpandRecordColumn(Table, RecordColumnName, RecordFieldNames, RecordFieldNames)
        in
            ExpandedColumn
in
    GetData
