*** Settings ***
Documentation     Update Android SDK Test app settings
Library  AppiumLibrary

*** Variables ***
${APP_KEY_ID}    et_app_key
${WAYANG_URL_ID}    et_url
${DEVICE_ID}    topicInput
${CONNECT_BUTTON_ID}    btnConnect
${UI_OPERATION_INTERVAL}     5s
${TIME_TO_WAITFOR_CONNECT}    10s

*** Test Cases ***
Update App Settings
    [Documentation]    Update the settings
    Try Close Perm Dialog
    Update Settings    ${app_key}    ${wayang_url}    ${wayang_topic}

*** Keywords ***
Update Settings
    [Arguments]    ${app_key}    ${wayang_url}    ${device}
    [Documentation]    Update settings
    Try Close Perm Dialog

    Wait Until Element Is Visible    ${APP_KEY_ID}    timeout=${UI_OPERATION_INTERVAL}
    Set Input Text    ${APP_KEY_ID}    ${app_key}
    Set Input Text    ${WAYANG_URL_ID}    ${wayang_url}
    Set Input Text    ${DEVICE_ID}    ${device}
    Click Element    ${CONNECT_BUTTON_ID}
    Sleep    ${TIME_TO_WAITFOR_CONNECT}

Try Close Perm Dialog
    [Documentation]    Try to close the permission dialog if it appears
    ${current_activity}=    Get Current Activity
    ${is_permission_activity}=    Run Keyword And Return Status    Should Contain    ${current_activity}    permissioncontroller
    Run Keyword If    ${is_permission_activity}    Click Element    id=com.android.permissioncontroller:id/permission_allow_button

Get Current Activity
    [Documentation]    Get the current activity
    ${current_activity}=    Get Activity
    Log    Current activity: ${current_activity}
    RETURN    ${current_activity}

Set Input Text
    [Arguments]    ${element_id}    ${text}
    [Documentation]    Set input text for the given element
    Wait Until Element Is Visible    ${element_id}    timeout=${UI_OPERATION_INTERVAL}
    Input Text    ${element_id}    ${text}

Run With Screenshot Handling
    [Arguments]    ${keyword}    @{args}
    [Documentation]    Run a keyword and handle screenshot errors
    ${status}    ${message}=    Run Keyword And Ignore Error    ${keyword}    @{args}
    Run Keyword If    '${status}' == 'FAIL' and 'TakeScreenshotException' in '''${message}'''    Log    Screenshot failed due to secure view, continuing test    WARN
    Run Keyword If    '${status}' == 'FAIL' and 'TakeScreenshotException' not in '''${message}'''    Fail    ${message}
    RETURN    ${status}
