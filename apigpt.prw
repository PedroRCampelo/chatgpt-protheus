#include "protheus.ch"
#include "parmtype.ch"
#include "TOTVS.CH""
#include "RESTFUL.CH"

User Function zFuncao()
    Local aArea         := FWGetArea()
    Local nCorFundo     := RGB(238, 238, 238)
    Local nJanAltura    := 330
    Local nJanLargur    := 644 
    Local cJanTitulo    := 'PDialogMaker - Versao 1.02'
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
    //submit 
    Private oBtnsubmit 
    Private cBtnsubmit    := 'Button'  
    Private bBtnsubmit    := {|| MsgInfo(submit(cMulcaixaperg, cMulObj3), 'Atencao submit')}  
    //objeto3 
    Private oMulObj3 
    Private cMulObj3    := ''  
    
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

/*/{Protheus.doc} submit
    (long_description)
    @type  Static Function
    @author user
    @since 19/02/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function submit(pergunta, resposta)
    resposta += M->pergunta
    alert(M->pergunta)
    alert(M->resposta)

Return 

User Function ChamaChatGPT()
    Local cPrompt := "Escreva um oi"
    Local cDevelopMsg1 := "Você é um assistente virtual para funcionalidades do TOTVS Protheus."
    Local cDevelopMsg2 := "Ao final de cada resposta escreva: Esta resposta é gerada automática baseada em um modelo de IA não oficial TOTVS"
    Local cKey := GetMV("MV_X_KEY") // Chave da API no Parâmetro customizado
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
    cBody += '{"role": "developer", "content": "' + cDevelopMsg1 + cDevelopMsg2 + '"}'
    cBody+= ']},'
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
   
 