#include 'protheus.ch'
#include 'apwebex.ch'

User function SiconvMUN()
Local cHtml := ''


WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

If empty(httpget->UF)
	
	// Nao chegou o estado
	PRIVATE cErrorMSG := "Estado (UF) n�o informado."
	PRIVATE cErrorHLP := 'A busca por munic�pios n�o recebeu corretamente o estado a ser pesquisado. '+;
											 'Retorne para a tela anterior e tente novamente, ou volte ao in�cio do site.'

	cHtml := h_SicError()
	
Else
	
	
	PRIVATE cUF := HTTPGET->UF
	
	cUF := upper(left(alltrim(cUF),2))
	
	cQuery := "select CODIGO,NOME "
	cQuery += "from convenioaux.dbo.MUNICIP  "
	cQuery += "where UF = '"+cUF+"' "
	cQuery += "order by NOME"
	
	PRIVATE aMunicipios := {}
	
	USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA 'TOPCONN'
	
	While !eof()
		aadd(aMunicipios,{QRY->CODIGO , Capital(alltrim(QRY->NOME))})
		DbSkip()
	Enddo
	
	USE
	
	cHtml := H_SiconvMun()
	
Endif

WEB EXTENDED END

Return cHtml






User function UFNome(cUF)

If cUF == "AC"
	Return "do Acre"
Endif
If cUF == "AL"
	Return "de Alagoas"
Endif
If cUF == "AP"
	Return "do Amap�"
Endif
If cUF == "AM"
	Return "do Amazonas"
Endif
If cUF == "BA"
	Return "da Bahia"
Endif
If cUF == "CE"
	Return "do Cear�"
Endif
If cUF == "DF"
	Return "do Distrito Federal"
Endif
If cUF == "ES"
	Return "do Esp�rito Santo"
Endif
If cUF == "GO"
	Return "de Goi�s"
Endif
If cUF == "MA"
	Return "do Maranh�o"
Endif
If cUF == "MT"
	Return "do Mato Grosso"
Endif
If cUF == "MS"
	Return "do Mato Grosso do Sul"
Endif
If cUF == "MG"
	Return "de Minas Gerais"
Endif
If cUF == "PA"
	Return "do Par�"
Endif
If cUF == "PB"
	Return "da Para�ba"
Endif
If cUF == "PR"
	Return "do Paran�"
Endif
If cUF == "PE"
	Return "de Pernambuco"
Endif
If cUF == "PI"
	Return "do Piau�"
Endif
If cUF == "RJ"
	Return "do Rio de Janeiro"
Endif
If cUF == "RN"
	Return "do Rio Grande do Norte"
Endif
If cUF == "RS"
	Return "do Rio Grande do Sul"
Endif
If cUF == "RO"
	Return "de Rond�nia"
Endif
If cUF == "RR"
	Return "de Roraima"
Endif
If cUF == "SC"
	Return "de Santa Catarina"
Endif
If cUF == "SP"
	Return "de S�o Paulo"
Endif
If cUF == "SE"
	Return "de Sergipe"
Endif
If cUF == "TO"
	Return "do Tocantins"
Endif
Return ""

