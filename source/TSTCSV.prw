#include "protheus.ch"


User Function TSTCSV()

Local nH , nI , nF

U_DBSetup()

aFiles := directory("C:\Projects\Corrupcao MJ\Convenios\*.csv")

For nF := 1 to len(aFiles)
	
	cFile := aFiles[nF][1]
	
	conout('Analizing ['+cFile+']')
	
	cQuery := 'select * from ['+cFile+']'
	
	USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"
	
	aStru := dbstruct()
	
	aMinMax := {}
	
	nRecs := 0
	
	for nI := 1 to len(aStru)
		cCpo := NoUTF(alltrim(cValtoChar(fieldget(nI))))
		aadd(aMinMax,{len(cCpo),len(cCpo)})
	Next
	
	While !eof()
		for nI := 1 to len(aStru)
			cCpo := NoUTF(alltrim(cValtoChar(fieldget(nI))))
			nTam := len(cCpo)
			If nTam < aMinMax[nI][1]
				aMinMax[nI][1] := nTam
			Endif
			If nTam > aMinMax[nI][2]
				aMinMax[nI][2] := nTam
			Endif
		Next
		nRecs++
		DbSkip()
	Enddo
	
	for nI := 1 to len(aStru)
		conout(aStru[nI][1]+' Min = '+cValTochar(aMinMax[nI][1])+' Max = '+cValTochar(aMinMax[nI][2]))
	Next
	conout("File ["+cFile+"] has "+cValToChar(nRecs)+' record(s)')
	
	USE
	
Next

return


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




// Monta o indice de merda de arquivos para download

User Function Merda()
Local cSave := ''
nh := fopen('\merda.txt')
cBuffer := ''
fread(NH,cBuffer,32768)
fclose(nH)

While .t.

	nPos1 := at('<a href="',cBuffer)
	If nPos1 > 0
		cBuffer := substr(cBuffer,nPos1+9)
		nPos2 := at('">',cBuffer)
		cSave += left(cBuffer,nPos2-1) + CRLF
		cBuffer := substr(cBuffer,nPos2+1)
		LOOP
	Endif

	EXIT
		
enddo

memowrit('\indice.txt',cSave)

Return                


