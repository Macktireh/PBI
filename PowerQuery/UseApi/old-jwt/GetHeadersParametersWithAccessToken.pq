let
    // Fonction pour obtenir les paramètres d'en-tête avec un jeton d'accès, avec des en-têtes optionnels
    GetHeadersParametersWithAccessToken = (optional Headers as record) =>
        let
            // Obtient le jeton JWT
            JwtToken = GetJwtToken(),
            // Extrait le jeton d'accès du jeton JWT
            accessToken = Record.Field(JwtToken, "accessToken"),
            // Combine les en-têtes par défaut, les en-têtes optionnels fournis et le jeton d'accès
            Headers = Record.Combine(
                {GetHeadersParameters((Headers ?? [])), [
                    Authorization = Text.Format("Bearer #{0}", {accessToken})
                ]}
            )
        in
            Headers
in
    GetHeadersParametersWithAccessToken
