@echo off

rem download and install the certs
echo Downloading Fog certs...


%~dp0wget.exe --no-check-certificate -O %~dp0ca.crt https://gateway.ed/ca.crt

rem install the certs
echo Installing OPE certs...

REM remove old certs
rem %~dp0certmgr.exe -del -c -n "ed" -s -r localMachine Root

REM add current cert
%~dp0certmgr.exe -add %~dp0ca.crt  -c -s -r localMachine root


echo Done.