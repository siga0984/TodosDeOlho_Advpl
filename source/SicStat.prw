#include 'protheus.ch'
#include 'apwebex.ch'

USer Function sicstat()

Local cHtml := ''                       

WEB EXTENDED INIT cHtml    

U_DBSetup()

U_LogSite()
            

// Site Hit ( Hoje ) 

cQuery := "select count(*) as HOJE from LOGSITE where ACDATE = "
cQuery += "DATEFROMPARTS ( Year(GETDATE()) , month(GetDate()) , day(GetDAte()))"
	
USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"

PRIVATE nHitsHoje := QRY->HOJE

USE


/// Site Hits (TOTAL )

cQuery := "select max(R_E_C_N_O_) as TOTAL from LOGSITE"

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"

PRIVATE nHitsTot := QRY->TOTAL

USE


// Uso de Geolocalização 

cQuery := "select count(*) as TOTAL from LOGSITE where URL like 'GET /u_siconvgeo.apw?%'"

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"

PRIVATE nGeoLocation := QRY->TOTAL

USE



// Municipios consultados        
cQuery := "select count(*) as TOTAL from LOGSITE where URL like 'GET /u_siconv03.apw?%'"

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"

PRIVATE nTotMunicip := QRY->TOTAL

USE

// Propostas consultadas        
cQuery := "select count(*) as TOTAL from LOGSITE where URL like 'GET /u_siconv04.apw?%'"

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"

PRIVATE nTotProp := QRY->TOTAL

USE

// Convenios consultados

cQuery := "select count(*) as TOTAL from LOGSITE where URL like 'GET /u_siconv05.apw?%'"

USE (TcGenQry(,,cQuery)) ALIAS QRY EXCLUSIVE NEW VIA "TOPCONN"

PRIVATE nTotConv := QRY->TOTAL

USE


cHtml := H_sicstat()

WEB EXTENDED END 

Return cHtml
