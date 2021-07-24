@echo off
if "%1"=="" goto :function
if "%~x1"==".bat" (
 for /f "delims=" %%i in (%~s2) do (call :function %%i)
 goto :function
)
%1>nul mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 :: %1","","runas",1)(window.close)&&goto function
call :function %2 %3 %4 %5 %6 %7 %8 %9
:function
%1 %2 %3 %4 %5 %6 %7 %8 %9