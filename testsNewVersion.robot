*** Settings ***

Documentation     Zoomba Desktop Library Tests.
Library           Zoomba.DesktopLibrary
Suite Setup       Start App
Suite Teardown    Driver Teardown
Force Tags        Windows

*** Variables ***
${REMOTE_URL}           http://127.0.0.1:4723
${TruckFlow}            C:/Program Files (x86)/PRECIAMOLEN/Truckflow/OperatorStation/PM.TruckFlow.Clients.OperatorStation.exe

${UserLogin}    SuperUser
${MotDePasse}    147258
${EditWeightPosX}    1513
${EditWeightPosY}    432
${LibBadgePosX}    398
${LibBadgePosY}    224

*** Keywords ***
Start App
    [Documentation]     Sets up the application for quick launching through 'Launch Application' and starts the winappdriver
    Driver Setup
    Open Application    ${REMOTE_URL}     platformName=Windows    deviceName=Windows   app=${TruckFlow}    alias=Main
    Maximize Window

Login
    [Arguments]    ${username}    ${password}
    Wait For And Input Password    accessibility_id=PasswordBox    ${password}    30
    Wait For And Input Text        accessibility_id=UsernameTextBox    ${username}
    Wait Until Element Contains    accessibility_id=UsernameTextBox    ${username}
    Wait For And Click Element     accessibility_id=BTConnect
    Switch Application By Locator     http://localhost:4723    name=Licence requise
    Wait For And Click Element     accessibility_id=ButtonTrialVersion

*** Test Cases ***
Login Test
    Login    ${UserLogin}    ${MotDePasse}
   
Restore DataBase Test
    Switch Application By Locator       http://localhost:4723    accessibility_id=MainWindows
    #Wait For And Click Element     accessibility_id=Maximize-Restore
    #Wait For And Click Element    accessibility_id=BTDataBase    10
    #Wait For And Click Element    name=Restaurer la base de données    5
    #Wait For And Click Element    name=Restaurer la base de données
    #Wait For And Click Element    accessibility_id=OK
    #Switch Application By Locator	http://localhost:4723	name=Restauration
    #Wait For And Click Element    name=FULLDB.bak
    #Wait For And Click Element    name=Restaurer la base de données
    #Switch Application By Name	http://localhost:4723	accessibility_id=MainWindows
    #Wait For And Click Element    accessibility_id=OK    30
    #Login    SuperUser    147258

Weighing Test
    #Switch Application By Locator    http://localhost:4723    accessibility_id=MainWindows 
    Wait For And Click Element       accessibility_id=BTStandardWeighing     10

    #Wait For And Enter Element       name=Code badge    1    10        #sélection saisie du badge

    Wait For And Click Element       name=Code badge    10        #sélection saisie du badge
    Send Keys    1    \ue007

    ${EditWeightOffsetX} =    evaluate    ${EditWeightPosX}-${LibBadgePosX}
    ${EditWeightOffsetY} =    evaluate    ${EditWeightPosY}-${LibBadgePosY}
    Click A Point    ${EditWeightOffset_x}    ${EditWeightOffset_y}    #pointage de la zone de saisie du poids
    Send Keys    1    0    0    0    0    \ue007        #saisie du poids
    
    Wait For And Click Element       accessibility_id=BTCaptureExitWeight    5           #capture du poids
    Wait For And Click Element       accessibility_id=BTTerminateWeight    5    #enregistrement du camion BTValidateEntryWeight

    #Wait For And Click Element       name=Plaque    10            #sélection saisie de la plaque
    #Send Keys    1    \ue007
    #Wait For And Click Element       name=Code tiers    10        #sélection saisie du tiers
    #Send Keys    1    \ue007
    #Wait For And Click Element       name=Code produit    10        #sélection saisie du produit
    #Send Keys    1    \ue007

    #Input Text                       name=Code badge    1        #saisie du badge
    #Wait For And Input Text          name=Code badge     1        #saisie du badge

    #Wait For And Click Element    accessibility_id=BTCreateStandardWeighing    
    #Wait For And Click Element    accessibility_id=TestValueOpen    #recherche de tout les badges qui commencent par 2
    #Wait For And Click Element    name=200    #Choix du badge 200
    #Element Text Should Be        accessibility_id=txbPlate    2000    #verification des différents champs associé au badge
 
    #Element Text Should Be    xpath=//*[@Name='Plaque']/parent::*    2000    #verification des différents champs associé au badge
    #Element Text Should Be    xpath=//*[@Name='Code tiers']/parent::*    2
    #Element Text Should Be    xpath=//*[@Name='Libellé tiers']/parent::*    Beton de France
    #Element Text Should Be    xpath=//*[@Name='Code produit']/parent::*    2          
    #Element Text Should Be    xpath=//*[@Name='Libellé produit']/parent::*    Melange Beton
    #@{textbox}    Get Webelements    accessibility_id=textbox
    #Input Text    ${textbox}[3]    1500
    #Wait For And Click Element    accessibility_id=BTCaptureEntryWeight
    #Wait For And Click Element    accessibility_id=BTValidateEntryWeight
    #Wait For And Click Element    accessibility_id=Open
    #@{textbox}    Get Webelements    accessibility_id=textbox
    #Input Text    ${textbox}[3]    500
    #Wait For And Click Element    accessibility_id=BTCaptureExitWeight
    #Wait For And Click Element    accessibility_id=BTTerminate

#Output Application
    #Wait For And Click Element    accessibility_id=OK    30        #validation de la sortie de l'application