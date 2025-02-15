#include "protheus.ch"
#include "parmtype.ch"
#include "TOTVS.CH""
#include "RESTFUL.CH"

User Function ChamaChatGPT()

    Local cKey := GetMV("CHATGPT_API_KEY") // Chave da API no Appserver.ini LOCAL
    private oRest:=FwRest():New("https://api.openai.com")
    private aHeader:= {}
    Local cPrompt := "Explique como funciona um pedido de venda no Protheus."


    oRest:setPath("/v1/chat/completions")
    Aadd(aHeader,"Authorization: Bearer ")
    Aadd(aHeader, cKey)
    Aadd(aHeader, "Content-Type", "application/json")

    If oRest:Post(aHeader)
        CanOut("POST", oRest:GetResult())
    else
        CanOut("POST", oRest:GetLastError())

    private resultado := oRest:GetResult()
    private erro := oRest:GeetLastError()

    alert(resultado)
    alert(erro)
    ConOut("Fim")

    // Corpo da requisição
    Local cBody := '{ "model": "gpt-4", "messages": [{"role": "user", "content": "' + cPrompt + '"}] }'
   
Return
 