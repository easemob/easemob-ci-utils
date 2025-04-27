*** Settings ***
Documentation     Start the app
Library  AppiumLibrary

*** Variables ***
${APPIUM_SERVER}
${PLATFORM_NAME}
${PLATFORM_VERSION}
${DEVICE_NAME}
${APP}
${AUTOMATION_NAME}  UiAutomator2
${APP_PACKAGE}
${APP_ACTIVITY}
${ignoreHiddenApiPolicyError}
${uiautomator2ServerInstallTimeout}
${uiautomator2ServerLaunchTimeout}

*** Test Cases ***

# START_APP placeholder

Start the app
    [Documentation]  Start the app with the given capabilities
    Start App

*** Keywords ***
Start App
    [Documentation]  Start the app with the given capabilities
    Open Application  ${APPIUM_SERVER}  automationName=${AUTOMATION_NAME}
      ...  platformName=${PLATFORM_NAME}  platformVersion=${PLATFORM_VERSION}
      ...  app=${APP}  appPackage=${APP_PACKAGE}  appActivity=${APP_ACTIVITY}
      ...  deviceName=${DEVICE_NAME}
      ...  uiautomator2ServerInstallTimeout=${uiautomator2ServerInstallTimeout}
      ...  uiautomator2ServerLaunchTimeout=${uiautomator2ServerLaunchTimeout}
      ...  ignoreHiddenApiPolicyError=${ignoreHiddenApiPolicyError}

Close App
    [Documentation]  Close the app
    Close Application

Click Element
    [Documentation]  Click the given element
    [Arguments]  ${element}
    Click Element  ${element}

Get Input Text
    [Documentation]  Get input text from the given element
    [Arguments]  ${element}
    ${text}=  Get Text  ${element}
    RETURN  ${text}

Set Input Text
    [Documentation]  Set input text to the given element
    [Arguments]  ${element}  ${text}
    Clear Text  ${element}
    Input Text  ${element}  ${text}
