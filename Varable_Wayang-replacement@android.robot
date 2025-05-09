*** Variables ***
${WsUrl}    ws://180.184.175.123:2000/iov/websocket/dual?topic=
&{Wayang1Res}        WSUrl=${WsUrl}    topic=${WAYANG_DEVICE0}    device=Mobile    WSconn=    WShandle=    alias=    consolealias=
&{Wayang2Res}        WSUrl=${WsUrl}    topic=${WAYANG_DEVICE1}    device=Mobile   WSconn=    WShandle=    alias=    consolealias=
&{Wayang3Res}        WSUrl=${WsUrl}    topic=${WAYANG_DEVICE2}    device=Mobile    WSconn=    WShandle=    alias=    consolealias=
&{Wayang4Res}        WSUrl=${WsUrl}    topic=${WAYANG_DEVICE3}    device=Mobile   WSconn=    WShandle=    alias=    consolealias=
&{Wayang5Res}        WSUrl=${WsUrl}    topic=${WAYANG_DEVICE4}    device=Mobile   WSconn=    WShandle=    alias=    consolealias=
${savecasepath}    ./jsoncase
&{WSproperties}    timeout=3    delay=10    retry=3
${fakerlocale}    zh_CN
&{SDKBVlist}    nicknamemin=${1}    nicknamemax=${100}    usernamemin=${1}    usernamemax=${64}    passwordmin=${1}    
@{deluserlist}
${testusernum}    2
&{GroupBVlist}    groupNamemax=${1024}    groupDescMax=${4096}    groupIdMax=${64}
${invalidLetters}    ~!@#$%^&*()+`={}|[]\:";'<>?,/
${validLetters}    _.-
${validString}    1234567890abcdefghijklmnopqrstuvwxyz_.-
${wayangprename}    1wayang
