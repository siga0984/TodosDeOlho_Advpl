#include 'protheus.ch'
#include 'apwebex.ch'

USer Function SicHelp()

Local cHtml := ''                       

WEB EXTENDED INIT cHtml

U_DBSetup()

U_LogSite()

cHtml := H_SICHELP()

WEB EXTENDED END 

Return cHtml
