User Function ChamaChatGPT()
    Local cURL := "https://api.openai.com/v1/chat/completions"
    Local cKey := "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" // Substitua pela sua chave da OpenAI
    Local cPrompt := "Explique como funciona um pedido de venda no Protheus."
    Local cResponse := ""
    Local oHttp

    // Configura a requisição HTTP
    oHttp := HttpClient():New(cURL)
    oHttp:SetHeader("Authorization", "Bearer " + cKey)
    oHttp:SetHeader("Content-Type", "application/json")

    // Corpo da requisição
    Local cBody := '{ "model": "gpt-4", "messages": [{"role": "user", "content": "' + cPrompt + '"}] }'
    
    // Faz a requisição POST
    cResponse := oHttp:Post(cBody)

    // Exibe a resposta
    MsgInfo(cResponse, "Resposta do ChatGPT")
Return
