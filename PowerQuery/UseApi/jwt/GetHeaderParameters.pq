let
    // Function for obtaining header parameters, with optional headers
    GetHeadersParameters = (optional Headers as record) =>
        let
            Headers = Record.Combine({[
                #"Content-Type" = "application/json"
            ], (Headers ?? [])})
        in
            Headers
in
    GetHeadersParameters