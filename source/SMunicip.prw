#include 'protheus.ch'

User Function SMunicip()

U_DBSetup()

cQuery := 'SELECT CODIGO,NOME,UF,LATITUDE,LONGITUDE FROM convenioaux.dbo.MUNICIP ORDER BY CODIGO'

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"

nH := fcreate("\dbscripts\municip.sql")

fWrite(nH ,'use conveniomysql;'+CRLF)
fWrite(nH , CRLF );

cCreate := 'CREATE TABLE IF NOT EXISTS MUNICIP ('+CRLF
cCreate += '   CODIGO int(4) NOT NULL ,'+CRLF
cCreate += '   NOME varchar(40) NOT NULL,'+CRLF
cCreate += '   UF char(2) NOT NULL , '+CRLF
cCreate += '   LATITUDE FLOAT (6,2) NOT NULL,'+CRLF
cCreate += '   LONGITUDE FLOAT (6,2) NOT NULL );'+CRLF

fWrite(nH , cCreate )
fWrite(nH , CRLF )

fWrite(nH , 'SET autocommit = 0;'+CRLF )
fWrite(nH , CRLF )

While !eof()
	If ! empty(QRY->CODIGO)
		cSave := "Insert into MUNICIP (CODIGO,NOME,UF,LATITUDE,LONGITUDE) values ("
		cSave += QRY->CODIGO
		cSave += ",'" + _escape(alltrim(QRY->NOME))+"'"
		cSave += ",'" + QRY->UF+"'"
		cSave += ","+IIF(empty(QRY->LATITUDE),'0',QRY->LATITUDE)
		cSave += ","+IIF(empty(QRY->LONGITUDE),'0',QRY->LONGITUDE)
		cSave += ");" + CRLF
		fWrite(nH , cSave)
	Endif
	DbSkip()
Enddo

fWrite(nH , 'commit;'+CRLF )
fWrite(nH , CRLF )
	
fWrite(nH ,'Create Index MUNICIP1 ON MUNICIP ( CODIGO );'+CRLF)
fWrite(nH ,'Create Index MUNICIP2 ON MUNICIP ( UF,NOME );'+CRLF)


fClose(nH)

USE

MsgInfo("Script municip.sql criado")

return

static function _escape(cStr)
cStr := strtran(cStr,"'","''")
return cStr
