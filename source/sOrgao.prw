#include 'protheus.ch'

User Function SOrgao()

U_DBSetup()

cQuery := 'SELECT CODIGO,CODSUP,NOME FROM convenioaux.dbo.ORGAO ORDER BY CODSUP,CODIGO'

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"

nH := fcreate("\dbscripts\orgao.sql")

fWrite(nH ,'use conveniomysql;'+CRLF)
fWrite(nH , CRLF );

cCreate := 'CREATE TABLE IF NOT EXISTS ORGAO ('+CRLF
cCreate += '   ID int(5) NOT NULL ,'+CRLF
cCreate += '   IDSUP int(5) NOT NULL ,'+CRLF
cCreate += '   NOME varchar(70) NOT NULL );'+CRLF

fWrite(nH , cCreate )
fWrite(nH , CRLF )

fWrite(nH , 'SET autocommit = 0;'+CRLF )
fWrite(nH , CRLF )

While !eof()
	cSave := "Insert into ORGAO (ID,IDSUP,NOME) values ("
	cSave += IIF(empty(QRY->CODIGO),'0',QRY->CODIGO)
	cSave += ","+IIF(empty(QRY->CODSUP),'0',QRY->CODSUP)
	cSave += ",'" + _escape(Capital(alltrim(QRY->NOME)))+"'"
	cSave += ");" + CRLF
	fWrite(nH , cSave)
	DbSkip()
Enddo

fWrite(nH , 'commit;'+CRLF )
fWrite(nH , CRLF )

fWrite(nH ,'Create Index ORGAO1 ON ORGAO ( ID );'+CRLF)

fClose(nH)

USE

MsgInfo("Script orgao.sql criado")

return

static function _escape(cStr)
cStr := strtran(cStr,"'","''")
return cStr
