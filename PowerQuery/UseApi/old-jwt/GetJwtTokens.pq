let
    // Fonction pour obtenir les jetons JWT
    GetJwtTokens = () =>
        let
            // Obtient les en-têtes par défaut
            Headers = GetHeadersParameters(),
            // Paramètres de requête (vide dans ce cas)
            Quey = [],
            // Corps de la requête avec les informations d'identification
            Body = [
                username = "emilys",
                password = "emilyspass"
            ],
            // Envoie une requête HTTP pour obtenir les jetons JWT
            Response = HttpClient("auth/login", Quey, Headers, Body),
            // Extrait les jetons d'accès et de rafraîchissement de la réponse
            JwtTokens = [
                accessToken = Record.Field(Response, "accessToken"),
                refreshToken = Record.Field(Response, "refreshToken")
            ]
        in
            JwtTokens
in
    GetJwtTokens
