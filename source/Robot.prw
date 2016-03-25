#include 'protheus.ch'

USer Function Robot()
Local nH
Local nI
Local cUrl

Nh := fCreate("\sitemap.txt")

cUrl := 'http://siga0984.no-ip.org:7000/'

fWrite(Nh,cUrl+"u_siconvuf.apw"+chr(10))
fWrite(Nh,cUrl+"U_SicHelp.apw"+chr(10))


u_DBSetup()

cQuery := "select distinct UF "
cQuery += "from convenioaux.dbo.MUNICIP  "
cQuery += "order by UF"

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA 'TOPCONN'

While !eof()
	If !empty(QRY->UF)
		fWrite(Nh,cUrl+"u_siconvmun.apw?UF="+QRY->UF+chr(10))
	Endif
	DbSkip()
Enddo

USE

aMun := {}

cQuery := "select * "
cQuery += "from convenioaux.dbo.MUNICIP  "

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA 'TOPCONN'

While !eof()
	If !empty(QRY->CODIGO)
		fWrite(Nh,cUrl+"u_siconv02.apw?MUN="+alltrim(QRY->CODIGO)+chr(10))
		aadd(aMun,{alltrim(QRY->CODIGO),alltrim(QRY->NOME),QRY->UF})
	Endif
	DbSkip()
Enddo

USE

For nI := 1 to len(aMun)
	
	cQuery := "select CDORGCCD from PROSPGM "
	cQuery += " where UFPPN = '"+aMun[nI][3]+"' "
	cQuery += " and NMMUNPPN = '"+escape(aMun[nI][2])+"' "
	cQuery += " group by CDORGCCD "
	cQuery += " order by 1"
	
	USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA 'TOPCONN'
	
	While !eof()
		If !empty(QRY->CDORGCCD)
			fWrite(Nh,cUrl+"u_siconv03.apw?MUN="+aMun[nI][1]+"&CCD="+QRY->CDORGCCD+"&PAGE=1"+chr(10))
		Endif
		DbSkip()
	Enddo
	
	USE
	
Next

fClose(nH)

MsgInfo("sitemap criado")

Return

static function escape(cStr)
cStr := strtran(cStr,"'","''")
return cStr

