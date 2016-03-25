
user Function Municipios()
Local nHTop
Local aStru
Local nI

SET DATE BRITISH
SET CENTURY ON

U_DBSetup()

varinfo("",tcInternal(30,"AUTORECNO"))

if tcgetDB() = "MYSQL"
	nErr := tcsqlexec("SET autocommit = 0;")
	IF nErr < 0 
		UserException(TcSqlError())
	Endif
Endif

IF !TcCanOpen("MUNICIPIO")
        
	aStru := {}
	aadd(aStru,{"CODIGO","C",4,0})
	aadd(aStru,{"NOME","C",40,0})
	aadd(aStru,{"UF","C",2,0})

	DbCreate("MUNICIPIO",aStru,"TOPCONN")

Endif

           
USE MUNICIPIO ALIAS MUNICIPIO SHARED NEW VIA "TOPCONN"

While !eof()
	aadd(aMunic,{alltrim(MUNICIPIO->NOME),MUNICIPIO->UF})
	DbSkip()
enddo

Return
