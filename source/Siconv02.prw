
/*

Lista as Propostas feitas por proponentes deste municipo
que se tornaram convenios
*/

#include 'protheus.ch'
#include 'apwebex.ch'


User Function Siconv02()

Local cHTML := ''
Local cQuery := ''
Local nI , nJ , aRow

PRIVATE cMunID := httpget->mun
PRIVATE cMunic := ''
PRIVATE cUF := ''

WEB EXTENDED INIT cHTML

U_DBSetup()

U_LogSite()

PRIVATE aData := {}

If !U_MunByID(cMunID,@cMunic,@cUF)
	            
	PRIVATE cErrorMSG := "Municipio ["+cMunID+"] n�o encontrado"
	PRIVATE cErrorHLP := 'A busca por conv�nios n�o recebeu corretamente o munic�po a ser pesquisado. '+;
											 'Retorne para a tela anterior e tente novamente, ou volte ao in�cio do site.'

	cHtml := h_SicError()
	
Else
	
	// Total de propostas realizadas
	
	cQuery := "select CDORGCCD , NMORGCCD , "
	cQuery += "round(sum(VL_GLOBAL)/1000000,2) AS GLOBAL, "
	cQuery += "round(sum(VL_REPASSE)/1000000,2) AS REPASSE, "
	cQuery += "round(sum(VLCPTD)/1000000,2) AS CONTRAP, "
	cQuery += "count(*) as QTD from PROSPGM "
	cQuery += "where UFPPN = '"+cUf+"' "
	cQuery += "and NMMUNPPN = '"+_escape(cMunic)+"' "
	cQuery += "group by CDORGCCD , NMORGCCD "
	cQuery += "order by 3 desc"
	
	// conout(cQuery)
	
	USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"
	
	While !eof()
		aRow := {}
		aadd(aRow , QRY->CDORGCCD) // Codigo do Orgao
		aadd(aRow , QRY->NMORGCCD) // Nome do Orgao Concedente
		aadd(aRow , QRY->QTD ) // total de propostas
		aadd(aRow , QRY->GLOBAL ) // valor total em milhoes
		aadd(aRow , 0 ) // total de convenios
		aadd(aRow , 0 ) // valor total em milhoes
		aadd(aData,aRow)
		DbSkip()
	Enddo
	
	USE
	
	
	cQuery := "select CDORGCCD , NMORGCCD , "
	cQuery += "round(sum(VL_GLOBAL)/1000000,2) AS GLOBAL, "
	cQuery += "round(sum(VL_REPASSE)/1000000,2) AS REPASSE, "
	cQuery += "round(sum(VLCPTD)/1000000,2) AS CONTRAP, "
	cQuery += "count(*) as QTD from PROSPGM "
	cQuery += "where UFPPN = '"+cUf+"' "
	cQuery += "and NMMUNPPN = '"+_escape(cMunic)+"' "
	cQuery += "and IDCNV != ' ' "
	cQuery += "group by CDORGCCD , NMORGCCD "
	cQuery += "order by 1"
	
	// conout(cQuery)
	
	USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"
	
	While !eof()
		
		cCodCCD := QRY->CDORGCCD
		nPos := ascan( aData , {|x| x[1] == cCodCCD })
		If nPos == 0
			aRow := {}
			aadd(aRow , QRY->CDORGCCD) // Codigo do Orgao
			aadd(aRow , QRY->NMORGCCD) // Nome do Orgao Concedente
			aadd(aRow , 0 ) // total de propostas
			aadd(aRow , 0 ) // valor total em milhoes propostos
			aadd(aRow , 0 ) // total de convenios
			aadd(aRow , 0 ) // valor total em milhoes conveniados
			aadd(aData,aRow)
			nPos := len(aData)
		Endif
		
		aData[npos][5] := QRY->QTD
		aData[nPos][6] := QRY->GLOBAL
		
		DbSkip()
		
	Enddo
	
	USE
	
	// Ordenado pelos maiores valores investidos
	aSort(aData,,,{|x1,x2| x2[6] < x1[6]  })
	
	cHTML := H_SICONV02()
	
Endif

WEB EXTENDED END

Return cHTML

static function _escape(cStr)
cStr := strtran(cStr,"'","''")
return cStr

