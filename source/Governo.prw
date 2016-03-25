
User Function Convenio()
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

U_DBSetup()

varinfo("",tcInternal(30,"AUTORECNO"))

if tcgetDB() = "MYSQL"
	nErr := tcsqlexec("SET autocommit = 0;")
	IF nErr < 0 
		UserException(TcSqlError())
	Endif
Endif


aModali := {}    // 5
aSituac := {}    // 6
aSubSit := {}    // 7
aEsfera := {}    // 11
aRegiao := {}    // 12
aSitPub := {}    // 50
aQualif := {}    // 62
aOrgaos := {}

If !TcCanOpen("MODALI")
	aStru := {}
	aadd(aStru,{"CODIGO"  ,"C",2,0})
	aadd(aStru,{"DESCRIC" ,"C",40,0})
	DbCreate("MODALI",aStru,"TOPCONN")
Endif

If !TcCanOpen("SITUAC")
	aStru := {}
	aadd(aStru,{"CODIGO"  ,"C",2,0})
	aadd(aStru,{"DESCRIC" ,"C",100,0})
	DbCreate("SITUAC",aStru,"TOPCONN")
Endif

If !TcCanOpen("SUBSIT")
	aStru := {}
	aadd(aStru,{"CODIGO"  ,"C",2,0})
	aadd(aStru,{"DESCRIC" ,"C",40,0})
	DbCreate("SUBSIT",aStru,"TOPCONN")
Endif

If !TcCanOpen("ESFERA")
	aStru := {}
	aadd(aStru,{"CODIGO"  ,"C",2,0})
	aadd(aStru,{"DESCRIC" ,"C",40,0})
	DbCreate("ESFERA",aStru,"TOPCONN")
Endif

If !TcCanOpen("REGIAO")
	aStru := {}
	aadd(aStru,{"CODIGO"  ,"C",2,0})
	aadd(aStru,{"DESCRIC" ,"C",15,0})
	DbCreate("REGIAO",aStru,"TOPCONN")
Endif

If !TcCanOpen("SITPUB")
	aStru := {}
	aadd(aStru,{"CODIGO"  ,"C",2,0})
	aadd(aStru,{"DESCRIC" ,"C",40,0})
	DbCreate("SITPUB",aStru,"TOPCONN")
Endif

If !TcCanOpen("QUALIF")
	aStru := {}
	aadd(aStru,{"CODIGO"  ,"C",2,0})
	aadd(aStru,{"DESCRIC" ,"C",40,0})
	DbCreate("QUALIF",aStru,"TOPCONN")
Endif

