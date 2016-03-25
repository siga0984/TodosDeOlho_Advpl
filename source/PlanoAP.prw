#include "protheus.ch"

// Ultima linha importada ( aprox ) : 1182032

/*-------------------------------------------------------
THREAD ERROR ([15476], julio.wittwer, NOTE-AUTOMAN)   02/03/2016   14:54:56

 Stack :
Modalidade [Proposta/Plano de Trabalho em rascunho] nao encontrada on U_PLANOAP(
PLANOAP.PRW) 01/03/2016 23:34:30 line : 176

[build: 7.00.131227A-20160221]
[environment: stress]
[thread: 15476]
[dbthread: 20360]
[rpodb: top]
[localfiles: CTREE]
[remark: ]
[stack: 11520 bytes]
[memory: 15757208 bytes]
[peak memory: 15784120 bytes]
[threadtype: RmtSockThread]
-------------------------------------------------------*/

User Function PlanoAP()
Local nHTop
Local oTXTFile
Local cLine := ''
Local nLines := 0
Local nTimer
Local nMax := 0
Local nCols := 0
local nI
Local aStru := {}
Local cTmp
Local lInAspas
Local aMunic := {}

U_DBSetup()

varinfo("",tcInternal(30,"AUTORECNO"))

if tcgetDB() = "MYSQL"
	nErr := tcsqlexec("SET autocommit = 0;")
	IF nErr < 0 
		UserException(TcSqlError())
	Endif
Endif

nTimer := seconds()

oTXTFile := ZFWReadTXT():New("\convenios\21_PlanoAplicacaoPT.csv")

If !oTXTFile:Open()
	MsgStop(oTXTFile:GetErrorStr(),"OPEN ERROR")
	Return
Endif

aColunas := {}
oTXTFile:ReadLine(@cLine)
conout(cLine)

aColunas := strtokarr2(cLine,";")

//varinfo("aColunas",aColunas)

aModali := Load("MODALI")
aSituac := Load("SITUAC")   

varinfo("aModali",aModali)
varinfo("aSituac",aSituac)

If !tcCanopen("PLANOAP")
     
	aStru := {}
	aadd(aStru,{"ANOPROP"  ,"C",4,0})
	aadd(aStru,{"NRPROP"   ,"N",6,0})
	aadd(aStru,{"TXSITUAC" ,"C",2,0}) // situac
	aadd(aStru,{"TXMOD"    ,"C",2,0}) // Modali
	aadd(aStru,{"ANOCONV"  ,"C",4,0})
	aadd(aStru,{"NRCONV"   ,"N",6,0})
	aadd(aStru,{"ORGAO"    ,"C",5,0})
	aadd(aStru,{"NMORGAO"  ,"C",80,0})
	aadd(aStru,{"CIDPROP"  ,"C",14,0})
	aadd(aStru,{"NIDPROP"  ,"C",150,0})
	aadd(aStru,{"TIDPROP"  ,"C",4,0})
	aadd(aStru,{"ESFERA"   ,"C",50,0})
	aadd(aStru,{"MUNICIP"  ,"C",40,0})
	aadd(aStru,{"UFP"      ,"C",2,0})
	aadd(aStru,{"REGIAOP"  ,"C",15,0})
	aadd(aStru,{"TPDESP"   ,"C",30,0})
	aadd(aStru,{"NATAQUIS" ,"C",40,0})
	aadd(aStru,{"DESCRDES" ,"C",255,0})
	aadd(aStru,{"CODNATDES","C",8,0})
	aadd(aStru,{"NOMNATDES","C",50,0})
	aadd(aStru,{"QTDNATDES","C",50,0})
	aadd(aStru,{"VLUNIT"   ,"N",16,2})
	aadd(aStru,{"VLTOTAL"  ,"N",16,2})
	aadd(aStru,{"UNIDADEF" ,"C",150,0})
	aadd(aStru,{"ENDERECO" ,"C",255,0})
	aadd(aStru,{"MUNICIF"  ,"C",40,0})
	aadd(aStru,{"IDMUNICI" ,"C",4,0})
	aadd(aStru,{"UFD"      ,"C",2,0})
	aadd(aStru,{"CEP"      ,"C",9,0})
	aadd(aStru,{"SITDESP"  ,"C",20,0})
	aadd(aStru,{"IDCONVEN" ,"C",6,0})
	aadd(aStru,{"IDPROPOS" ,"C",7,0})

	DbCreate("PLANOAP",aStru,"TOPCONN")

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
	aadd(aMunic,{MUNICIPIO->CODIGO,alltrim(upper(MUNICIPIO->NOME)),MUNICIPIO->UF})
	DbSkip()
