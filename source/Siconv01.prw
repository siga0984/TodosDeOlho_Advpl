#include 'protheus.ch'
#include 'apwebex.ch'


User function Siconv01()
Local cHtml := ''

PRIVATE cIDMun := HTTPGET->MUN
PRIVATE cMunic
PRIVATE cUF

WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

If empty(cIDMun)
	
	// Nao chegou o estado
	PRIVATE cErrorMSG := "Munic�pio n�o informado."
	PRIVATE cErrorHLP := 'A busca n�o recebeu corretamente o munic�pio a ser pesquisado. '+;
	'Retorne para a tela anterior e tente novamente, ou volte ao in�cio do site.'
	
	cHtml := h_SicError()
	
Else
	
	If !U_MunByID(cIDMun,@cMunic,@cUF)
		UserException("Municipio ["+cIDMun+"] n�o encontrado")
	Endif
	
	cHtml := H_Siconv01()
	
Endif

WEB EXTENDED END

Return cHtml
