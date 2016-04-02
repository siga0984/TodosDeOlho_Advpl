#include 'protheus.ch'
#include 'apwebex.ch'

/*
Detalhamento de Propostas
Recebe IDPRO pela URL
*/

User function Siconv04()
Local cHtml := ''
Local aStru := {} , nI

PRIVATE cIDPro := HTTPGET->IDPRO

WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

If empty(cIDPro)
	
	PRIVATE cErrorMSG := "Proposta para pesquisa não recebida."
	PRIVATE cErrorHLP := 'A busca por propostas não recebeu corretamente o código a ser pesquisado. '+;
												'Retorne para a tela anterior e tente novamente, ou volte ao início do site.'
	
	cHtml := h_SicError()
	
Else
	
	cQuery := "select * from PROSPGM where IDPRO = '"+cIdPro+"'"
	
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

	PRIVATE cCodCCD := QRY->CDORGCCD
	PRIVATE cMunic := alltrim(QRY->NMMUNPPN)
	PRIVATE cUF := QRY->UFPPN      
	PRIVATE cOrgaoCCD := alltrim(QRY->NMORGCCD)
	
	cQuery := "select * from PROGRAMAS where CDPGM = '"+alltrim(QRY->CDPGM)+"'"
	
	USE (TcGenQry(,,cQuery)) ALIAS QRYPROG EXCLUSIVE NEW VIA "TOPCONN"
	
	aStru := DbStruct()
	For nI := 1 to len(aStru)
		cCpo := aStru[nI][1]
		If left(cCpo,2)=="DT"
			TCSetField('QRYPROG',cCpo,'D',8,0)
		ElseIf left(cCpo,2)=="VL"
			TCSetField('QRYPROG',cCpo,'N',18,2)
		Endif
	Next
	
	
	cQuery := "select * from convenioaux.dbo.PLANOAPLIC where IDPRO = '"+cIdPro+"'"
	
	USE (TcGenQry(,,cQuery)) ALIAS QRYPLANOAP EXCLUSIVE NEW VIA "TOPCONN"
	
	aStru := DbStruct()
	For nI := 1 to len(aStru)
		cCpo := aStru[nI][1]
		If left(cCpo,2)=="DT"
			TCSetField('QRYPLANOAP',cCpo,'D',8,0)
		ElseIf left(cCpo,2)=="VL"
			TCSetField('QRYPLANOAP',cCpo,'N',18,2)
		Endif
	Next
	
	cHtml := H_Siconv04()
	
	DbSelectArea("QRY")
	USE
	
	DbSelectArea("QRYPROG")
	USE
	
	DbSelectArea("QRYPLANOAP")
	USE
	
Endif

WEB EXTENDED END

Return cHtml