enddo

USE PLANOAP ALIAS PLANOAP SHARED NEW VIA "TOPCONN"

//varinfo("STRU",DbStruct())

For nI := 1 to len(aColunas)
	aColunas[nI] := { strtran(lower(aColunas[nI]),'"','') , 4096 , 0 }
Next

nCols := len(aColunas)
cTime := time()

While oTXTFile:ReadLine(@cLine)
	
	//conout(cLine)
	                    
	lInAspas := .f.
	aRecord := ParseLine(cLine,@lInAspas)

	while ( len(aRecord) < nCols )
		oTXTFile:ReadLine(@cLine)
		aNext := ParseLine(cLine,@lInAspas)
		if empty(aNext)
			LOOP
		Endif
		aRecord[len(aRecord)] += ( ' ' + aNext[1] )
		For nI := 2 to len(aNext) 
			aadd(aRecord,aNext[nI])
		Next
	Enddo
	                            
	if len(aRecord) <> nCols
		conout(hexstrdump(cLine))
		varinfo("",aRecord)
		conout("Linha: "+cValToChar(nLines))
		USerException("Formato inesperado")
	Endif
	
	nLines++          

	For nI := 1 to len(aRecord)
		
		cTmp := DecodeUtf8(adjustUtf(aRecord[nI]))
		If empty(cTmp)
			cTmp := NoUTF(aRecord[nI])
		Endif
		
		nSize := len(cTmp)
		if nSize < acolunas[ni][2]
			acolunas[ni][2] := nSize
		Endif
		if nSize > acolunas[ni][3]
			acolunas[ni][3] := nSize
		Endif
		
		if left(aColunas[nI][1],3)=='vl_'
			aRecord[nI]	:= GetReais(cTmp)
		Elseif nI == 2 .or. nI == 6
			aRecord[nI]	:= val(cTmp)
		Elseif left(aColunas[nI][1],3)=='qt_'
			aRecord[nI]	:= val(cTmp)
		Elseif left(aColunas[nI][1],3)=='dt_'
			aRecord[nI]	:= ctod(cTmp)
		Else
			aRecord[nI]	:= alltrim(Upper(cTmp))
		Endif


		if nI == 3
			// aadd(aStru,{"TXSITUAC" ,"C",2,0}) // situac
			nPos := ascan(aSituac,{|x| x[2] == aRecord[nI]})
			If nPos = 0
				UserException("Situacao ["+aRecord[nI]+"] nao encontrada")
			Endif
			aRecord[nI]	:= aSituac[nPos][1]
		ElseIf nI == 4
			// aadd(aStru,{"TXMOD"    ,"C",2,0}) // Modali
			nPos := ascan(aModali,{|x| x[2] == aRecord[nI]})
			If nPos = 0                                        
				conout("Modalidade ["+aRecord[nI]+"] nao encontrada")
				aRecord[nI]	:= '  '
			Else
				aRecord[nI]	:= aModali[nPos][1]
			Endif
		Endif

	Next

	cNomeMuni := aRecord[26]
	cCodMuni  := aRecord[27]
	cUFMuni   := aRecord[28]

	nPos := ascan( aMunic , {|x| x[1] == cCodMuni })
	
	If nPos == 0
		aadd(aMunic,{cCodMuni,cNomeMuni,cUFMuni})
		DbSelectArea("MUNICIPIO")
		dbappend()         
		conout("ADD Municipio ["+cCodMuni+"]["+cNomeMuni+"]["+cUfMuni+"]")
		fieldput(1,cCodMuni)
		Fieldput(2,cNomeMuni)
		Fieldput(3,cUFMuni)
		dbcommit()
		dbrunlock()
	Endif


	if time() <> cTime
		varinfo("",aRecord)
		conout(nLines)
		cTime := time()
	Endif                         
	                         
	dbselectarea("PLANOAP")
	dbappend()
	For nI := 1 to len(aRecord)
		Fieldput(nI,aRecord[nI])
	Next                    
	dbcommit()
	dbrunlock()
	