If !TcCanOpen("CONVENIOS")
	
	aStru := {}
	aadd(aStru,{"ANOCONV"  ,"C",4,0})
	aadd(aStru,{"NCONV"    ,"C",6,0})
	aadd(aStru,{"ANOPROP"  ,"C",4,0})
	aadd(aStru,{"NRPROP"   ,"N",6,0})
	aadd(aStru,{"TXMOD"    ,"C",2,0}) // Modali
	aadd(aStru,{"TXSITUAC" ,"C",2,0}) // situac
	aadd(aStru,{"TXSUBSIT" ,"C",2,0}) // Subsit
	aadd(aStru,{"ORGSUP"   ,"C",5,0})
	aadd(aStru,{"NORGSUP"  ,"C",50,0})
	aadd(aStru,{"ORGCONCED","C",5,0})
	aadd(aStru,{"ESFERAP"  ,"C",2,0}) // Esfera
	aadd(aStru,{"REGIAOP"  ,"C",12,0}) // Regiao
	aadd(aStru,{"UFP"      ,"C",2,0})
	aadd(aStru,{"NMUNICP"  ,"C",40,0})
	aadd(aStru,{"CODIDP"   ,"C",14,0})
	aadd(aStru,{"NPROP"    ,"C",150,0})
	aadd(aStru,{"NORGCD"   ,"C",70,0})
	aadd(aStru,{"DTINCP"   ,"D",8,0})
	aadd(aStru,{"CODPROG"  ,"C",13,0})
	aadd(aStru,{"NPROG"    ,"C",250,0})
	aadd(aStru,{"ACAOPPA"  ,"C",8,0})
	aadd(aStru,{"DTINIV"   ,"D",8,0})
	aadd(aStru,{"DTFIMV"   ,"D",8,0})
	aadd(aStru,{"DTASSIN"  ,"D",8,0})
	aadd(aStru,{"MESASSIN" ,"C",2,0})
	aadd(aStru,{"ANOASSIN" ,"C",4,0})
	aadd(aStru,{"MESPUBC"  ,"C",2,0})
	aadd(aStru,{"ANOPUBC"  ,"C",4,0})
	aadd(aStru,{"DTPUB"    ,"D",8,0})
	aadd(aStru,{"DTULTEMP" ,"D",8,0})
	aadd(aStru,{"DTULTPG"  ,"D",8,0})
	aadd(aStru,{"VLGLOBAL" ,"N",16,2})
	aadd(aStru,{"VLREPASSE","N",16,2})
	aadd(aStru,{"VLCNTPTOT","N",16,2})
	aadd(aStru,{"VLCNTPFIN","N",16,2})
	aadd(aStru,{"VLCNTPBS" ,"N",16,2})
	aadd(aStru,{"VLDESEMB" ,"N",16,2})
	aadd(aStru,{"VLEMPENH" ,"N",16,2})
	aadd(aStru,{"OBJCONV"  ,"C",255,0})
	aadd(aStru,{"JUSTIFIC" ,"C",255,0})
	aadd(aStru,{"ENDERP"   ,"C",255,0})
	aadd(aStru,{"BAIRROP"  ,"C",45,0})
	aadd(aStru,{"CEPP"     ,"C",9,0})
	aadd(aStru,{"RESPONSP" ,"C",60,0})
	aadd(aStru,{"CODRP"    ,"C",11,0}) // CPF
	aadd(aStru,{"CARGORP"  ,"C",128,0})
	aadd(aStru,{"RESPCCD"  ,"C",60,0})
	aadd(aStru,{"CRESPCCD" ,"C",11,0}) // CPF
	aadd(aStru,{"CARGOCCD" ,"C",128,0})
	aadd(aStru,{"SITPUBLIC","C",2,0}) // SitPub
	aadd(aStru,{"NPROCCNV" ,"C",25,0})
	aadd(aStru,{"NINTCNV"  ,"C",11,0})
	aadd(aStru,{"ASSINADO" ,"C",1,0})
	aadd(aStru,{"ADITIVO"  ,"C",1,0})
	aadd(aStru,{"PUBLICADO","C",1,0})
	aadd(aStru,{"EMPENHADO","C",1,0})
	aadd(aStru,{"PRORROGOF","C",1,0})
	aadd(aStru,{"PERMAJUST","C",1,0})
	aadd(aStru,{"NEMPENHOS","N",4,0})
	aadd(aStru,{"NADITIVOS","N",4,0})
	aadd(aStru,{"NPRORROGS","N",4,0})
	aadd(aStru,{"QUALIFICP","C",2,0}) // Qualif
	aadd(aStru,{"IDCONV"   ,"C",6,0})
	aadd(aStru,{"IDPROP"   ,"C",7,0})
	aadd(aStru,{"IDPROPPGM","C",6,0})
	
	DbCreate("CONVENIOS",aStru,"TOPCONN")
	
Endif

If !TcCanOpen("ORGAOS")
	aStru := {}
	aadd(aStru,{"ID"      ,"C",5,0})
	aadd(aStru,{"NOME"    ,"C",80,0})
	aadd(aStru,{"IDSUP"   ,"C",5,0})
	DbCreate("ORGAOS",aStru,"TOPCONN")
Endif

If !MsgYesNo("Importar Dados ?")
	Return
Endif

USE Modali ALIAS Modali SHARED NEW VIA "TOPCONN"
USE Situac ALIAS Situac SHARED NEW VIA "TOPCONN"
USE SubSit ALIAS SubSit SHARED NEW VIA "TOPCONN"
USE Esfera ALIAS Esfera SHARED NEW VIA "TOPCONN"
USE Regiao ALIAS Regiao SHARED NEW VIA "TOPCONN"
USE SitPub ALIAS SitPub SHARED NEW VIA "TOPCONN"
USE Qualif ALIAS Qualif SHARED NEW VIA "TOPCONN"
USE Orgaos ALIAS Orgaos SHARED NEW VIA "TOPCONN"

USE CONVENIOS ALIAS CONVENIOS SHARED NEW VIA "TOPCONN"

nTimer := seconds()

oTXTFile := ZFWReadTXT():New("\convenios\01_ConveniosProgramas.csv")

If !oTXTFile:Open()
	MsgStop(oTXTFile:GetErrorStr(),"OPEN ERROR")
	Return
Endif

aColunas := {}
oTXTFile:ReadLine(@cLine)
conout(cLine)

aColunas := strtokarr2(cLine,";")

For nI := 1 to len(aColunas)
	aColunas[nI] := { strtran(lower(aColunas[nI]),'"','') , 4096 , 0 }
Next

nCols := len(aColunas)
cTime := time()

