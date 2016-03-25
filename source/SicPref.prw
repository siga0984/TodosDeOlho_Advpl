#include 'protheus.ch'
#include 'apwebex.ch'

USer Function SicPref()

Local cHtml := ''                       

WEB EXTENDED INIT cHtml    

U_DBSetup()

U_LogSite()

cHtml := H_SICPREF()

WEB EXTENDED END 

Return cHtml
