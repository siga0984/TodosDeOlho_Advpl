#include "protheus.ch"

STATIC _FASE := 2 // 1 = Analizar e recriar tabelas 2 = Popular

User Function LECSV()
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
Local nF

SET DATE BRITISH
SET CENTURY ON

nHTop := tclink('mssql/convenioaux','localhost',7890)
varinfo("nHTop",nHTop)

nTimer := seconds()

aFiles := directory("C:\Projects\Corrupcao MJ\Convenios\??_*.csv")

For nF := 1 to len(aFiles)
	
	cFile := aFiles[nF][1]
	
	conout('===> Avaliando arquivo ['+cFile+']')
	
	cTabela := upper(filenoext(cFile))
	while left(cTabela,1) <= 'A' .or. left(cTabela,1) >= 'Z'
		cTabela := substr(cTabela,2)
	Enddo
	cTabela := reduz(cTabela)
	cTabela := left(cTabela,10)
	
	conout('===> Avaliando tabela ['+cTabela+']')

	tcrefresh(cTabela)
	If _FASE == 1
		if tccanopen(cTabela)
			// Ja existe, ignora 
			conout("Tabela ja existe ... ")
			LOOP
		Endif
	ElseIf _FASE == 2    
		if !tccanopen(cTabela)
			conout("Nao existe ... ignorando")
		Endif
		// abre e importa !!! 
		USE (cTabela) ALIAS TMP EXCLUSIVE NEW VIA "TOPCONN"
		If lastrec() > 0    
			conout("Tabela ja tem dados ... Ignorada.")
			USE
			LOOP
		Endif
	Endif
	
	oTXTFile := ZFWReadTXT():New("\convenios\"+cFile)
	nLines := 0
	
	If !oTXTFile:Open()
		MsgStop(oTXTFile:GetErrorStr(),"OPEN ERROR")
		Return
	Endif
	
	aColunas := {}
	oTXTFile:ReadLine(@cLine)
	conout(cLine)
	
	aColunas := strtokarr2(cLine,";")
	
	//	varinfo("aColunas",aColunas)
	
	For nI := 1 to len(aColunas)
		aColunas[nI] := { strtran(lower(aColunas[nI]),'"','') , 4096 , 0 }
	Next
	
	nCols := len(aColunas)
	cTime := time()
	
	conout("==> Colunas = "+cValToChar(nCols))
	
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
			If empty(cTmp).and. !empty(aRecord[nI])
				//conout(hexstrdump(alltrim(aRecord[nI])))
				// Remove o UTF e foda-se
				cTmp := NoUTF(aRecord[nI])
			Endif
			
			if left(aColunas[nI][1],3)=='vl_'
				aRecord[nI]	:= GetReais(cTmp)
				nSize := 18
			Elseif left(aColunas[nI][1],3)=='dt_'
				aRecord[nI]	:= ctod(cTmp)
				nSize := 8
			Else
				aRecord[nI]	:= alltrim(Upper(cTmp))
				nSize := len(aRecord[nI])
			Endif
			
			if nSize < acolunas[ni][2]
				acolunas[ni][2] := nSize
			Endif
			if nSize > acolunas[ni][3]
				acolunas[ni][3] := nSize
			Endif
			
		Next
		
		IF _FASE == 2
			DBAppend(.t.)
			For nI := 1 to len(aRecord)
				///varinfo(fieldname(ni),aRecord[ni])
				Fieldput(nI,aRecord[nI])
			Next
			DBCOmmit()
		Endif

/*
		if time() <> cTime
			conout("["+time()+"] Linha ("+cValToChar(nLines)+")")
			varinfo("",aRecord)
			cTime := time()
		Endif
*/
		
		
	Enddo
	
	varinfo("aColunas",aColunas)
	
	conout("Linhas : "+cValToChar(nLines))
	
	oTXTFile:Close()

	USE
	
	IF _FASE == 1
		
		aStru := {}
		For nI := 1 to len(aRecord)
			
			cColuna := upper(aColunas[nI][1])
			cColuna := Reduz(cColuna)
			cColuna := left(cColuna,10)
			
			if left(aColunas[nI][1],3)=='vl_'
				cTipo := 'N'
				nSize := 18
				nDec := 2
			Elseif left(aColunas[nI][1],3)=='dt_'
				cTipo := 'D'
				nSize := 8
				nDec := 0
			Else
				cTipo := 'C'
				nSize := acolunas[ni][3]
				If nSize == 0
					conout('Coluna ['+cColuna+'] VAZIA')
					nSize := 1
				Endif
				nDec := 0
			Endif
			
			aadd(aStru,{cColuna,cTipo,nSize,nDec})
			
		Next
		
		varinfo("aStru",aStru)
		dbcreate(cTabela,aStru,"TOPCONN")
		
	Endif
	
Next

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
		if !(cChar$chr(13)+chr(10))
			// se esta entre aspas ignora quebra de linha
			cTeco += cChar
		Endif
	Else
		If cChar == ';'
			aadd(aRet , cTeco)
			cTeco := ''
		Else
			cTeco += cChar
		Endif
	Endif
Next
If !empty(cTeco) .or. cChar==';'
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

static function reduz(cRet)
Local nI

If len(cRet) <= 10
	Return cRet
Endif

cRet := strtran(cRet,"RESP_CONCEDENTE","RCCD")
cRet := strtran(cRet,"RESP_PROPONENTE","RPPN")
cRet := strtran(cRet,"CONTA_CORRENTE","CC")

cRet := strtran(cRet,"CONTRAPARTIDA","CPTD")
cRet := strtran(cRet,"DESEMBOLSADO" ,"DES")
cRet := strtran(cRet,'PROPONENTE'   ,'PPN')
cRet := strtran(cRet,"FAVORECIDO"   ,"FVR")
cRet := strtran(cRet,'MODALIDADE'   ,'MOD')
cRet := strtran(cRet,'CONCEDENTE'   ,'CCD')
cRet := strtran(cRet,"PUBLICACAO"   ,"PUB")
cRet := strtran(cRet,"ASSINATURA"   ,"ASS")
cRet := strtran(cRet,"MUNICIPIO"    ,"MUN")
cRet := strtran(cRet,"SUPERIOR"     ,"SUP")
cRet := strtran(cRet,'CONVENIO'     ,'CNV')
cRet := strtran(cRet,'PROPOSTA'     ,'PRO')
cRet := strtran(cRet,'SITUACAO'     ,'SIT')
cRet := strtran(cRet,"PROGRAMA"     ,"PGM")
cRet := strtran(cRet,"INCLUSAO"     ,"INC")
cRet := strtran(cRet,"QUALIFIC"     ,"QLF")
cRet := strtran(cRet,"ENDERECO"     ,"END")
cRet := strtran(cRet,"VIGENCIA"     ,"VIG")
cRet := strtran(cRet,"EMPENHO"      ,"EPH")
cRet := strtran(cRet,"REPASSE"      ,"REP")
cRet := strtran(cRet,"IDENTIF"      ,"ID")
cRet := strtran(cRet,"RESPONS"      ,"RPN")
cRet := strtran(cRet,"ESFERA"       ,"ESF")
cRet := strtran(cRet,"ORGEXP"       ,"OE")
cRet := strtran(cRet,"REGIAO"       ,"REG")
cRet := strtran(cRet,"INICIO"       ,"INI")
cRet := strtran(cRet,"BAIRRO"       ,"BAI")
cRet := strtran(cRet,"OFICIO"       ,"OFI")
cRet := strtran(cRet,"CARGO"        ,"CAR")
cRet := strtran(cRet,'ORGAO'        ,'ORG')
cRet := strtran(cRet,"ACAO"         ,"ACT")
cRet := strtran(cRet,'_','')

Return cRet

