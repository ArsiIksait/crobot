@echo off&title CMD Robot
set thisVer1=1&set thisVer2=0&set thisVer3=0
if exist "Updateing.log" (del Updateing.log&echo ���³ɹ�! ��ǰ�汾:[%thisVer1%.%thisVer2%.%thisVer3%]&exit)
echo ��ӭʹ��CMD������,���ȵ�½��ʹ��!
echo.
:Start
echo:Login ��½ [L]    Register ע�� [R]    Exit �˳� [E]
choice /C "LRE" /D E /T 10 /M "����10��������ѡ��:"
if %ERRORLEVEL%==1 (cls&goto :Login)
if %ERRORLEVEL%==2 (cls&goto :Register)
if %ERRORLEVEL%==3 (cls&goto :Eof)
cls&echo:���ִ���,������ѡ��!&goto :Start
:Login
title CMD Robot - Login
if not exist "users" (MD users)
echo 
set /p account=Please Enter Account:
if "%account%"=="" (echo=�㲻������յ��˻�!&goto :Login)
set /p password=Please Enter Password:
if "%password%"=="" (echo=�㲻������յ�����!&goto :Login)
hash /string "%account%" /md5 /nh /hide>user.tmp
set /p user=<user.tmp&&del user.tmp
set user=%user: =%
hash /string "%password%" /sha1 /nh /hide>%user%.account.comp
echo.N|comp %CD%\users\%user%.account %CD%\%user%.account.comp|findstr "�ļ��Ƚ�����"&&(del %user%.account.comp&cls&echo ��½�ɹ�!&pause&goto :Main)||(del %user%.account.comp&cls&echo ��½ʧ��,�û������������!&pause&goto :Eof)
echo.������һ������!&pause&exit
:Register
title CMD Robot - Register
if not exist "users" (MD users)
echo 
set /p account=Please Enter Account:
if "%account%"=="" (echo=�㲻������յ��˻�!&goto :Register)
set /p password=Please Enter Password:
if "%password%"=="" (echo=�㲻������յ�����!&goto :Register)
hash /string "%account%" /md5 /nh /hide>user.tmp
set /p user=<user.tmp&&del user.tmp
set user=%user: =%
hash /string "%account%@%password%" /sha1 /nh /hide>users\%user%.account
echo ע��ɹ�! �����û��ļ��Ѵ����:%CD%\user\%user%.account
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
if "%1"=="cancel" (echo ��ȡ���˸���&del UpdateInfo.inf&exit /b)
if "%1"=="getUpdateInfo" (
echo ���ڼ�����,���Ժ�...
pget -u https://raw.githubusercontent.com/ArsiIksait/crobot/main/UpdateInfo.inf >nul
for /f "eol=# tokens=1,2* delims==" %%i in (UpdateInfo.inf) do (
 if "%%i"=="New_Crobot_Version" (
  echo=%%j>newVer.inf
  for /f "tokens=1,2* delims=." %%a in (newVer.inf) do (
   echo=��ǰ�汾:[%thisVer1%.%thisVer2%.%thisVer3%] �����汾:[%%j]
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
echo �������µİ汾,�Ƿ����?
choice /C "UC" /M "Update ����[U]	Cancel������[C]:"
if !ERRORLEVEL!==1 (call :Update download)
if !ERRORLEVEL!==2 (call :Update cancel)
)
echo ���!
pause&goto :Eof
