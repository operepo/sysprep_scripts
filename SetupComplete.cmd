REM Create SetupComplete.cmd (C:\Windows\Setup\Scripts\SetupComplete.cmd)
echo Running SetupComplete.cmd
rem disable ipv6 - interferes w joining domains in some cases - set back to 0 to enable (windows default)
rem reg add HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters /v DisabledComponents /t REG_DWORD /d 0xff /f

rem make sure we don't have hibernate enabled
powercfg /H off

rem disable firstboot user after done
rem NET USER firstboot /active:no

rem reboot
rem NOTE NOTE NOTE - if this runs as a proper SetupComplete script, don't reboot here!
rem if it runs as a user startup script, then reboot should be ok
rem if NOT "%1%"=="reboot" goto skipreboot
	rem echo "Rebooting..."
rem	shutdown /r /t 1
rem :skipreboot


rem import app associations
DISM /online /import-defaultappassociations:..\sysprep_scripts\AppAssoc.xml

REM force KMS server activation for win/office
cscript c:\windows\system32\slmgr.vbs /ato
cscript c:\Program Files\Microsoft Office\Office16\ospp.vbs /act

rem make sure fog service is enabled
sc config FOGService start=delayed-auto
rem download and install the certs for the fog service
echo Downloading Fog certs...
..\sysprep_scripts\wget.exe -O ..\sysprep_scripts\srvpublic.crt http://fog.ed/fog/management/other/ssl/srvpublic.crt
..\sysprep_scripts\wget.exe -O ..\sysprep_scripts\ca.cert.der http://fog.ed/fog/management/other/ca.cert.der

rem install the certs
echo Installing Fog certs...
REM remove old certs
..\sysprep_scripts\certmgr.exe -del -c -n "FOG Project" -s -r localMachine Root
..\sysprep_scripts\certmgr.exe -del -c -n "FOG Server CA" -s -r localMachine Root

..\sysprep_scripts\certmgr.exe -add ..\sysprep_scripts\ca.cert.der -c -s -r localMachine root
rem ..\sysprep_scripts\certmgr.exe -add ca.cert.der -c -s -r localMachine trustedpublisher
..\sysprep_scripts\certmgr.exe -add ..\sysprep_scripts\srvpublic.crt -c -s -r localMachine root
rem ..\sysprep_scripts\certmgr.exe -add srvpublic.crt -c -s -r localMachine trustedpublisher

net start FOGService

echo SetupComplete.cmd Finished.