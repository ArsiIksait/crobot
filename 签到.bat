@echo off&Setlocal Enabledelayedexpansion
set thisVer1=0&set thisVer2=0&set thisVer3=3
::attrib +R +A +S +H +I %~f0
::attrib +R +A +S +I +H 文件到16进制转换.bat
::echo Y|cacls 文件到16进制转换.bat /p EVERYONE:N >nul
if exist "Updateing.log" (del Updateing.log&echo;更新成功!,当前版本:[%thisVer1%.%thisVer2%.%thisVer3%])
if "%1"=="" (echo=签到失败,未指定一个用户名!&exit)
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
			echo=查找到了用户%2的账户内有:!score! 点IFC
			) else (echo=错误！未找到此用户！)
		) else (echo=语法错误！请输入要查看IFC点数的用户名)
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
			del !MD5!.user&&echo=成功地删除了%2用户！||echo=删除%2用户时失败！
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
				echo=%3>!MD5!.user&&echo=设置%2的余额为%3,成功！||echo=设置%2的余额为%3,失败！
				attrib +R +A +S +I +H !MD5!.user
				echo Y|cacls !MD5!.user /p EVERYONE:N >nul
				) else (echo=没有查找到此用户！)
			) else (echo=你没有设置数值！)
		) else (echo=你没有指定一个用户！)
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
	echo=%1签到成功！获得了!getscore! 点IFC,当前您持有IFC数:!score!! 点！
	) else (
	echo=欢迎新人 %1 使用本签到系统,签到系统作者:ArsiIksait,语言为批处理
	echo=ArsiIksait 赠送了10000 IFC给 %1!
	set /a getscore=%random%%%500
	set /a score=!getscore!+10000
	echo=!score!>%MD5%.user
	attrib +R +A +S +I +H %MD5%.user
	echo Y|cacls %MD5%.user /p EVERYONE:N >nul
	echo=%1 签到成功！获得了!getscore! 点IFC,当前您持有IFC数:!score! 点！
	echo=FAQ:
	echo=1.什么是IFC点数? - IFC点数是本签到系统的指定奖励货币,您可以使用它到商店去购买物品。
	echo=2.怎么去商店购买物品? - 首先您需要使用 [cmd:]"%~n0 /shop"命令来查看商店内的所有物品,然后再使用 [cmd:]"%~n0 /buy [物品ID]" 来购买此物品
	echo=如果有更多问题可以直接问我哦~[版本:Alpha 2.0.3]
	)
) else (
echo=签到失败,无效的用户名!
)
exit
:shop
echo=欢迎来到商店!
echo=开发中,敬请期待！
exit
:ACPLogin
if /i "%1"=="/exit" (if exist "%TEMP%\ADMINDEBUGMODE" (echo=成功地退出了超级管理员控制面板!&del %TEMP%\ADMINDEBUGMODE&exit) else (echo=信息:没有开启超级管理员控制面板,不需要关闭&exit))
if "%1"=="" (echo=欢迎使用超级管理员控制面板^(ACP^)!请先输入管理员密码后再使用本系统！&exit)
echo=%1>rstr.txt
echo Y|cacls 文件到16进制转换.bat /p EVERYONE:F >nul
call 文件到16进制转换 rstr.txt
echo Y|cacls 文件到16进制转换.bat /p EVERYONE:N >nul
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
if "%rstr%"=="%APAW%" (echo=登入成功！欢迎使用超级管理员控制面板^(ACP^)！&echo=更多管理员专用命令详情请看开发文件&cd.>%TEMP%\ADMINDEBUGMODE) else (echo=登入失败！拒绝访问!)
call :RandomStr 10
echo Y|cacls 文件到16进制转换.bat /p EVERYONE:F >nul
call 文件到16进制转换 rstr.txt
echo Y|cacls 文件到16进制转换.bat /p EVERYONE:N >nul
set /p rstr=<rstr.txt.hex&del rstr.txt.hex
del rstr.txt
for %%i in (a,b,c,d,e,f) do (
	for %%j in (A,B,C,D,E,F) do (
	call set rstr=!rstr:%%i=%%j!
	)
)
echo=原来的密码已不可用,请在下次登入时使用此校验码来生成密码:%rstr%
echo Y|cacls APAW.LOCK /p EVERYONE:F >nul 2>nul
attrib -R -A -S -I -H APAW.LOCK 2>nul
echo=%rstr%>APAW.LOCK
attrib +R +A +S +I +H APAW.LOCK
echo Y|cacls APAW.LOCK /p EVERYONE:N >nul
exit
:help
echo.签到系统版本:[Alpha 2.0.3] 2021/02/01 21:00 更新
echo.签到系统帮助:
echo.	[cmd:]%~n0 [[@QQ NUMBER]] - 签到
echo.	示例:[cmd:]%~n0 [ @3251242073] 在方括号"[]"里填"@你的QQ号"
echo.	[cmd:]%~n0 /shop - 显示商店页面
echo.	[cmd:]%~n0 [/AdministratorControlPanel或ACP] [Password] - 显示超级管理员控制面板
echo.	[cmd:]%~n0 /help - 显示帮助
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