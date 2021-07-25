@echo off&Setlocal Enabledelayedexpansion&color 0A
::签到模块专用精简版文件到16进制转换
certutil -encodehex "%~s1" "%~nx1.hex.temp" >nul 2>nul
for /f "tokens=1,2* usebackq delims=	" %%i in ("%~nx1.hex.temp") do (
set str=%%j
set str=!str:~0,48!
set str=!str: =!
echo.!str!>>%~nx1.hex
)
del /q %~nx1.hex.temp
if "%Delete_original_file%"=="true" (del /q %~nx1)
exit /b