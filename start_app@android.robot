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
${ignoreHiddenApiPolicyError}    true
${autoGrantPermissions}    true
${uiautomator2ServerInstallTimeout}    120000
${uiautomator2ServerLaunchTimeout}    120000
${adbExecTimeout}    80000
${START_APP_TIMEOUT}  10s

*** Test Cases ***
Start the app
    [Documentation]  Start the app with the given capabilities
    Start App
    Sleep  ${START_APP_TIMEOUT}

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
      ...  autoGrantPermissions=${autoGrantPermissions}
      ...  adbExecTimeout=${adbExecTimeout}

Close App
    [Documentation]  Close the app
    Close Application
