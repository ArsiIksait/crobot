@echo off&Setlocal Enabledelayedexpansion
set thisVer1=0&set thisVer2=0&set thisVer3=3
::attrib +R +A +S +H +I %~f0
::attrib +R +A +S +I +H �ļ���16����ת��.bat
::echo Y|cacls �ļ���16����ת��.bat /p EVERYONE:N >nul
if exist "Updateing.log" (del Updateing.log&echo;���³ɹ�!,��ǰ�汾:[%thisVer1%.%thisVer2%.%thisVer3%])
if "%1"=="" (echo=ǩ��ʧ��,δָ��һ���û���!&exit)
if "%1"=="/shop" (call :shop %2)
if exist "%TEMP%\ADMINDEBUGMODE" (
	if /i "%1"=="/Admin:Show" (
		if not "%2"=="" (
			echo=%2>md5tmp.txt
			call :getMD5 md5tmp.txt
			del md5tmp.txt
			if exist "!MD5!.user" (
			echo Y|cacls !MD5!.user /p EVERYONE:F >nul
			set /p score=<!MD5!.user
			echo Y|cacls !MD5!.user /p EVERYONE:N >nul
			echo=���ҵ����û�%2���˻�����:!score! ��IFC
			) else (echo=����δ�ҵ����û���)
		) else (echo=�﷨����������Ҫ�鿴IFC�������û���)
	exit
	)
	if /i "%1"=="/Admin:Delete" (
		if not "%2"=="" (
			echo=%2>md5tmp.txt
			call :getMD5 md5tmp.txt
			del md5tmp.txt
			if exist "!MD5!.user" (
			echo Y|cacls !MD5!.user /p EVERYONE:F >nul
			attrib -R -A -S -I -H !MD5!.user
			del !MD5!.user&&echo=�ɹ���ɾ����%2�û���||echo=ɾ��%2�û�ʱʧ�ܣ�
			)
		)
	exit
	)
	if /i "%1"=="/Admin:Set" (
		if not "%2"=="" (
			if not "%3"=="" (
			echo=%2>md5tmp.txt
			call :getMD5 md5tmp.txt
			del md5tmp.txt
				if exist "!MD5!.user" (
				echo Y|cacls !MD5!.user /p EVERYONE:F >nul
				attrib -R -A -S -I -H !MD5!.user
				echo=%3>!MD5!.user&&echo=����%2�����Ϊ%3,�ɹ���||echo=����%2�����Ϊ%3,ʧ�ܣ�
				attrib +R +A +S +I +H !MD5!.user
				echo Y|cacls !MD5!.user /p EVERYONE:N >nul
				) else (echo=û�в��ҵ����û���)
			) else (echo=��û��������ֵ��)
		) else (echo=��û��ָ��һ���û���)
	exit
	)
	if /i "%1"=="/Update:GetUpdateInfo" (
		call Update.bat GetUpdateInfo %thisVer1% %thisVer2% %thisVer3%
	exit
	)
	if /i "%1"=="/Update:Download" (
		cmd /c Update.bat Download
	exit
	)
)
if /i "%1"=="/AdministratorControlPanel" (call :ACPLogin %2) else if /i "%1"=="/ACP" (call :ACPLogin %2)
if /i "%1"=="/help" (goto :help) else if "%1"=="/?" (goto :help)
echo=%1>tmp.txt
findstr "[0-9-A-Z]" tmp.txt>nul&&set b=true||set b=false
call :getMD5 tmp.txt
del tmp.txt
if "%b%"=="true" (
	if exist "%MD5%.user" (
	echo Y|cacls %MD5%.user /p EVERYONE:F >nul
	attrib -R -A -S -I -H %MD5%.user
	set /p score=<%MD5%.user
	set /a getscore=%random%%%500
	set /a score+=!getscore!
	echo=!score!>%MD5%.user
	attrib +R +A +S +I +H %MD5%.user
	echo Y|cacls %MD5%.user /p EVERYONE:N >nul
	echo=%1ǩ���ɹ��������!getscore! ��IFC,��ǰ������IFC��:!score!! �㣡
	) else (
	echo=��ӭ���� %1 ʹ�ñ�ǩ��ϵͳ,ǩ��ϵͳ����:ArsiIksait,����Ϊ������
	echo=ArsiIksait ������10000 IFC�� %1!
	set /a getscore=%random%%%500
	set /a score=!getscore!+10000
	echo=!score!>%MD5%.user
	attrib +R +A +S +I +H %MD5%.user
	echo Y|cacls %MD5%.user /p EVERYONE:N >nul
	echo=%1 ǩ���ɹ��������!getscore! ��IFC,��ǰ������IFC��:!score! �㣡
	echo=FAQ:
	echo=1.ʲô��IFC����? - IFC�����Ǳ�ǩ��ϵͳ��ָ����������,������ʹ�������̵�ȥ������Ʒ��
	echo=2.��ôȥ�̵깺����Ʒ? - ��������Ҫʹ�� [cmd:]"%~n0 /shop"�������鿴�̵��ڵ�������Ʒ,Ȼ����ʹ�� [cmd:]"%~n0 /buy [��ƷID]" ���������Ʒ
	echo=����и����������ֱ������Ŷ~[�汾:Alpha 2.0.3]
	)
) else (
echo=ǩ��ʧ��,��Ч���û���!
)
exit
:shop
echo=��ӭ�����̵�!
echo=������,�����ڴ���
exit
:ACPLogin
if /i "%1"=="/exit" (if exist "%TEMP%\ADMINDEBUGMODE" (echo=�ɹ����˳��˳�������Ա�������!&del %TEMP%\ADMINDEBUGMODE&exit) else (echo=��Ϣ:û�п�����������Ա�������,����Ҫ�ر�&exit))
if "%1"=="" (echo=��ӭʹ�ó�������Ա�������^(ACP^)!�����������Ա�������ʹ�ñ�ϵͳ��&exit)
echo=%1>rstr.txt
echo Y|cacls �ļ���16����ת��.bat /p EVERYONE:F >nul
call �ļ���16����ת�� rstr.txt
echo Y|cacls �ļ���16����ת��.bat /p EVERYONE:N >nul
set /p rstr=<rstr.txt.hex&del rstr.txt.hex
for %%i in (a,b,c,d,e,f) do (
	for %%j in (A,B,C,D,E,F) do (
	call set rstr=!rstr:%%i=%%j!
	)
)
if exist "APAW.LOCK" (
echo Y|cacls APAW.LOCK /p EVERYONE:F >nul
attrib -R -A -S -I -H APAW.LOCK
set /p APAW=<APAW.LOCK
attrib +R +A +S +I +H APAW.LOCK
echo Y|cacls APAW.LOCK /p EVERYONE:N >nul
)
if "%rstr%"=="%APAW%" (echo=����ɹ�����ӭʹ�ó�������Ա�������^(ACP^)��&echo=�������Աר�����������뿴�����ļ�&cd.>%TEMP%\ADMINDEBUGMODE) else (echo=����ʧ�ܣ��ܾ�����!)
call :RandomStr 10
echo Y|cacls �ļ���16����ת��.bat /p EVERYONE:F >nul
call �ļ���16����ת�� rstr.txt
echo Y|cacls �ļ���16����ת��.bat /p EVERYONE:N >nul
set /p rstr=<rstr.txt.hex&del rstr.txt.hex
del rstr.txt
for %%i in (a,b,c,d,e,f) do (
	for %%j in (A,B,C,D,E,F) do (
	call set rstr=!rstr:%%i=%%j!
	)
)
echo=ԭ���������Ѳ�����,�����´ε���ʱʹ�ô�У��������������:%rstr%
echo Y|cacls APAW.LOCK /p EVERYONE:F >nul 2>nul
attrib -R -A -S -I -H APAW.LOCK 2>nul
echo=%rstr%>APAW.LOCK
attrib +R +A +S +I +H APAW.LOCK
echo Y|cacls APAW.LOCK /p EVERYONE:N >nul
exit
:help
echo.ǩ��ϵͳ�汾:[Alpha 2.0.3] 2021/02/01 21:00 ����
echo.ǩ��ϵͳ����:
echo.	[cmd:]%~n0 [[@QQ NUMBER]] - ǩ��
echo.	ʾ��:[cmd:]%~n0 [ @3251242073] �ڷ�����"[]"����"@���QQ��"
echo.	[cmd:]%~n0 /shop - ��ʾ�̵�ҳ��
echo.	[cmd:]%~n0 [/AdministratorControlPanel��ACP] [Password] - ��ʾ��������Ա�������
echo.	[cmd:]%~n0 /help - ��ʾ����
exit
:RandomStr
setlocal enabledelayedexpansion
set str=0123456789
for /l %%a in (1,1,%1) do call :slz "%%a"
echo=!random_str!>rstr.txt
exit /b
:slz
if "%~1"=="" exit /b %random_str%
set /a r=%random%%%9
set random_str=%random_str%!str:~%r%,1!
exit /b
:getMD5
set para1=%~1
certutil -hashfile %~s1 MD5 2>nul| find /v ":" > %para1%.md5
set /p MD5=<%para1%.md5&del %para1%.md5
set MD5=%MD5: =%
exit /b %MD5%