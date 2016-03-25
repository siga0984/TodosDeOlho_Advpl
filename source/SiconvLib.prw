

User Function MunByID(cId,cMunic,cUF)

Local cQuery := ''
Local lFound := .f.

cQuery += "select NOME,UF from convenioaux.dbo.MUNICIP "
cQuery += "where CODIGO = '"+cId+"'"

// conout(cQuery)

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA 'TOPCONN'

If eof()
	cMunic := ''
	cUf := ''
Else
	lFound := .t.
	cMunic := alltrim(QRY->NOME)
	cUf    := alltrim(QRY->UF)
Endif

USE

Return lFound

User Function OrgById(cId,cNome)
Local cQuery := ''
Local lFound := .f.

cQuery += "select NOME from convenioaux.dbo.ORGAO "
cQuery += "where CODIGO = '"+cId+"'"

// conout(cQuery)

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA 'TOPCONN'

If eof()
	cNome := ''
Else
	lFound := .t.
	cNome := alltrim(QRY->NOME)
Endif

USE

Return lFound



User Function LogSite()
Local aStru := {}

/*
varinfo("Headers",HTTPHEADIN->AHeaders )
varinfo("SessionID",HttpCookies->SESSIONID )
varinfo("REMOTE_ADDR",HTTPHEADIN->REMOTE_ADDR)
*/

If Select("LOGSITE") == 0

	IF !TcCanOpen("LOGSITE")
		aadd(aSTru,{"ACDATE","D",8,0})
		aadd(aSTru,{"ACTIME","C",8,0})
		aadd(aSTru,{"SESSION","C",32,0})
		aadd(aSTru,{"CLIENTIP","C",15,0})
		aadd(aSTru,{"HOST","C",64,0})
		aadd(aSTru,{"URL","C",64,0})
		aadd(aSTru,{"USERAGENT","C",200,0})
		aadd(aSTru,{"LANGUAGE","C",32,0})
		DBCreate("LOGSITE",aStru,"TOPCONN")
	Endif
	
	USE LOGSITE ALIAS LOGSITE SHARED NEW VIA "TOPCONN"
	
Endif

// Acrescenta um LOG

DbSelectArea("LOGSITE")
DBAppend(.t.)

LOGSITE->ACDATE := date()
LOGSITE->ACTIME := time()
LOGSITE->SESSION := cValToChar(HttpCookies->SESSIONID)
LOGSITE->CLIENTIP := cValToChar(HttpHEadIn->REMOTE_ADDR)
LOGSITE->HOST := cValToChar(HttpHEadIn->HOST)
LOGSITE->URL := HttpHEadIn->aHEaders[1]
LOGSITE->USERAGENT := cValToChar(HttpHeadIn->User_Agent)
LOGSITE->LANGUAGE := cValToChar(HttpHEadIn->Accept_Language)

DbRUnlock()

Return


        
USER Function FeedPro()
Local aStru := {}

If Select("FEEDPRO") == 0
	
	If !tccanopen("FEEDPRO")
		
		aStru := {}
		aadd(aStru,{"IDPRO","C",7,0})
		aadd(aStru,{"ACAO","C",1,0})  // Curtir, Descurtir, Suspeito
		aadd(aSTru,{"SESSION","C",32,0})
		aadd(aStru,{"DTACT","D",8,0})
		
		DbCreate("FEEDPRO",aStru,"TOPCONN")
		
	Endif
	
	USE FEEDPRO ALIAS FEEDPRO SHARED NEW VIA "TOPCONN"
	
Endif

Return



USER Function SetFeed(cIdProp,cFeed)

DbSelectArea("FEEDPRO")
DBAppend(.t.)
FEEDPRO->IDPRO := cIdProp
FEEDPRO->ACAO := cFeed
FEEDPRO->SESSION := HttpCookies->SESSIONID
FEEDPRO->DTACT := date()
DbRUnlock()

Return



USER Function DBSetup()
Local nHTop

If !TCIsConnected()
	
	SET DATE BRITISH
	SET CENTURY ON
	
	nHTop := tclink()
	
	If nHTop < 0
		UserException("Falha de conexão com a base de dados - Errro ("+cValToChar(nHTop)+")")
	Endif
	
Endif

Return

// Paginação para MSSQL 

USER Function PageQry(cFields,cFrom,cWhere,cOrder,nPageNum,nPageSize)
Local cQuery := ''
Local nStartRow := ((nPageNum-1) * @nPageSize) + 1

cQuery := "SELECT "+cFields
cQuery += " FROM ( "
cQuery += "	select * , ROW_NUMBER() OVER (ORDER BY "+cOrder+") AS _RANK "
cQuery += " from " + cFrom 
cQuery += " where " + cWhere+" ) AS ResultWithRowNumbers "
cQuery += " where _RANK >= "+cValToChar(nStartRow)
cQuery += " and _RANK < "+cValToChar(nStartRow+nPageSize)

Return cQuery