While oTXTFile:ReadLine(@cLine)
	
	//conout(cLine)
	
	aRecord := ParseLine(cLine)
	
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
		Elseif left(aColunas[nI][1],3)=='qt_'
			aRecord[nI]	:= val(cTmp)
		Elseif nI == 4
			aRecord[nI]	:= val(cTmp)
		Elseif left(aColunas[nI][1],3)=='dt_'
			aRecord[nI]	:= ctod(cTmp)
		Else
			aRecord[nI]	:= Upper(cTmp)
		Endif
		
		If nI == 5
			if (nPos := ascan(aModali,cTmp)) == 0
				aadd(aModali,cTmp)
				nPos := len(aModali)
			Endif
			aRecord[nI]	:= strzero(nPos,2)
		ElseIf nI == 6
			if (nPos := ascan(aSituac,cTmp)) == 0
				aadd(aSituac,cTmp)
				nPos := len(aSituac)
			Endif
			aRecord[nI]	:= strzero(nPos,2)
		ElseIf nI == 7
			if (nPos := ascan(aSubSit,cTmp)) == 0
				aadd(aSubSit,cTmp)
				nPos := len(aSubSit)
			Endif
			aRecord[nI]	:= strzero(nPos,2)
		ElseIf nI == 11
			if (nPos := ascan(aEsfera,cTmp)) == 0
				aadd(aEsfera,cTmp)
				nPos := len(aEsfera)
			Endif
			aRecord[nI]	:= strzero(nPos,2)
		ElseIf nI == 12
			if (nPos := ascan(aRegiao,cTmp)) == 0
				aadd(aRegiao,cTmp)
				nPos := len(aRegiao)
			Endif
			aRecord[nI]	:= strzero(nPos,2)
		ElseIf nI == 50
			if (nPos := ascan(aSitPub,cTmp)) == 0
				aadd(aSitPub,cTmp)
				nPos := len(aSitPub)
			Endif
			aRecord[nI]	:= strzero(nPos,2)
		ElseIf nI == 62
			if (nPos := ascan(aQualif,cTmp)) == 0
				aadd(aQualif,cTmp)
				nPos := len(aQualif)
			Endif
			aRecord[nI]	:= strzero(nPos,2)
		Endif
		
	Next

	if ascan(aOrgaos,{|x| x[1] == aRecord[8] }) == 0 // ORGSUP
			aadd(aOrgaos,{aRecord[8],aRecord[9]})
	Endif

	if ascan(aOrgaos,{|x| x[1] == aRecord[10] } ) == 0 // ORGCONCED
			aadd(aOrgaos,{aRecord[10],aRecord[17]})
	Endif

	if len(aRecord) <> nCols
		conout(hexstrdump(cLine))
		varinfo("",aRecord)
		USerException("Formato inesperado")
	Endif
	// varinfo("",aRecord)
	
	nLines++

	dbselectarea("CONVENIOS")
	dbappend()
	For nI := 1 to len(aRecord)
		Fieldput(nI,aRecord[nI])
	Next                    
	dbcommit()
	dbrunlock()
	
	if time() <> cTime
		varinfo("",aRecord)
		conout(nLines)
		cTime := time()
	Endif
	
Enddo

// varinfo("aColunas",aColunas)

conout("Linhas : "+cValToChar(nLines))

/*
populate("Modali",aModali)
populate("Situac",aSituac)
populate("SubSit",aSubSit)
populate("Esfera",aEsfera)
populate("Regiao",aRegiao)
populate("SitPub",aSitPub)
populate("Qualif",aQualif)
       
aSort(aOrgaos,,,{|x1,x2| x1[1] < x2[1]})
varinfo("Orgaos",aOrgaos)

DbSelectArea("ORGAOS")
for nI := 1 to len(aOrgaos)
  dbappend()
	fieldput(1,aOrgaos[nI][1])
	fieldput(2,aOrgaos[nI][2])
	dbcommit()
	dbrunlock()
Next
*/

oTXTFile:Close()

Return
                              



