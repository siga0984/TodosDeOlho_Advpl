
User Function TabAux()
Local aStru
Local nI  

tclink('MSSQL/CONVENIOAUX','localhost',7890)
tcInternal(30,"AUTORECNO")


If !tccanopen("MUNICIP")

	aStru := {}
	aadd(aStru,{"CODIGO","C",4,0})
	aadd(aStru,{"NOME","C",40,0})
	aadd(aStru,{"UF","C",2,0})
	
	DbCreate("MUNICIP",aStru,"TOPCONN")

Endif

If !tccanopen("ESFERA")

	aStru := {}
	aadd(aStru,{"CODIGO","C",2,0})
	aadd(aStru,{"NOME","C",40,0})
	
	DbCreate("ESFERA",aStru,"TOPCONN")

Endif

// Dados do proponente estao na tabela PROSDADOSP 
// Gerada a partir da importação de "09_PropostasDadosProponente.csv"
// e replicados em diversas tabelas

If !tccanopen("PROPONENTE")

	aStru := {}
	aadd(aStru,{"CODIGO","C",14,0})
	aadd(aStru,{"NOME","C",150,0})
	aadd(aStru,{"ENDERECO","C",220,0})
	aadd(aStru,{"BAIRRO","C",50,0})
	aadd(aStru,{"CEP","C",9,0})
	aadd(aStru,{"UF","C",2,0})
	aadd(aStru,{"EMAIL","C",60,0})
	aadd(aStru,{"FAX","C",80,0})
	aadd(aStru,{"CD_MUNICIP","C",4,0})
	aadd(aStru,{"CD_RESPONS","C",11,0})
  aadd(aStru,{"CD_ESFERA","C",2,0})
	
	DbCreate("PROPONENTE",aStru,"TOPCONN")

Endif


If !tccanopen("ORGAO")

	aStru := {}
	aadd(aStru,{"CODIGO","C",5,0})
	aadd(aStru,{"NOME","C",70,0})
	aadd(aStru,{"CODSUP","C",5,0})
	
	DbCreate("ORGAO",aStru,"TOPCONN")

Endif


// Naturezas e subnaturezas estao na pasta "outros"
// Os codigos das tabelas nao estao bem amarrados....
// O que mais chega perto é o CDNATUREZA da PLANOAPLIC
// 6 digitos para a natureza, 2 para sub-natureza, 
// e o texto NMNATUREZA é ref. a sub-natureza



/*
If !tccanopen("NATUREZA")

	aStru := {}
	aadd(aStru,{"CODIGO","C",6,0})
	aadd(aStru,{"NOME","C",45,0})
	
	DbCreate("NATUREZA",aStru,"TOPCONN")

Endif

If !tccanopen("SUBNATUREZ")

	aStru := {}        
	aadd(aStru,{"CODNAT","C",2,0})
	aadd(aStru,{"CODSUB","C",2,0})
	aadd(aStru,{"NOME","C",45,0})
	
	DbCreate("NATUREZA",aStru,"TOPCONN")

Endif

*/

/*
Existem varias descrições de status que sao enumeradas por tipo
Verificar aquivo "dsc_enumerados.csv"
*/
                                     




Return


