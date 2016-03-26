#include 'protheus.ch'
#include 'apwebex.ch'
#include 'siconvlib.ch'


User function Siconv03()
Local cHtml := ''
Local aStru

PRIVATE cIDMun  := HTTPGET->MUN
PRIVATE cCodCCD := HTTPGET->CCD
PRIVATE cMunic
PRIVATE cUF
PRIVATE cOrgaoCCD

PRIVATE nPage := 1
PRIVATE nPageSize := ITENS_POR_PAGINA
PRIVATE cOrd := 'D'

WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

If empty(cIDMun) .or. empty(cCodCCD)

	PRIVATE cErrorMSG := "Parâmetros de pesquisa não recebidos."
	PRIVATE cErrorHLP := 'A busca por propostas não recebeu corretamente o municípo e o órgão a serem pesquisados. '+;
											 'Retorne para a tela anterior e tente novamente, ou volte ao início do site.'

	cHtml := h_SicError()
	
Else
	
	
	If !U_MunByID(cIDMun,@cMunic,@cUF)
		UserException("Municipio ["+cIDMun+"] não encontrado")
	Endif
	
	IF !U_OrgById(cCodCCD,@cOrgaoCCD)
		UserException("Orgao ["+cOrgaoCCD+"] não encontrado")
	Endif
	
	If !empty(HTTPGET->PAGE)
		nPage := val(HTTPGET->PAGE)
	Endif
	
	If !empty(HTTPGET->ORD)
		cOrd := HTTPGET->ORD
	Endif
	
	
	If cOrd == 'D'
		// Data de proposta
		cOrderBy := 'DTPRO desc'
	ElseIf cOrd == 'V'
		// Valor Gobal
		cOrderBy := 'VL_GLOBAL desc'
	Else
		// QQer outra coisa, vai data mesmo
		cOrderBy := 'DTPRO desc'
	EndIf
	
	cQuery := U_PageQry("*",;
	"PROSPGM",;
	"UFPPN = '"+cUf+"' and NMMUNPPN = '"+_escape(cMunic)+"' and CDORGCCD = '"+cCodCCD+"'",;
	cOrderBy,nPage,nPageSize)
	
	USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"
	
	aStru := DbStruct()
	For nI := 1 to len(aStru)
		cCpo := aStru[nI][1]
		If left(cCpo,2)=="DT"
			TCSetField('QRY',cCpo,'D',8,0)
		ElseIf left(cCpo,2)=="VL"
			TCSetField('QRY',cCpo,'N',18,2)
		Endif
	Next
	
	cHtml := H_Siconv03()
	
	USE
	
Endif

WEB EXTENDED END

Return cHtml


static function _escape(cStr)
cStr := strtran(cStr,"'","''")
return cStr
