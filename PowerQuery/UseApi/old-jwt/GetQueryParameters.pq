let
    // Fonction pour obtenir les paramètres de requête, avec des paramètres optionnels
    GetQueryParameters = (optional Skip as number, optional Query as record) =>
        let
            // Combine les paramètres de requête par défaut avec les paramètres optionnels fournis
            Query = Record.Combine(
                {[
                    // Paramètre 'skip' pour ignorer un certain nombre d'éléments
                    skip = Number.ToText(Skip ?? API_SKIP),
                    // Paramètre 'limit' pour limiter le nombre d'éléments retournés
                    limit = Number.ToText(API_LIMIT)
                ], (Query ?? [])}
            )
        in
            Query
in
    GetQueryParameters
