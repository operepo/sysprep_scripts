REM Create SetupComplete.cmd (C:\Windows\Setup\Scripts\SetupComplete.cmd)
echo Running - SetupComplete.cmd > %programdata%\ope\setupcomplete.log
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
DISM /online /import-defaultappassociations:%windir%\setup\sysprep_scripts\AppAssoc.xml

REM force KMS server activation for win/office
cscript c:\windows\system32\slmgr.vbs /ato
cscript c:\Program Files\Microsoft Office\Office16\ospp.vbs /act

rem make sure fog service works
%windir%\setup\sysprep_scripts\fix_fog_service.cmd


echo SetupComplete.cmd Finished.
echo Done - SetupComplete.cmd > %programdata%\ope\setupcomplete.log
