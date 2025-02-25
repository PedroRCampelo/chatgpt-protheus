#include "PROTHEUS.ch"
#include "parmtype.ch"
#include "TOTVS.CH""
#include "RESTFUL.CH"

User Function zFuncao()
    Local aArea         := FWGetArea()
    Local nCorFundo     := RGB(238, 238, 238)
    Local nJanAltura    := 330
    Local nJanLargur    := 644 
    Local cJanTitulo    := 'Assistente de perguntas'
    Local lDimPixels    := .T. 
    Local lCentraliz    := .T. 
    Local nObjLinha     := 0
    Local nObjColun     := 0
    Local nObjLargu     := 0
    Local nObjAltur     := 0
    Private cFontNome   := 'Tahoma'
    Private oFontPadrao := TFont():New(cFontNome, , -12)
    Private oDialogPvt 
    Private bBlocoIni   := {|| /*fSuaFuncao()*/ } //Aqui voce pode acionar funcoes customizadas que irao ser acionadas ao abrir a dialog 

    //caixaperg 
    Private oMulcaixaperg 
    Private cMulcaixaperg    := ''   

    //objeto3 
    Private oMulObj3 
    Private cMulObj3    := ''

     //submit 
    Private oBtnsubmit 
    Private cBtnsubmit    := 'Perguntar'  
    Private bBtnsubmit   := {|| cMulObj3:=ChamaChatGPT(cMulcaixaperg)}   

    //Cria a dialog
    oDialogPvt := TDialog():New(0, 0, nJanAltura, nJanLargur, cJanTitulo, , , , , , nCorFundo, , , lDimPixels)
    
        //caixaperg - usando a classe TMultiGet
        nObjLinha := 19
        nObjColun := 75
        nObjLargu := 100
        nObjAltur := 60
        oMulcaixaperg  := TMultiGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , cMulcaixaperg := u, cMulcaixaperg)}, oDialogPvt, nObjLargu, nObjAltur, oFontPadrao, , , , , lDimPixels, , , /*bWhen*/, , , /*lReadOnly*/, /*bValid*/, , , /*lNoBorder*/, .T.)

        //submit - usando a classe TButton
        nObjLinha := 49
        nObjColun := 189
        nObjLargu := 50
        nObjAltur := 15
        oBtnsubmit  := TButton():New(nObjLinha, nObjColun, cBtnsubmit, oDialogPvt, bBtnsubmit, nObjLargu, nObjAltur, , oFontPadrao, , lDimPixels)

        //objeto3 - usando a classe TMultiGet
        nObjLinha := 93
        nObjColun := 93
        nObjLargu := 150
        nObjAltur := 60
        oMulObj3  := TMultiGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , cMulObj3 := u, cMulObj3)}, oDialogPvt, nObjLargu, nObjAltur, oFontPadrao, , , , , lDimPixels, , , /*bWhen*/, , , /*lReadOnly*/, /*bValid*/, , , /*lNoBorder*/, .T.)

    
    //Ativa e exibe a janela
    oDialogPvt:Activate(, , , lCentraliz, , , bBlocoIni)
    
    FWRestArea(aArea)
Return

Static Function ChamaChatGPT(msg1)
    Local cPrompt := msg1
    Local cKey := GetMV("MV_X_KEY") // Chave da API no Par�metro customizado
    Local choicesJson
    Local messageJson
    private oRest:=FwRest():New("https://api.openai.com")
    private cPath:= "/v1/chat/completions"
    private aHeader:= {}
    private cBody := ""

    //Header
    Aadd(aHeader,"Authorization: Bearer " + cKey)
    Aadd(aHeader, "Content-Type: application/json")

    //Body
    cBody := '{"model": "gpt-4", "messages": ['
    cBody += '{"role": "developer", "content": "voce e um assistente virtual do erp totvs protheus"},'
    cBody += '{"role": "developer", "content": "priorize sites oficiais TOTVS para buscar respostas"},'
    cBody += '{"role": "developer", "content": "ao final da resposta explique que nao e uma resposta oficial totvs"},'
    cBody += '{"role": "user", "content": "' + cPrompt + '"}'
    cBody +=�']}'

    oRest:SetPath(cPath)
    oRest:SetPostParams(cBody)

    If oRest:Post(aHeader)
        ConOut("POST", oRest:GetResult())
    Else
        ConOut("POST", oRest:GetLastError())

    Endif
 
    // !!!!!!Quando da Erro a vari�vel cError n�o est� sendo preenchida!!!!!!!
    
    private resultado := oRest:GetResult()
    private erro := oRest:GetLastError()
    
    jDados := JsonObject():New()
    cError := jDados:FromJson(resultado)

    If ! Empty(cError)
    FWAlertError("Houve um erro:" + cError, "Falha")
    Else

    Endif

    choicesJson := jDados:GetJsonObject("choices") // Array choices
    messageJson := choicesJson[1]:GetJsonObject("message") // Json message
    content := messageJson:GetJsonObject("content") // Content - Response to sent to the client


 
Return content

