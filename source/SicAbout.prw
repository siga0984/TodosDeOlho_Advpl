#include 'protheus.ch'
#include 'apwebex.ch'

USer Function SicAbout()

Local cHtml := ''                       

WEB EXTENDED INIT cHtml    

U_DBSetup()

U_LogSite()

cHtml := H_SICABOUT()

WEB EXTENDED END 

Return cHtml
