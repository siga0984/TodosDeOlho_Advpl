#include 'protheus.ch'
#include 'apwebex.ch'

USer Function SicLogout()

Local cHtml := ''                       

WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

cHtml := H_SICLOGOUT()

HTTPFreeSession()

WEB EXTENDED END 

Return cHtml
