let
    // Fonction pour obtenir les paramètres d'en-tête, avec des en-têtes optionnels
    GetHeadersParameters = (optional Headers as record) =>
        let
            // Combine les en-têtes par défaut avec les en-têtes optionnels fournis
            Headers = Record.Combine({[
                #"Content-Type" = "application/json"
            ], (Headers ?? [])})
        in
            Headers
in
    GetHeadersParameters
