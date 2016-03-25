#include 'protheus.ch'
#include 'apwebex.ch'

USer Function SicMain()

Local cHtml := ''                       

WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

cHtml := H_SICMAIN()

WEB EXTENDED END 

Return cHtml
