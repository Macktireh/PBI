let
    // Function for obtaining header parameters with an access token, with optional headers
    GetHeadersParametersWithAccessToken = (optional Headers as record) =>
        let
            JwtToken = GetJwtTokens(),
            accessToken = Record.Field(JwtToken, "accessToken"),
            Headers = Record.Combine(
                {GetHeadersParameters((Headers ?? [])), [
                    Authorization = Text.Format("Bearer #{0}", {accessToken})
                ]}
            )
        in
            Headers
in
    GetHeadersParametersWithAccessToken