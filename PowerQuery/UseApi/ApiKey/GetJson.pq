let
    GetJson = (RelativePath as text, Query as record) =>
        let
            RawData = Web.Contents(API_BASE_URL, [RelativePath = RelativePath, Query = Query]),
            Json = Json.Document(RawData)
        in
            Json
in
    GetJson
