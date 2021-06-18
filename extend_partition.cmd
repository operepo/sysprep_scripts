@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION


set tfile=%temp%\runasuac.vbs
rem check if we have UAC permissions
rem >nul 2>&1 "%SYSTEMROOT%\system32\icacls.exe" "%SYSTEMROOT%\system32\config\system"
NET FILE 1>NUL 2>NUL

rem error flag set = no admin priv
if '%errorlevel%' NEQ '0' (
    rem echo Not admin...
    rem pause
    goto switchToUAC
) else ( goto isAlreadyUAC )

echo Why are you here - this is a bug - please report it
pause

:switchToUAC
    echo Not UAC - Switching to UAC...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%tfile%"
    echo args = "/C %~s0 %*" >> "%tfile%"
    echo For Each strArg in WScript.Arguments >> "%tfile%"
    echo   args = args ^& strArg ^& " " >> "%tfile%"
    echo Next >> "%tfile%"
    echo UAC.ShellExecute "cmd.exe", args, "", "runas", 1 >> "%tfile%"
    
    rem wscript "%tfile%" %*
    wscript "%tfile%"
    rem echo Params  %*
    rem pause
    exit /B
    
:isAlreadyUAC
    rem echo Alread Running with UAC...
    rem pause
    if exist "%tfile%" ( del "%tfile%" )
    pushd "%CD%"
    cd /D "%~dp0"
    rem pause



rem assign a tmp file
set partfile=%temp%\aa11aa.txt

set disk=%systemdrive%
set vol_num=-1

rem Get the volumes - find the one that matches the system drive
for /F "tokens=2,3" %%A in ('echo list vol ^|diskpart') do (
    set vnum=%%A
    set drive=%%B
    rem echo !drive!
    if "%disk%" == "!drive!:" (
        echo found system volume.
        set vol_num=!vnum!
    )
    rem echo !vol_num! !drive!
    
)

if !vol_num! == -1 (
    echo Volume not found!
    exit /b
) else (
    rem give it a go
    echo Expanding Vol: !vol_num!
    echo select volume !vol_num! > %partfile%
    echo extend >> %partfile%

    diskpart /s %partfile%
)

echo Finished.
pause
exit /b
