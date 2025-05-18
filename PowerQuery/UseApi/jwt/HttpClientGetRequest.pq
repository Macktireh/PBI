let
    // Fonction pour envoyer une requête HTTP
    HttpClient = (RelativePath as text, optional Query as record, optional Headers as record) =>
        let
            Options = [
                // Chemin relatif de l'API
                RelativePath = RelativePath,
                // Paramètres de requête
                Query = (Query ?? []),
                // En-têtes de la requête
                Headers = (Headers ?? [])
            ],
            // Envoie la requête HTTP avec les paramètres spécifiés
            RawData = Web.Contents(API_BASE_URL, Options),
            // Convertit la réponse brute en format JSON
            Json = Json.Document(RawData)
        in
            Json
in
    HttpClient
