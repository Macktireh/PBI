let
    // Function for sending an HTTP POST request
    HttpClientPostRequest = (
        RelativePath as text, optional Query as record, optional Headers as record, optional Body as record
    ) =>
        let
            Options = [
                RelativePath = RelativePath,
                Query = (Query ?? []),
                Headers = (Headers ?? []),
                Content = Json.FromValue(Body ?? [])
            ],
            RawData = Web.Contents(API_BASE_URL, Options),
            Json = Json.Document(RawData)
        in
            Json
in
    HttpClientPostRequest