let
    // Function for obtaining JWT tokens
    GetJwtTokens = () =>
        let
            Headers = GetHeadersParameters(),
            Quey = [],
            Body = [
                username = API_LOGIN_USERNAME,
                password = API_LOGIN_PASSWORD
            ],
            Response = HttpClientPostRequest("auth/login", Quey, Headers, Body),
            JwtTokens = [
                accessToken = Record.Field(Response, "accessToken"),
                refreshToken = Record.Field(Response, "refreshToken")
            ]
        in
            JwtTokens
in
    GetJwtTokens