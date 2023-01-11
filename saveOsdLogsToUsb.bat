@echo off
::===============================================================
::  Save a machine's SMSTS log files to a flash drive
::===============================================================

::create destination folder
set commandToRun=wmic bios get serialnumber /format:value
for /f "tokens=2 delims==" %%a in ('%commandToRun%') do set machineSerialNumber=%%a
mkdir %machineSerialNumber%

::destination location
cd %machineSerialNumber%
set destination=%cd%

::log file location
set logfileloc=X:\Windows\Temp\smstslog

::copy the logs
robocopy.exe %logfileloc% %destination%
