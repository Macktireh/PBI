let
    // Function for sending an HTTP GET request
    HttpClientGetRequest = (RelativePath as text, optional Query as record, optional Headers as record) =>
        let
            Options = [
                RelativePath = RelativePath,
                Query = (Query ?? []),
                Headers = (Headers ?? [])
            ],
            RawData = Web.Contents(API_BASE_URL, Options),
            Json = Json.Document(RawData)
        in
            Json
in
    HttpClientGetRequest