Enddo

//varinfo("aColunas",aColunas)

conout("Linhas : "+cValToChar(nLines))

oTXTFile:Close()

Return
                              


STATIC Function ParseLine(cline,lInAspas)
Local aRet := {}
Local nI , nT := len(cLine)
Local cTeco := ''
If pcount()<2
	lInAspas := .f.
Endif
For nI := 1 to nT
	cChar := substr(cLine,nI,1)
	If cChar == '"'
		lInAspas := !lInAspas
		LOOP
	Endif
	If lInAspas
		cTeco += cChar
	Else
		If cChar == ';'
			aadd(aRet , cTeco)
			cTeco := ''
		Else
			cTeco += cChar
		Endif
	Endif
Next
If !empty(cTeco)
	aadd(aRet,cTeco)
Endif

Return aRet

STATIC Function NoUTF(cStr)
Local cRet := ''
Local nI , nChar
For nI := 1 to len(cStr)
	nChar := asc(substr(cStr,nI,1))
	If nChar >= 32 .and. nChar < 128
		cRet += chr(nChar)
	Endif
Next
Return cRet

STATIC Function adjustUtf(cStr)

// c2 96 –	START OF GUARDED AREA (U+0096)
cStr := strtran(cStr , chr(194) + chr(150) , '-')

// Bug Codes 82/83 - c2/c3
cStr := strtran(cStr , chr(131)+chr(194) , '')
cStr := strtran(cStr , chr(131)+chr(195) , '')
cStr := strtran(cStr , chr(130)+chr(194) , '')
cStr := strtran(cStr , chr(130)+chr(195) , '')

/*
-------------------------------------------------------------------------------
53 65 63 72 65 74 61 72 69 6F 20 64 65 20 50 6C  | Secretario de Pl
61 6E 65 6A 61 6D 65 6E 74 6F 20 65 20 44 65 73  | anejamento e Des
65 6E 76 6F 6C 76 69 6D 65 6E 74 6F 20 45 6E 65  | envolvimento Ene
72 67 C3 83 C2 83 C3 82 C2 83 C3 83 C2 82 C3 82  | rg+â-â+é-â+â-é+é
C2 A9 74 69 63 6F                                | -®tico
-------------------------------------------------------------------------------*/


// c2 95 •	MESSAGE WAITING (U+0095)
cStr := strtran(cStr , chr(194) + chr(149) , '*')

// ’	PRIVATE USE TWO (U+0092)	c292
cStr := strtran(cStr , chr(194) + chr(146) , "'")

// ’	PRIVATE USE ONE (U+0091)	c291
cStr := strtran(cStr , chr(194) + chr(145) , "'")

Return cStr


STATIC Function GetReais(cStr)
cStr := strtran(cStr,"R$ ",'')
cStr := strtran(cStr,".",'')
cStr := strtran(cStr,",",'.')
Return val(cStr)




