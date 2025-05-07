*** Settings ***
Documentation     Start the app
Library  AppiumLibrary

*** Variables ***
${AUTOMATION_NAME}  UiAutomator2
${ignoreHiddenApiPolicyError}    true
${autoGrantPermissions}    true
${uiautomator2ServerInstallTimeout}    120000
${uiautomator2ServerLaunchTimeout}    120000
${adbExecTimeout}    80000
${START_APP_TIMEOUT}  10s

*** Test Cases ***
Start the app
    [Documentation]  Start app
    Log To Console  Starting app
    Start App
    Sleep  ${START_APP_TIMEOUT}
    Log To Console  App started successfully

*** Keywords ***
Start App
    [Documentation]  Start App Keyword
    Open Application  ${APPIUM_SERVER}  automationName=${AUTOMATION_NAME}
      ...  platformName=${PLATFORM_NAME}  platformVersion=${PLATFORM_VERSION}
      ...  app=${APP}  appPackage=${APP_PACKAGE}  appActivity=${APP_ACTIVITY}
      ...  deviceName=${DEVICE_NAME}
      ...  avd=${AVD_NAME}
      ...  uiautomator2ServerInstallTimeout=${uiautomator2ServerInstallTimeout}
      ...  uiautomator2ServerLaunchTimeout=${uiautomator2ServerLaunchTimeout}
      ...  ignoreHiddenApiPolicyError=${ignoreHiddenApiPolicyError}
      ...  autoGrantPermissions=${autoGrantPermissions}
      ...  adbExecTimeout=${adbExecTimeout}
      ...  disableAndroidWatchers=true
      ...  disableWindowAnimation=true
      ...  noReset=false
      ...  ensureWebviewsHavePages=true

Close App
    [Documentation]  Close the app
    Close Application