/*
use governo;


CREATE TABLE ConveniosProgramas (

ANO_CONVENIO int(4) not null default 0 ,
NR_CONVENIO int(6) not null default 0 ,
ANO_PROPOSTA int(4) not null default 0,
NR_PROPOSTA int(6) not null default 0,
TX_MODALIDADE varchar(64) null,
TX_SITUACAO varchar(128) null,
TX_SUBSITUACAO  varchar(64) null,
CD_ORGAO_SUPERIOR int(6) not null default 0,
NM_ORGAO_SUPERIOR varchar(256),
CD_ORGAO_CONCEDENTE int(6) not null default 0,
TX_ESFERA_ADM_PROPONENTE varchar(64) null,
TX_REGIAO_PROPONENTE varchar(16) null,
UF_PROPONENTE char(2) not null default '  ',
NM_MUNICIPIO_PROPONENTE varchar(256) null,
CD_IDENTIF_PROPONENTE varchar(256) null,
NM_PROPONENTE varchar(256) null,
NM_ORGAO_CONCEDENTE varchar(256) null,
DT_INCLUSAO_PROPOSTA date null,
CD_PROGRAMA varchar(64) null,
NM_PROGRAMA varchar(256) null,
CD_ACAO_PPA varchar(64) null,
DT_INICIO_VIGENCIA date null,
DT_FIM_VIGENCIA date null,
DT_ASSINATURA_CONVENIO date null,
MES_ASSINATURA_CONVENIO int(2) not null default 0,
ANO_ASSINATURA_CONVENIO int(4) not null default 0,
MES_PUBLICACAO_CONVENIO int(2) not null default 0,
ANO_PUBLICACAO_CONVENIO int(4) not null default 0,
DT_PUBLICACAO date null,
DT_ULTIMO_EMPENHO date null,
DT_ULTIMO_PGTO date null,
VL_GLOBAL  decimal(18,2) not null default 0,
VL_REPASSE decimal(18,2) not null default 0,
VL_CONTRAPARTIDA_TOTAL decimal(18,2) not null default 0,
VL_CONTRAPARTIDA_FINANC decimal(18,2) not null default 0,
VL_CONTRAPARTIDA_BENS_SERV decimal(18,2) not null default 0,
VL_DESEMBOLSADO decimal(18,2) not null default 0,
VL_EMPENHADO decimal(18,2) not null default 0,
TX_OBJETO_CONVENIO varchar(512) null,
TX_JUSTIFICATIVA varchar(512) null,
TX_ENDERECO_PROPONENTE varchar(256) null,
TX_BAIRRO_PROPONENTE varchar(64) null,
NR_CEP_PROPONENTE char(9) not null default '     -   ',
NM_RESPONS_PROPONENTE varchar(128) null,
CD_RESPONS_PROPONENTE varchar(32) null,
TX_CARGO_RESPONS_PROPONENTE varchar(128) null,
NM_RESPONS_CONCEDENTE varchar(128) null,
CD_RESPONS_CONCEDENTE varchar(32) null,
TX_CARGO_RESPONS_CONCEDENTE varchar(128) null,
TX_SITUACAO_PUBLICACAO varchar(128) null,
NR_PROCESSO_CONVENIO varchar(32) null,
NR_INTERNO_CONVENIO varchar(32) null,
IN_ASSINADO_SN char(1) not null default ' ',
IN_ADITIVO_SN char(1) not null default ' ',
IN_PUBLICADO_SN char(1) not null default ' ',
IN_EMPENHADO_SN char(1) not null default ' ',
IN_PRORROGA_OFICIO_SN char(1) not null default ' ',
IN_PERMITE_AJUSTE_CRON_FISICO  char(1) not null default ' ',
QT_EMPENHOS int(6) not null default 0,
QT_ADITIVOS int(6) not null default 0,
QT_PRORROGAS int(6) not null default 0,
TX_QUALIFIC_PROPONENTE varchar(32) null,
ID_CONVENIO int(12) not null default 0,
ID_PROP int(12) not null default 0,
ID_PROP_PROGRAMA int(12) not null default 0 )


aColunas -> ARRAY (   65) [...]
aColunas[1] -> ARRAY (    3) [...]
aColunas[1][1] -> C (   12) [ano_convenio]
aColunas[1][2] -> N (   15) [         4.0000]
aColunas[1][3] -> N (   15) [         4.0000]
aColunas[2] -> ARRAY (    3) [...]
aColunas[2][1] -> C (   11) [nr_convenio]
aColunas[2][2] -> N (   15) [         6.0000]
aColunas[2][3] -> N (   15) [         6.0000]
aColunas[3] -> ARRAY (    3) [...]
aColunas[3][1] -> C (   12) [ano_proposta]
aColunas[3][2] -> N (   15) [         4.0000]
aColunas[3][3] -> N (   15) [         4.0000]
aColunas[4] -> ARRAY (    3) [...]
aColunas[4][1] -> C (   11) [nr_proposta]
aColunas[4][2] -> N (   15) [         1.0000]
aColunas[4][3] -> N (   15) [         6.0000]
aColunas[5] -> ARRAY (    3) [...]
aColunas[5][1] -> C (   13) [tx_modalidade]
aColunas[5][2] -> N (   15) [         7.0000]
aColunas[5][3] -> N (   15) [        30.0000]
aColunas[6] -> ARRAY (    3) [...]
aColunas[6][1] -> C (   11) [tx_situacao]
aColunas[6][2] -> N (   15) [         0.0000]
aColunas[6][3] -> N (   15) [        71.0000]
aColunas[7] -> ARRAY (    3) [...]
aColunas[7][1] -> C (   14) [tx_subsituacao]
aColunas[7][2] -> N (   15) [         7.0000]
aColunas[7][3] -> N (   15) [        30.0000]
aColunas[8] -> ARRAY (    3) [...]
aColunas[8][1] -> C (   17) [cd_orgao_superior]
aColunas[8][2] -> N (   15) [         5.0000]
aColunas[8][3] -> N (   15) [         5.0000]
aColunas[9] -> ARRAY (    3) [...]
aColunas[9][1] -> C (   17) [nm_orgao_superior]
aColunas[9][2] -> N (   15) [        17.0000]
aColunas[9][3] -> N (   15) [        49.0000]
aColunas[10] -> ARRAY (    3) [...]
aColunas[10][1] -> C (   19) [cd_orgao_concedente]
aColunas[10][2] -> N (   15) [         5.0000]
aColunas[10][3] -> N (   15) [         5.0000]
aColunas[11] -> ARRAY (    3) [...]
aColunas[11][1] -> C (   24) [tx_esfera_adm_proponente]
aColunas[11][2] -> N (   15) [         7.0000]
aColunas[11][3] -> N (   15) [        40.0000]
aColunas[12] -> ARRAY (    3) [...]
aColunas[12][1] -> C (   20) [tx_regiao_proponente]
aColunas[12][2] -> N (   15) [         3.0000]
aColunas[12][3] -> N (   15) [        12.0000]
aColunas[13] -> ARRAY (    3) [...]
aColunas[13][1] -> C (   13) [uf_proponente]
aColunas[13][2] -> N (   15) [         2.0000]
aColunas[13][3] -> N (   15) [         2.0000]
aColunas[14] -> ARRAY (    3) [...]
aColunas[14][1] -> C (   23) [nm_municipio_proponente]
aColunas[14][2] -> N (   15) [         3.0000]
aColunas[14][3] -> N (   15) [        32.0000]
aColunas[15] -> ARRAY (    3) [...]
aColunas[15][1] -> C (   21) [cd_identif_proponente]
aColunas[15][2] -> N (   15) [        14.0000]
aColunas[15][3] -> N (   15) [        14.0000]
aColunas[16] -> ARRAY (    3) [...]
aColunas[16][1] -> C (   13) [nm_proponente]
aColunas[16][2] -> N (   15) [         5.0000]
aColunas[16][3] -> N (   15) [       144.0000]
aColunas[17] -> ARRAY (    3) [...]
aColunas[17][1] -> C (   19) [nm_orgao_concedente]
aColunas[17][2] -> N (   15) [        17.0000]
aColunas[17][3] -> N (   15) [        66.0000]
aColunas[18] -> ARRAY (    3) [...]
aColunas[18][1] -> C (   20) [dt_inclusao_proposta]
aColunas[18][2] -> N (   15) [        10.0000]
aColunas[18][3] -> N (   15) [        10.0000]
aColunas[19] -> ARRAY (    3) [...]
aColunas[19][1] -> C (   11) [cd_programa]
aColunas[19][2] -> N (   15) [        10.0000]
aColunas[19][3] -> N (   15) [        13.0000]
aColunas[20] -> ARRAY (    3) [...]
aColunas[20][1] -> C (   11) [nm_programa]
aColunas[20][2] -> N (   15) [         1.0000]
aColunas[20][3] -> N (   15) [       250.0000]
aColunas[21] -> ARRAY (    3) [...]
aColunas[21][1] -> C (   11) [cd_acao_ppa]
aColunas[21][2] -> N (   15) [         8.0000]
aColunas[21][3] -> N (   15) [         8.0000]
aColunas[22] -> ARRAY (    3) [...]
aColunas[22][1] -> C (   18) [dt_inicio_vigencia]
aColunas[22][2] -> N (   15) [        10.0000]
aColunas[22][3] -> N (   15) [        10.0000]
aColunas[23] -> ARRAY (    3) [...]
aColunas[23][1] -> C (   15) [dt_fim_vigencia]
aColunas[23][2] -> N (   15) [        10.0000]
aColunas[23][3] -> N (   15) [        10.0000]
aColunas[24] -> ARRAY (    3) [...]
aColunas[24][1] -> C (   22) [dt_assinatura_convenio]
aColunas[24][2] -> N (   15) [         0.0000]
aColunas[24][3] -> N (   15) [        10.0000]
aColunas[25] -> ARRAY (    3) [...]
aColunas[25][1] -> C (   23) [mes_assinatura_convenio]
aColunas[25][2] -> N (   15) [         0.0000]
aColunas[25][3] -> N (   15) [         2.0000]
aColunas[26] -> ARRAY (    3) [...]
aColunas[26][1] -> C (   23) [ano_assinatura_convenio]
aColunas[26][2] -> N (   15) [         0.0000]
aColunas[26][3] -> N (   15) [         4.0000]
aColunas[27] -> ARRAY (    3) [...]
aColunas[27][1] -> C (   23) [mes_publicacao_convenio]
aColunas[27][2] -> N (   15) [         0.0000]
aColunas[27][3] -> N (   15) [         2.0000]
aColunas[28] -> ARRAY (    3) [...]
aColunas[28][1] -> C (   23) [ano_publicacao_convenio]
aColunas[28][2] -> N (   15) [         0.0000]
aColunas[28][3] -> N (   15) [         4.0000]
aColunas[29] -> ARRAY (    3) [...]
aColunas[29][1] -> C (   13) [dt_publicacao]
aColunas[29][2] -> N (   15) [         0.0000]
aColunas[29][3] -> N (   15) [        10.0000]
aColunas[30] -> ARRAY (    3) [...]
aColunas[30][1] -> C (   17) [dt_ultimo_empenho]
aColunas[30][2] -> N (   15) [         0.0000]
aColunas[30][3] -> N (   15) [        10.0000]
aColunas[31] -> ARRAY (    3) [...]
aColunas[31][1] -> C (   14) [dt_ultimo_pgto]
aColunas[31][2] -> N (   15) [         0.0000]
aColunas[31][3] -> N (   15) [        10.0000]
aColunas[32] -> ARRAY (    3) [...]
aColunas[32][1] -> C (    9) [vl_global]
aColunas[32][2] -> N (   15) [         7.0000]
aColunas[32][3] -> N (   15) [        17.0000]
aColunas[33] -> ARRAY (    3) [...]
aColunas[33][1] -> C (   10) [vl_repasse]
aColunas[33][2] -> N (   15) [         0.0000]
aColunas[33][3] -> N (   15) [        17.0000]
aColunas[34] -> ARRAY (    3) [...]
aColunas[34][1] -> C (   22) [vl_contrapartida_total]
aColunas[34][2] -> N (   15) [         7.0000]
aColunas[34][3] -> N (   15) [        17.0000]
aColunas[35] -> ARRAY (    3) [...]
aColunas[35][1] -> C (   23) [vl_contrapartida_financ]
aColunas[35][2] -> N (   15) [         7.0000]
aColunas[35][3] -> N (   15) [        17.0000]
aColunas[36] -> ARRAY (    3) [...]
aColunas[36][1] -> C (   26) [vl_contrapartida_bens_serv]
aColunas[36][2] -> N (   15) [         7.0000]
aColunas[36][3] -> N (   15) [        16.0000]
aColunas[37] -> ARRAY (    3) [...]
aColunas[37][1] -> C (   15) [vl_desembolsado]
aColunas[37][2] -> N (   15) [         7.0000]
aColunas[37][3] -> N (   15) [        17.0000]
aColunas[38] -> ARRAY (    3) [...]
aColunas[38][1] -> C (   12) [vl_empenhado]
aColunas[38][2] -> N (   15) [         7.0000]
aColunas[38][3] -> N (   15) [        17.0000]
aColunas[39] -> ARRAY (    3) [...]
aColunas[39][1] -> C (   18) [tx_objeto_convenio]
aColunas[39][2] -> N (   15) [         1.0000]
aColunas[39][3] -> N (   15) [       255.0000]
aColunas[40] -> ARRAY (    3) [...]
aColunas[40][1] -> C (   16) [tx_justificativa]
aColunas[40][2] -> N (   15) [         1.0000]
aColunas[40][3] -> N (   15) [       255.0000]
aColunas[41] -> ARRAY (    3) [...]
aColunas[41][1] -> C (   22) [tx_endereco_proponente]
aColunas[41][2] -> N (   15) [         8.0000]
aColunas[41][3] -> N (   15) [       213.0000]
aColunas[42] -> ARRAY (    3) [...]
aColunas[42][1] -> C (   20) [tx_bairro_proponente]
aColunas[42][2] -> N (   15) [         0.0000]
aColunas[42][3] -> N (   15) [        45.0000]
aColunas[43] -> ARRAY (    3) [...]
aColunas[43][1] -> C (   17) [nr_cep_proponente]
aColunas[43][2] -> N (   15) [         9.0000]
aColunas[43][3] -> N (   15) [         9.0000]
aColunas[44] -> ARRAY (    3) [...]
aColunas[44][1] -> C (   21) [nm_respons_proponente]
aColunas[44][2] -> N (   15) [         0.0000]
aColunas[44][3] -> N (   15) [        60.0000]
aColunas[45] -> ARRAY (    3) [...]
aColunas[45][1] -> C (   21) [cd_respons_proponente]
aColunas[45][2] -> N (   15) [         0.0000]
aColunas[45][3] -> N (   15) [        11.0000]
aColunas[46] -> ARRAY (    3) [...]
aColunas[46][1] -> C (   27) [tx_cargo_respons_proponente]
aColunas[46][2] -> N (   15) [         0.0000]
aColunas[46][3] -> N (   15) [       116.0000]
aColunas[47] -> ARRAY (    3) [...]
aColunas[47][1] -> C (   21) [nm_respons_concedente]
aColunas[47][2] -> N (   15) [         0.0000]
aColunas[47][3] -> N (   15) [        57.0000]
aColunas[48] -> ARRAY (    3) [...]
aColunas[48][1] -> C (   21) [cd_respons_concedente]
aColunas[48][2] -> N (   15) [         0.0000]
aColunas[48][3] -> N (   15) [        11.0000]
aColunas[49] -> ARRAY (    3) [...]
aColunas[49][1] -> C (   27) [tx_cargo_respons_concedente]
aColunas[49][2] -> N (   15) [         0.0000]
aColunas[49][3] -> N (   15) [       108.0000]
aColunas[50] -> ARRAY (    3) [...]
aColunas[50][1] -> C (   22) [tx_situacao_publicacao]
aColunas[50][2] -> N (   15) [         0.0000]
aColunas[50][3] -> N (   15) [        34.0000]
aColunas[51] -> ARRAY (    3) [...]
aColunas[51][1] -> C (   20) [nr_processo_convenio]
aColunas[51][2] -> N (   15) [         0.0000]
aColunas[51][3] -> N (   15) [        25.0000]
aColunas[52] -> ARRAY (    3) [...]
aColunas[52][1] -> C (   19) [nr_interno_convenio]
aColunas[52][2] -> N (   15) [         1.0000]
aColunas[52][3] -> N (   15) [        11.0000]
aColunas[53] -> ARRAY (    3) [...]
aColunas[53][1] -> C (   14) [in_assinado_sn]
aColunas[53][2] -> N (   15) [         1.0000]
aColunas[53][3] -> N (   15) [         1.0000]
aColunas[54] -> ARRAY (    3) [...]
aColunas[54][1] -> C (   13) [in_aditivo_sn]
aColunas[54][2] -> N (   15) [         1.0000]
aColunas[54][3] -> N (   15) [         1.0000]
aColunas[55] -> ARRAY (    3) [...]
aColunas[55][1] -> C (   15) [in_publicado_sn]
aColunas[55][2] -> N (   15) [         1.0000]
aColunas[55][3] -> N (   15) [         1.0000]
aColunas[56] -> ARRAY (    3) [...]
aColunas[56][1] -> C (   15) [in_empenhado_sn]
aColunas[56][2] -> N (   15) [         1.0000]
aColunas[56][3] -> N (   15) [         1.0000]
aColunas[57] -> ARRAY (    3) [...]
aColunas[57][1] -> C (   21) [in_prorroga_oficio_sn]
aColunas[57][2] -> N (   15) [         1.0000]
aColunas[57][3] -> N (   15) [         1.0000]
aColunas[58] -> ARRAY (    3) [...]
aColunas[58][1] -> C (   29) [in_permite_ajuste_cron_fisico]
aColunas[58][2] -> N (   15) [         1.0000]
aColunas[58][3] -> N (   15) [         1.0000]
aColunas[59] -> ARRAY (    3) [...]
aColunas[59][1] -> C (   11) [qt_empenhos]
aColunas[59][2] -> N (   15) [         0.0000]
aColunas[59][3] -> N (   15) [         3.0000]
aColunas[60] -> ARRAY (    3) [...]
aColunas[60][1] -> C (   11) [qt_aditivos]
aColunas[60][2] -> N (   15) [         0.0000]
aColunas[60][3] -> N (   15) [         2.0000]
aColunas[61] -> ARRAY (    3) [...]
aColunas[61][1] -> C (   12) [qt_prorrogas]
aColunas[61][2] -> N (   15) [         0.0000]
aColunas[61][3] -> N (   15) [         2.0000]
aColunas[62] -> ARRAY (    3) [...]
aColunas[62][1] -> C (   22) [tx_qualific_proponente]
aColunas[62][2] -> N (   15) [         0.0000]
aColunas[62][3] -> N (   15) [        31.0000]
aColunas[63] -> ARRAY (    3) [...]
aColunas[63][1] -> C (   11) [id_convenio]
aColunas[63][2] -> N (   15) [         4.0000]
aColunas[63][3] -> N (   15) [         6.0000]
aColunas[64] -> ARRAY (    3) [...]
aColunas[64][1] -> C (    7) [id_prop]
aColunas[64][2] -> N (   15) [         4.0000]
aColunas[64][3] -> N (   15) [         7.0000]
aColunas[65] -> ARRAY (    3) [...]
aColunas[65][1] -> C (   16) [id_prop_programa]
aColunas[65][2] -> N (   15) [         2.0000]
aColunas[65][3] -> N (   15) [         6.0000]


Linhas : 120778



aModali -> ARRAY (    5) [...]
aModali[1] -> C (    7) [Convnio]
aModali[2] -> C (   19) [Contrato de Repasse]
aModali[3] -> C (   17) [Termo de Parceria]
aModali[4] -> C (   17) [Termo de Cooperao]
aModali[5] -> C (   30) [Convnio ou Contrato de Repasse]

aSituac -> ARRAY (   23) [...]
aSituac[1] -> C (   26) [Prestao de Contas Aprovada]
aSituac[2] -> C (   27) [Prestao de Contas em Anlise]
aSituac[3] -> C (    0) []
aSituac[4] -> C (   28) [Aguardando Prestao de Contas]
aSituac[5] -> C (   38) [Proposta/Plano de Trabalho Cadastrados]
aSituac[6] -> C (   37) [Prestao de Contas enviada para Anlise]
aSituac[7] -> C (   36) [Proposta/Plano de Trabalho Aprovados]
aSituac[8] -> C (   33) [Prestao de Contas em Complementao]
aSituac[9] -> C (   27) [Prestao de Contas Rejeitada]
aSituac[10] -> C (   40) [Prestao de Contas Aprovada com Ressalvas]
aSituac[11] -> C (    9) [Em execuo]
aSituac[12] -> C (   37) [Proposta/Plano de Trabalho Cancelados]
aSituac[13] -> C (   42) [Proposta/Plano de Trabalho em Complementao]
aSituac[14] -> C (   50) [Proposta/Plano de Trabalho complementado em Anlise]
aSituac[15] -> C (   53) [Proposta Aprovada e Plano de Trabalho em Complementao]
aSituac[16] -> C (   36) [Proposta/Plano de Trabalho em Anlise]
aSituac[17] -> C (   37) [Proposta/Plano de Trabalho Rejeitados]
aSituac[18] -> C (   59) [Proposta/Plano de Trabalho complementado envida para Anlise]
aSituac[19] -> C (   71) [Proposta Aprovada e Plano de Trabalho Complementado enviado para Anlise]
aSituac[20] -> C (   47) [Proposta Aprovada e Plano de Trabalho em Anlise]
aSituac[21] -> C (   46) [Proposta/Plano de Trabalho enviado para Anlise]
aSituac[22] -> C (   61) [Proposta Aprovada e Plano de Trabalho Complementado em Anlise]
aSituac[23] -> C (    8) [Assinado]

aSubSit -> ARRAY (    8) [...]
aSubSit[1] -> C (    7) [Convnio]
aSubSit[2] -> C (   26) [Em Ajustes pelo Convenente]
aSubSit[3] -> C (   12) [Em Prorrogao]
aSubSit[4] -> C (   11) [Em Aditivao]
aSubSit[5] -> C (   30) [Em Ajuste do Plano de Trabalho]
aSubSit[6] -> C (   24) [Em Complementao Prorroga]
aSubSit[7] -> C (   26) [Em Ajustes pelo Concedente]
aSubSit[8] -> C (    9) [Em Anlise]

aEsfera -> ARRAY (    6) [...]
aEsfera[1] -> C (    7) [PRIVADA]
aEsfera[2] -> C (    8) [ESTADUAL]
aEsfera[3] -> C (    9) [MUNICIPAL]
aEsfera[4] -> C (   40) [EMPRESA_PUBLICA_SOCIEDADE_ECONOMIA_MISTA]
aEsfera[5] -> C (    7) [FEDERAL]
aEsfera[6] -> C (   17) [CONSORCIO_PUBLICO]

aRegiao -> ARRAY (    5) [...]
aRegiao[1] -> C (    5) [Norte]
aRegiao[2] -> C (    8) [Nordeste]
aRegiao[3] -> C (   12) [Centro-Oeste]
aRegiao[4] -> C (    7) [Sudeste]
aRegiao[5] -> C (    3) [Sul]

aSitPub -> ARRAY (    5) [...]
aSitPub[1] -> C (    9) [PUBLICADO]
aSitPub[2] -> C (    0) []
aSitPub[3] -> C (   13) [NAO_PUBLICADO]
aSitPub[4] -> C (   10) [A_PUBLICAR]
aSitPub[5] -> C (   34) [TRANSFERIDO_PARA_IMPRENSA_NACIONAL]

aQualif -> ARRAY (    4) [...]
aQualif[1] -> C (   18) [REPASSE_VOLUNTARIO]
aQualif[2] -> C (    0) []
aQualif[3] -> C (   31) [BENEFICIARIO_EMENDA_PARLAMENTAR]
aQualif[4] -> C (   23) [BENEFICIARIO_ESPECIFICO]


*/


STATIC Function ParseLine(cline)
Local aRet := {}
Local nI , nT := len(cLine)
Local lInAspas := .f.
Local cTeco := ''
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

Static function populate(cAlias,aDados)
Local nI
DbSelectArea(cAlias)

for nI := 1 to len(aDados)
  dbappend()
	fieldput(1,strzero(nI,2))
	fieldput(2,aDados[nI])
	dbcommit()
	dbrunlock()
Next

Return





