User Function ChamaChatGPT()
    Local cURL := "https://api.openai.com/v1/chat/completions"
    Local cKey := GetMV("CHATGPT_API_KEY") // Chave da API no Appserver.ini LOCAL
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
