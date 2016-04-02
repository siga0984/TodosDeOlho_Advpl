

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
		aadd(aSTru,{"URL","C",128,0})
		aadd(aSTru,{"USERAGENT","C",384,0})
		aadd(aSTru,{"LANGUAGE","C",64,0})

		DBCreate("LOGSITE",aStru,"TOPCONN")

		USE LOGSITE ALIAS LOGSITE SHARED NEW VIA "TOPCONN"
       
  	INDEX ON dtos(ACDATE)+ACTIME to LOGSITE1
  	INDEX ON URL+dtos(ACDATE)+ACTIME to LOGSITE2

		USE

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
		aadd(aStru,{"IDPROP"  ,"C",7,0})
		aadd(aStru,{"APOIA"   ,"N",8,0})
		aadd(aStru,{"REPROVA" ,"N",8,0})
		aadd(aStru,{"SUSPEITO","N",8,0})
		aadd(aStru,{"VISTO"   ,"N",8,0})
		
		DbCreate("FEEDPRO",aStru,"TOPCONN")
		

		USE FEEDPRO ALIAS FEEDPRO EXCLUSIVE NEW VIA "TOPCONN"
		
		INDEX ON IDPROP TO FEEDPRO1

		USE

	Endif
	
	USE FEEDPRO ALIAS FEEDPRO SHARED NEW VIA "TOPCONN"
	DbSetIndex("FEEDPRO1")
	DbSetORder(1)
	
Endif

Return



USER Function DBSetup()
Local nHTop

If TCIsConnected()
	Return .t.
Endif

SET DATE BRITISH
SET CENTURY ON

nHTop := tclink()

If nHTop < 0 
	UserException("Falha de conexão com o Banco de Dados - DBError ("+cValToChar(nHTop)+")")
Endif     

Return .T.




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


USER Function SetFeed()
Local cIdPro := Httppost->IDPRO
Local cAct   := Httppost->ACT
Local aRet := {0,0,0}
Local cCpo := ''

U_DBSetup()

U_LogSite()

If !empty(cIdPro) .and. !empty(cAct)
	
	u_FeedPro()
	
	DbSelectArea("FEEDPRO")
	DbSetOrder(1)
	If !DbSeek(cIdPro)
		DBAppend()
		FEEDPRO->IDPROP := cIdPro
		DbRUnlock()
	Endif
	
	If cAct == 'A'
		cCpo := 'APOIA'
	ElseIF cAct == 'R'
		cCpo := 'REPROVA'
	ElseIF cAct == 'S'
		cCpo := 'SUSPEITO'
	Endif

	If !empty(cCpo)	
		cSql := "UPDATE FEEDPRO SET " +cCpo + " = " + cCpo+" + 1 WHERE R_E_C_N_O_ = "+cValToChar(recno())
		Tcsqlexec(cSql)
	Endif
		
	dbgoto(recno())   
	
	aRet[1] := FEEDPRO->APOIA
	aRet[2] := FEEDPRO->REPROVA
	aRet[3] := FEEDPRO->SUSPEITO
	
Endif

Return "A="+cValToChar(aRet[1])+'&R='+cValToChar(aRet[2])+'&S='+cValToChar(aRet[3])


USER Function GetFeed(cIdpro)
Local aRet := {0,0,0}

U_DBSetup()

U_FeedPro()

DbSelectArea("FEEDPRO")
DbSetOrder(1)
If DbSeek(cIdPro)
	aRet[1] := FEEDPRO->APOIA
	aRet[2] := FEEDPRO->REPROVA
	aRet[3] := FEEDPRO->SUSPEITO
Endif

Return aRet



USER Function SetVisto(cIdPro)

U_DBSetup()

u_FeedPro()

DbSelectArea("FEEDPRO")
DbSetOrder(1)
If !DbSeek(cIdPro)
	DBAppend()
	FEEDPRO->IDPROP := cIdPro
	DbRUnlock()
Endif

cSql := "UPDATE FEEDPRO SET VISTO = VISTO + 1 WHERE R_E_C_N_O_ = "+cValToChar(recno())
Tcsqlexec(cSql)

Return

