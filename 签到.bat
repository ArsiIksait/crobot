@echo off&Setlocal Enabledelayedexpansion
::attrib +R %~f0
if "%1"=="" (set /p a=������Ҫǩ�����û���:) else (set a=%1)
if "%a%"=="" (echo=ǩ��ʧ��,δָ��һ���û���!&exit)
if "%a%"=="/shop" (goto :shop)
if exist "%TEMP%\ADMINDEBUGMODE" (
	if "%a%"=="/Admin:Show" (
		if not "%2"=="" (
			echo=%2>md5tmp.txt
			call :getMD5 md5tmp.txt
			del md5tmp.txt
			if exist "!MD5!.user" (
			echo Y|cacls !MD5!.user /p EVERYONE:F >nul
			attrib -R -H !MD5!.user
			set /p score=<!MD5!.user
			attrib +R +H !MD5!.user
			echo Y|cacls !MD5!.user /p EVERYONE:N >nul
			echo=���ҵ����û�%2���˻�����:!score! ��IFC
			) else (echo=����δ�ҵ����û���)
		) else (echo=�﷨����������Ҫ�鿴IFC�������û���)
	exit
	)
	if "%a%"=="/Admin:Delete" (
		if not "%2"=="" (
			echo=%2>md5tmp.txt
			call :getMD5 md5tmp.txt
			del md5tmp.txt
			if exist "!MD5!.user" (
			echo Y|cacls !MD5!.user /p EVERYONE:F >nul
			attrib -R -H !MD5!.user
			del !MD5!.user&&echo=�ɹ���ɾ����%2�û���||echo=ɾ��%2�û�ʱʧ�ܣ�
			)
		)
	exit
	)
	if "%a%"=="/Admin:Set" (
		if not "%2"=="" (
			if not "%3"=="" (
			echo=%2>md5tmp.txt
			call :getMD5 md5tmp.txt
			del md5tmp.txt
				if exist "!MD5!.user" (
				echo Y|cacls !MD5!.user /p EVERYONE:F >nul
				attrib -R -H !MD5!.user
				echo=%3>!MD5!.user&&echo=����%2�����Ϊ%3,�ɹ���||echo=����%2�����Ϊ%3,ʧ�ܣ�
				) else (echo=û�в��ҵ����û���)
			) else (echo=��û��������ֵ��)
		) else (echo=��û��ָ��һ���û���)
	exit
	)
)
if "%a%"=="/AdministratorControlPanel" (call :ACPLogin %2) else if "%a%"=="/ACP" (call :ACPLogin %2)
if "%a%"=="/help" (goto :help) else if "%a%"=="/?" (goto :help)
echo=%a%>tmp.txt
findstr "[0-9-A-Z]" tmp.txt>nul&&set b=true||set b=false
call :getMD5 tmp.txt
del tmp.txt
if "%b%"=="true" (
	if exist "%MD5%.user" (
	echo Y|cacls %MD5%.user /p EVERYONE:F >nul
	attrib -R -H %MD5%.user
	set /p score=<%MD5%.user
	set /a getscore=%random%%%500
	set /a score+=!getscore!
	echo=!score!>%MD5%.user
	attrib +R +H %MD5%.user
	echo Y|cacls %MD5%.user /p EVERYONE:N >nul
	echo=%a%ǩ���ɹ��������!getscore! ��IFC,��ǰ������IFC��:!score!! �㣡
	) else (
	echo=��ӭ���� %a% ʹ�ñ�ǩ��ϵͳ,ǩ��ϵͳ����:ArsiIksait,����Ϊ������
	echo=ArsiIksait ������10000 IFC�� %a%!
	set /a getscore=%random%%%500
	set /a score=!getscore!+10000
	echo=!score!>%MD5%.user
	attrib +R +H +I %MD5%.user
	echo Y|cacls %MD5%.user /p EVERYONE:N >nul
	echo=%a% ǩ���ɹ��������!getscore! ��IFC,��ǰ������IFC��:!score! �㣡
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
echo=��ǰ�̵���û����Ʒ,��Ϊ����Alpha�����汾��3�棬��ʱ��֧��һЩ�����淨,���ǻ������Ľ�,�����µ��淨��!
exit
:ACPLogin
if "%1"=="/exit" (if exist "%TEMP%\ADMINDEBUGMODE" (echo=�ɹ����˳��˳�������Ա�������!&del %TEMP%\ADMINDEBUGMODE&exit) else (echo=��Ϣ:û�п�����������Ա�������,����Ҫ�ر�&exit))
if "%1"=="" (echo=��ӭʹ�ó�������Ա�������^(ACP^)!�����������Ա�������ʹ�ñ�ϵͳ��&exit)
echo=%1>rstr.txt
call �ļ���16����ת�� rstr.txt
set /p rstr=<rstr.txt.hex&del rstr.txt.hex
for %%i in (a,b,c,d,e,f) do (
	for %%j in (A,B,C,D,E,F) do (
	call set rstr=!rstr:%%i=%%j!
	)
)
if exist "APAW.LOCK" (
echo Y|cacls APAW.LOCK /p EVERYONE:F >nul
attrib -R -H APAW.LOCK
set /p APAW=<APAW.LOCK
attrib +R +H +I APAW.LOCK
echo Y|cacls APAW.LOCK /p EVERYONE:N >nul
)
if "%rstr%"=="%APAW%" (echo=����ɹ�����ӭʹ�ó�������Ա�������^(ACP^)��&echo=�������Աר�����������뿴�����ļ�&cd.>%TEMP%\ADMINDEBUGMODE) else (echo=����ʧ�ܣ��ܾ�����!)
call :RandomStr 10
call �ļ���16����ת�� rstr.txt
set /p rstr=<rstr.txt.hex&del rstr.txt.hex
for %%i in (a,b,c,d,e,f) do (
	for %%j in (A,B,C,D,E,F) do (
	call set rstr=!rstr:%%i=%%j!
	)
)
echo=ԭ���������Ѳ�����,�����´ε���ʱʹ�ô�У��������������:%rstr%
echo Y|cacls APAW.LOCK /p EVERYONE:F >nul
attrib -R -H APAW.LOCK
echo=%rstr%>APAW.LOCK
attrib +R +H +I APAW.LOCK
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