/*
aColunas -> ARRAY (   32) [...]
     aColunas[1] -> ARRAY (    3) [...]
          aColunas[1][1] -> C (   12) [ano_proposta]
          aColunas[1][2] -> N (   15) [         4.0000]
          aColunas[1][3] -> N (   15) [         4.0000]
     aColunas[2] -> ARRAY (    3) [...]
          aColunas[2][1] -> C (   11) [nr_proposta]
          aColunas[2][2] -> N (   15) [         1.0000]
          aColunas[2][3] -> N (   15) [         6.0000]
     aColunas[3] -> ARRAY (    3) [...]
          aColunas[3][1] -> C (   19) [tx_situacaoproposta]
          aColunas[3][2] -> N (   15) [         0.0000]
          aColunas[3][3] -> N (   15) [        72.0000]
     aColunas[4] -> ARRAY (    3) [...]
          aColunas[4][1] -> C (   13) [tx_modalidade]
          aColunas[4][2] -> N (   15) [         0.0000]
          aColunas[4][3] -> N (   15) [        31.0000]
     aColunas[5] -> ARRAY (    3) [...]
          aColunas[5][1] -> C (   12) [ano_convenio]
          aColunas[5][2] -> N (   15) [         0.0000]
          aColunas[5][3] -> N (   15) [         4.0000]
     aColunas[6] -> ARRAY (    3) [...]
          aColunas[6][1] -> C (   11) [nr_convenio]
          aColunas[6][2] -> N (   15) [         0.0000]
          aColunas[6][3] -> N (   15) [         6.0000]
     aColunas[7] -> ARRAY (    3) [...]
          aColunas[7][1] -> C (   19) [cd_orgao_concedente]
          aColunas[7][2] -> N (   15) [         5.0000]
          aColunas[7][3] -> N (   15) [         5.0000]
     aColunas[8] -> ARRAY (    3) [...]
          aColunas[8][1] -> C (   19) [nm_orgao_concedente]
          aColunas[8][2] -> N (   15) [        17.0000]
          aColunas[8][3] -> N (   15) [        66.0000]
     aColunas[9] -> ARRAY (    3) [...]
          aColunas[9][1] -> C (   19) [cd_ident_proponente]
          aColunas[9][2] -> N (   15) [        14.0000]
          aColunas[9][3] -> N (   15) [        14.0000]
     aColunas[10] -> ARRAY (    3) [...]
          aColunas[10][1] -> C (   19) [nm_ident_proponente]
          aColunas[10][2] -> N (   15) [         4.0000]
          aColunas[10][3] -> N (   15) [       150.0000]
     aColunas[11] -> ARRAY (    3) [...]
          aColunas[11][1] -> C (   19) [tp_ident_proponente]
          aColunas[11][2] -> N (   15) [         4.0000]
          aColunas[11][3] -> N (   15) [         4.0000]
     aColunas[12] -> ARRAY (    3) [...]
          aColunas[12][1] -> C (   24) [tx_esfera_adm_proponente]
          aColunas[12][2] -> N (   15) [         7.0000]
          aColunas[12][3] -> N (   15) [        40.0000]
     aColunas[13] -> ARRAY (    3) [...]
          aColunas[13][1] -> C (   23) [nm_municipio_proponente]
          aColunas[13][2] -> N (   15) [         0.0000]
          aColunas[13][3] -> N (   15) [        32.0000]
     aColunas[14] -> ARRAY (    3) [...]
          aColunas[14][1] -> C (   13) [uf_proponente]
          aColunas[14][2] -> N (   15) [         0.0000]
          aColunas[14][3] -> N (   15) [         2.0000]
     aColunas[15] -> ARRAY (    3) [...]
          aColunas[15][1] -> C (   20) [tx_regiao_proponente]
          aColunas[15][2] -> N (   15) [         0.0000]
          aColunas[15][3] -> N (   15) [        12.0000]
     aColunas[16] -> ARRAY (    3) [...]
          aColunas[16][1] -> C (   10) [tp_despesa]
          aColunas[16][2] -> N (   15) [         3.0000]
          aColunas[16][3] -> N (   15) [        22.0000]
     aColunas[17] -> ARRAY (    3) [...]
          aColunas[17][1] -> C (   20) [tx_naturezaaquisicao]
          aColunas[17][2] -> N (   15) [         0.0000]
          aColunas[17][3] -> N (   15) [        29.0000]
     aColunas[18] -> ARRAY (    3) [...]
          aColunas[18][1] -> C (   19) [tx_descricaodespesa]
          aColunas[18][2] -> N (   15) [         1.0000]
          aColunas[18][3] -> N (   15) [       255.0000]
     aColunas[19] -> ARRAY (    3) [...]
          aColunas[19][1] -> C (   18) [cd_naturezadespesa]
          aColunas[19][2] -> N (   15) [         0.0000]
          aColunas[19][3] -> N (   15) [         8.0000]
     aColunas[20] -> ARRAY (    3) [...]
          aColunas[20][1] -> C (   18) [nm_naturezadespesa]
          aColunas[20][2] -> N (   15) [         0.0000]
          aColunas[20][3] -> N (   15) [        45.0000]
     aColunas[21] -> ARRAY (    3) [...]
          aColunas[21][1] -> C (   18) [qd_naturezadespesa]
          aColunas[21][2] -> N (   15) [         0.0000]
          aColunas[21][3] -> N (   15) [        17.0000]
     aColunas[22] -> ARRAY (    3) [...]
          aColunas[22][1] -> C (   11) [vl_unitario]
          aColunas[22][2] -> N (   15) [         2.0000]
          aColunas[22][3] -> N (   15) [        22.0000]
     aColunas[23] -> ARRAY (    3) [...]
          aColunas[23][1] -> C (    8) [vl_total]
          aColunas[23][2] -> N (   15) [         2.0000]
          aColunas[23][3] -> N (   15) [        22.0000]
     aColunas[24] -> ARRAY (    3) [...]
          aColunas[24][1] -> C (   22) [tx_unidadefornecimento]
          aColunas[24][2] -> N (   15) [         0.0000]
          aColunas[24][3] -> N (   15) [       150.0000]
     aColunas[25] -> ARRAY (    3) [...]
          aColunas[25][1] -> C (   11) [tx_endereco]
          aColunas[25][2] -> N (   15) [         0.0000]
          aColunas[25][3] -> N (   15) [       255.0000]
     aColunas[26] -> ARRAY (    3) [...]
          aColunas[26][1] -> C (   12) [tx_municipio]
          aColunas[26][2] -> N (   15) [         0.0000]
          aColunas[26][3] -> N (   15) [        32.0000]
     aColunas[27] -> ARRAY (    3) [...]
          aColunas[27][1] -> C (   12) [cd_municipio]
          aColunas[27][2] -> N (   15) [         0.0000]
          aColunas[27][3] -> N (   15) [         4.0000]
     aColunas[28] -> ARRAY (    3) [...]
          aColunas[28][1] -> C (   10) [uf_despesa]
          aColunas[28][2] -> N (   15) [         0.0000]
          aColunas[28][3] -> N (   15) [         2.0000]
     aColunas[29] -> ARRAY (    3) [...]
          aColunas[29][1] -> C (    6) [nr_cep]
          aColunas[29][2] -> N (   15) [         0.0000]
          aColunas[29][3] -> N (   15) [         9.0000]
     aColunas[30] -> ARRAY (    3) [...]
          aColunas[30][1] -> C (   18) [tx_situacaodespesa]
          aColunas[30][2] -> N (   15) [         0.0000]
          aColunas[30][3] -> N (   15) [        17.0000]
     aColunas[31] -> ARRAY (    3) [...]
          aColunas[31][1] -> C (   11) [id_convenio]
          aColunas[31][2] -> N (   15) [         0.0000]
          aColunas[31][3] -> N (   15) [         6.0000]
     aColunas[32] -> ARRAY (    3) [...]
          aColunas[32][1] -> C (   11) [id_proposta]
          aColunas[32][2] -> N (   15) [         4.0000]
          aColunas[32][3] -> N (   15) [         7.0000]

Linhas : 3101414

*/

// Carga de arquivo Chave-Valor em Array bi-dimensional 

STATIC Function Load(cFile)
Local aRet := {}

USE (cFile) ALIAS (cFile) SHARED NEW VIA "TOPPCONN"

While !eof()
	aadd(aRet,{ fieldget(1) , alltrim(upper(fieldget(2))) })
	DbSkip()
Enddo

Return aRet
