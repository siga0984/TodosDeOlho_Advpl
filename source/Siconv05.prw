#include 'protheus.ch'
#include 'apwebex.ch'

/*
Detalhamento de Convenios
Recebe IDCNV pela URL
*/

User function Siconv05()
Local cHtml := ''

PRIVATE cIDCNV := HTTPGET->IDCNV

WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

If empty(cIDCNV)
	
	PRIVATE cErrorMSG := "Convênio para pesquisa não recebida."
	PRIVATE cErrorHLP := 'A busca por convênio não recebeu corretamente o código a ser pesquisado. '+;
											'Retorne para a tela anterior e tente novamente, ou volte ao início do site.'
	
	cHtml := h_SicError()
	
Else
	
	cQuery := "select * from PROSPGM where IDCNV = '"+cIDCNV+"'"
	
	USE (TcGenQry(,,cQuery)) ALIAS QRYPROP EXCLUSIVE NEW VIA "TOPCONN"
	
	aStru := DbStruct()
	For nI := 1 to len(aStru)
		cCpo := aStru[nI][1]
		If left(cCpo,2)=="DT"
			TCSetField('QRYPROP',cCpo,'D',8,0)
		ElseIf left(cCpo,2)=="VL"
			TCSetField('QRYPROP',cCpo,'N',18,2)
		Endif
	Next

	PRIVATE cCodCCD := QRYPROP->CDORGCCD
	PRIVATE cMunic := alltrim(QRYPROP->NMMUNPPN)
	PRIVATE cUF := QRYPROP->UFPPN      
	PRIVATE cOrgaoCCD := alltrim(QRYPROP->NMORGCCD)
	
	
	cQuery := "select * from CNVSPGMS where IDCNV = '"+cIDCNV+"'"
	
	USE (TcGenQry(,,cQuery)) ALIAS QRYCONV EXCLUSIVE NEW VIA "TOPCONN"
	
	aStru := DbStruct()
	For nI := 1 to len(aStru)
		cCpo := aStru[nI][1]
		If left(cCpo,2)=="DT"
			TCSetField('QRYCONV',cCpo,'D',8,0)
		ElseIf left(cCpo,2)=="VL"
			TCSetField('QRYCONV',cCpo,'N',18,2)
		Endif
	Next
	
	cQuery := "select * from PROGRAMAS where CDPGM = '"+alltrim(QRYCONV->CDPGM)+"'"
	
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
	
	cQuery := "select * from convenioaux.dbo.PLANOAPLIC where IDCNV = '"+cIDCNV+"'"
	
	USE (TcGenQry(,,cQuery)) ALIAS QRYPLANOAP EXCLUSIVE NEW VIA "TOPCONN"
	
	aStru := DbStruct()
	For nI := 1 to len(aStru)
		cCpo := aStru[nI][1]
		If left(cCpo,2)=="DT"
			TCSetField('QRYPROG',cCpo,'D',8,0)
		ElseIf left(cCpo,2)=="VL"
			TCSetField('QRYPROG',cCpo,'N',18,2)
		Endif
	Next
	
	cHtml := H_Siconv05()
	
	DbSelectArea("QRYCONV")
	USE
	
	DbSelectArea("QRYPROP")
	USE
	
	DbSelectArea("QRYPROG")
	USE
	
	DbSelectArea("QRYPLANOAP")
	USE
	
Endif

WEB EXTENDED END

Return cHtml


