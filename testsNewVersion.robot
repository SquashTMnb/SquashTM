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

Weighing Test
    Wait For And Click Element       accessibility_id=BTStandardWeighing     10

    Wait For And Click Element       name=Code badge    10        #sélection saisie du badge
    Send Keys    1    \ue007

    ${EditWeightOffsetX} =    evaluate    ${EditWeightPosX}-${LibBadgePosX}
    ${EditWeightOffsetY} =    evaluate    ${EditWeightPosY}-${LibBadgePosY}
    Click A Point    ${EditWeightOffset_x}    ${EditWeightOffset_y}    #pointage de la zone de saisie du poids
    Send Keys    1    0    0    0    0    \ue007        #saisie du poids
    
    Wait For And Click Element       accessibility_id=BTCaptureExitWeight    5           #capture du poids
    Wait For And Click Element       accessibility_id=BTTerminateWeight    5    #enregistrement du camion BTValidateEntryWeight

#Output Application
    #Wait For And Click Element    accessibility_id=OK    30        #validation de la sortie de l'application