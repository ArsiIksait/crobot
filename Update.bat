@echo off&Setlocal Enabledelayedexpansion
if /i "%1"=="download" (
attrib -R -A -S -H -I ǩ��.bat >nul 2>nul
echo Y|cacls �ļ���16����ת��.bat /p EVERYONE:F >nul 2>nul
cd.>Updateing.log
python download.py https://raw.githubusercontent.com/ArsiIksait/crobot/main/UpdateList.inf UpdateList.inf >nul
for /f "tokens=1,2* delims=> " %%i in (UpdateList.inf) do (
 if "%%i"=="[NEW]" (echo [NEW]&set UpdateState=0) else if "%%i"=="[REMOVE]" (echo [REMOVE]&set UpdateState=1) else if "%%i"=="[MOVE]" (echo [MOVE]&set UpdateState=2)
 for /f "tokens=1,2* delims=*" %%l in ("%%k") do (
  echo;[%%i] %%m %%j
  if "!UpdateState!"=="0" (call python download.py %%j %%l >nul)
  if "!UpdateState!"=="1" (call DEL /F /S /Q %%l%%j&call RD /S /Q %%l%%j) >nul 2>nul
  if "!UpdateState!"=="2" (call MOVE %%j %%l >nul 2>nul)
 )
)
del UpdateList.inf
exit /b
) else if /i "%1"=="getUpdateInfo" (
echo ���ڼ�����,���Ժ�...
python download.py https://raw.githubusercontent.com/ArsiIksait/crobot/main/UpdateInfo.inf UpdateInfo.inf >nul
for /f "eol=# tokens=1,2* delims==" %%i in (UpdateInfo.inf) do (
 if "%%i"=="New_Crobot_Version" (
  echo=%%j>newVer.inf
  for /f "tokens=1,2* delims=." %%a in (newVer.inf) do (
   if "%%a" GTR "%2" (
    set haveUpdate=true
	) else if "%%b" GTR "%3" (
	 set haveUpdate=true
	 ) else if "%%c" GTR "%4" (
	  set haveUpdate=true
	  )
   if "!haveUpdate!"=="true" (
    echo=���µĸ��¿���^^! ��ǰ�汾:[%2.%3.%4] �����汾:[%%j]
    )
   )
   del newVer.inf
  )
 )
) else (
exit /b
)
set haveUpdate=false
del UpdateInfo.inf
exit /b