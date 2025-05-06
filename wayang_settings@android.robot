*** Settings ***
Documentation     Connect to wayang server
Library  AppiumLibrary

*** Variables ***
${MAIN_ACTIVITY_ID}    .view.ViewActivity
${SETTINGS_BUTTON_ID}    iv_connect_status
${SETTINGS_BUTTON_XPATH}    //android.widget.ImageView[contains(@resource-id, 'connect_status')]
${SETTINGS_ACTIVITY_ID}    .view.SettingActivity
${SETTINGS_CONFIRM_BUTTON_ID}   confirm
${WAYANG_URL_ID}    et_server_url
${WAYANG_DEVICE_ID}    et_device_name
${CONNECT_BUTTON_ID}    bt_connet
${UI_OPERATION_TIMEOUT}     5s

*** Test Cases ***
Update Wayang Settings
    [Documentation]    Update the wayang settings
    # ${current_activity}=    Get Current Activity
    # Should Be Equal As Strings    ${current_activity}    ${MAIN_ACTIVITY_ID}
    Wait Until Page Contains Element    ${SETTINGS_BUTTON_XPATH}    timeout=${UI_OPERATION_TIMEOUT}
    ${element_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${SETTINGS_BUTTON_ID}
    Run Keyword If    ${element_exists}    Run With Screenshot Handling    Click Element    ${SETTINGS_BUTTON_ID}
    ...    ELSE    Run With Screenshot Handling    Click Element    ${SETTINGS_BUTTON_XPATH}
    Sleep    ${UI_OPERATION_TIMEOUT}
    Update Settings    ${wayang_url}    ${wayang_device}

*** Keywords ***
Update Settings
    [Arguments]    ${wayang_url}    ${wayang_device}
    [Documentation]    Update settings
    ${current_activity}=    Get Current Activity
    # Handle permission dialog if present
    ${is_permission_activity}=    Run Keyword And Return Status    Should Contain    ${current_activity}    permissioncontroller
    Run Keyword If    ${is_permission_activity}    Click Element    id=com.android.permissioncontroller:id/permission_allow_button
    
    # Wait for UI elements instead of checking exact activity name
    Wait Until Element Is Visible    ${WAYANG_URL_ID}    timeout=${UI_OPERATION_TIMEOUT}
    Set Input Text    ${WAYANG_URL_ID}    ${wayang_url}
    Set Input Text    ${WAYANG_DEVICE_ID}    ${wayang_device}
    Click Element    ${CONNECT_BUTTON_ID}
    Sleep    ${UI_OPERATION_TIMEOUT}
    Click Element    ${SETTINGS_CONFIRM_BUTTON_ID}
    Sleep    ${UI_OPERATION_TIMEOUT}

Get Current Activity
    [Documentation]    Get the current activity
    ${current_activity}=    Get Activity
    Log    Current activity: ${current_activity}
    RETURN    ${current_activity}

Set Input Text
    [Arguments]    ${element_id}    ${text}
    [Documentation]    Set input text for the given element
    Wait Until Element Is Visible    ${element_id}    timeout=${UI_OPERATION_TIMEOUT}
    Input Text    ${element_id}    ${text}

Run With Screenshot Handling
    [Arguments]    ${keyword}    @{args}
    [Documentation]    Run a keyword and handle screenshot errors
    ${status}    ${message}=    Run Keyword And Ignore Error    ${keyword}    @{args}
    Run Keyword If    '${status}' == 'FAIL' and 'TakeScreenshotException' in '''${message}'''    Log    Screenshot failed due to secure view, continuing test    WARN
    Run Keyword If    '${status}' == 'FAIL' and 'TakeScreenshotException' not in '''${message}'''    Fail    ${message}
    RETURN    ${status}
