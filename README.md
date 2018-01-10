# sysprep_scripts
Scripts for prepping win 10 desktop for sysprep and deployment via fogserver

ErrorHandler.cmd - Script to log if there is an error after initial boot

SetupComplete.cmd - Runs after initial boot - used to turn fog service on and other post install scripts

Step1.cmd - Run on win image to help prep it for sysprep - general options like uninstall win apps, compact os, etc...

Step2.cmd - Final steps just before and including actual sysprep command. Will shut down computer so you can capture.

fix_fog_service.cmd - remove existing fog certificates, and download/add new certs before enabling service again. Run by SetupComplete.cmd

win10_fix.cmd - fix commands for corrupted win install - sfc, etc...

