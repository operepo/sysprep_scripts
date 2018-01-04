@echo off

echo Running - fix_fog_service.cmd > %programdata%\ope\setupcomplete.log

rem make sure fog service is enabled
net stop FOGService
sc config FOGService start=delayed-auto
del /F "C:\Program Files (x86)\FOG\token.dat"
rem download and install the certs for the fog service
echo Downloading Fog certs...
%windir%\setup\sysprep_scripts\wget.exe -O %windir%\setup\sysprep_scripts\srvpublic.crt http://fog.ed/fog/management/other/ssl/srvpublic.crt
%windir%\setup\sysprep_scripts\wget.exe -O %windir%\setup\sysprep_scripts\ca.cert.der http://fog.ed/fog/management/other/ca.cert.der

rem install the certs
echo Installing Fog certs...
REM remove old certs
%windir%\setup\sysprep_scripts\certmgr.exe -del -c -n "FOG Project" -s -r localMachine Root
%windir%\setup\sysprep_scripts\certmgr.exe -del -c -n "FOG Server CA" -s -r localMachine Root

%windir%\setup\sysprep_scripts\certmgr.exe -add %windir%\setup\sysprep_scripts\ca.cert.der -c -s -r localMachine root
rem %windir%\setup\sysprep_scripts\certmgr.exe -add ca.cert.der -c -s -r localMachine trustedpublisher
%windir%\setup\sysprep_scripts\certmgr.exe -add %windir%\setup\sysprep_scripts\srvpublic.crt -c -s -r localMachine root
rem %windir%\setup\sysprep_scripts\certmgr.exe -add srvpublic.crt -c -s -r localMachine trustedpublisher

net start FOGService

echo Done - fix_fog_service.cmd > %programdata%\ope\setupcomplete.log