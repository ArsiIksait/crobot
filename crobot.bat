@echo off&title CMD Robot
set thisVer1=1&set thisVer2=0&set thisVer3=0
if exist "Updateing.log" (del Updateing.log&echo 更新成功! 当前版本:[%thisVer1%.%thisVer2%.%thisVer3%]&exit)
echo 欢迎使用CMD机器人,请先登陆再使用!
echo.
:Start
echo:Login 登陆 [L]    Register 注册 [R]    Exit 退出 [E]
choice /C "LRE" /D E /T 10 /M "请在10秒内做出选择:"
if %ERRORLEVEL%==1 (cls&goto :Login)
if %ERRORLEVEL%==2 (cls&goto :Register)
if %ERRORLEVEL%==3 (cls&goto :Eof)
cls&echo:出现错误,请重新选择!&goto :Start
:Login
title CMD Robot - Login
if not exist "users" (MD users)
echo 
set /p account=Please Enter Account:
if "%account%"=="" (echo=你不能输入空的账户!&goto :Login)
set /p password=Please Enter Password:
if "%password%"=="" (echo=你不能输入空的密码!&goto :Login)
hash /string "%account%" /md5 /nh /hide>user.tmp
set /p user=<user.tmp&&del user.tmp
set user=%user: =%
hash /string "%password%" /sha1 /nh /hide>%user%.account.comp
echo.N|comp %CD%\users\%user%.account %CD%\%user%.account.comp|findstr "文件比较无误"&&(del %user%.account.comp&cls&echo 登陆成功!&pause&goto :Main)||(del %user%.account.comp&cls&echo 登陆失败,用户名或密码错误!&pause&goto :Eof)
echo.出现了一个错误!&pause&exit
:Register
title CMD Robot - Register
if not exist "users" (MD users)
echo 
set /p account=Please Enter Account:
if "%account%"=="" (echo=你不能输入空的账户!&goto :Register)
set /p password=Please Enter Password:
if "%password%"=="" (echo=你不能输入空的密码!&goto :Register)
hash /string "%account%" /md5 /nh /hide>user.tmp
set /p user=<user.tmp&&del user.tmp
set user=%user: =%
hash /string "%account%@%password%" /sha1 /nh /hide>users\%user%.account
echo 注册成功! 您的用户文件已存放至:%CD%\user\%user%.account
pause&start %~f0&exit
:Update
title CMD Robot - Update
if "%1"=="download" (
cd.>Updateing.log
title CMD Robot - Update: Download
pget -u https://raw.githubusercontent.com/ArsiIksait/crobot/main/UpdateList.inf >nul
for /f "tokens=1,2* delims=> " %%i in (UpdateList.inf) do (
title CMD Robot - Update: Downloading.
 if "%%i"=="[NEW]" (echo [NEW]&set UpdateState=0) else if "%%i"=="[REMOVE]" (echo [REMOVE]&set UpdateState=1) else if "%%i"=="[MOVE]" (echo [MOVE]&set UpdateState=2)
 for /f "tokens=1,2* delims=*" %%l in ("%%k") do (
 title CMD Robot - Update: Downloading..
  rem echo I=%%i J=%%j L=%%l M=%%m
  echo;[%%i] %%m %%j
  if "!UpdateState!"=="0" (call pget -u %%j -r %%l>nul)
  if "!UpdateState!"=="1" (call DEL /F /S /Q %%l%%j&call RD /S /Q %%l%%j) >nul 2>nul
  if "!UpdateState!"=="2" (call MOVE %%j %%l >nul 2>nul)
  title CMD Robot - Update: Download...
 )
)
del UpdateList.inf
del UpdateInfo.inf
title CMD Robot - Update: Done
exit /b
)
if "%1"=="cancel" (echo 您取消了更新&del UpdateInfo.inf&exit /b)
if "%1"=="getUpdateInfo" (
echo 正在检查更新,请稍后...
pget -u https://raw.githubusercontent.com/ArsiIksait/crobot/main/UpdateInfo.inf >nul
for /f "eol=# tokens=1,2* delims==" %%i in (UpdateInfo.inf) do (
 if "%%i"=="New_Crobot_Version" (
  echo=%%j>newVer.inf
  for /f "tokens=1,2* delims=." %%a in (newVer.inf) do (
   echo=当前版本:[%thisVer1%.%thisVer2%.%thisVer3%] 储存库版本:[%%j]
    set haveUpdate=true
   )
   del newVer.inf
  )
 )
)
exit /b
:Main
cls
Setlocal Enabledelayedexpansion
call :Update getUpdateInfo
title CMD Robot - Main
if "%haveUpdate%"=="true" (
echo 发现了新的版本,是否更新?
choice /C "UC" /M "Update 更新[U]	Cancel不更新[C]:"
if !ERRORLEVEL!==1 (call :Update download)
if !ERRORLEVEL!==2 (call :Update cancel)
)
echo 完成!
pause&goto :Eof
