#include "protheus.ch"
#include "parmtype.ch"
#include "TOTVS.CH""
#include "RESTFUL.CH"

User Function ChamaChatGPT()
    Local cPrompt := "Escreva um oi"
    Local cKey := GetMV("MV_X_KEY") // Chave da API no Appserver.ini LOCAL
    Local choices
    Local conteudo := ""
    private oRest:=FwRest():New("https://api.openai.com")
    private cPath:= "/v1/chat/completions"
    private aHeader:= {}
    private cBody := ""
    

    //Header
    Aadd(aHeader,"Authorization: Bearer " + cKey)
    Aadd(aHeader, "Content-Type: application/json")

    //Body
    cBody := '{"model": "gpt-4", "messages": ['
    cBody += '{"role": "user", "content": "' + cPrompt + '"}'
    cBody+= ']}'

    oRest:SetPath(cPath)
    oRest:SetPostParams(cBody)

    If oRest:Post(aHeader)
        ConOut("POST", oRest:GetResult())
    Else
        ConOut("POST", oRest:GetLastError())

    Endif

    private resultado := oRest:GetResult()
    private erro := oRest:GetLastError()
    
    jDados := JsonObject():New()
    cError := jDados:FromJson(resultado)

    If ! Empty(cError)
    FWAlertError("Houve um erro:" + cError, "Falha")
    Else

    Endif

    choices := jDados:GetJsonObject("choices") // Array choices

    If ValType(choices) == "A"
        conteudo += choices[1]:GetJsonObject("message")
    endif

    alert(conteudo)
    alert(erro)
    ConOut("Fim")

Return

    // Corpo da requisição
    // Local cBody := '{ "model": "gpt-4", "messages": [{"role": "user", "content": "' + cPrompt + '"}] }'
   
 