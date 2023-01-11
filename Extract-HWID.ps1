<#

Run the code block that extracts the HWID from DTE instructions
    -this puts a "HWID" folder in the C:\.


Name the HWID folder the serial number of the laptop

Name the CSV file the serial numer of the laptop

Add to the end of the first line
    -Add “,Group Tag” to the end of the line

Add to the end of the 2nd line
    -Add “,AutoPilot_Azure” to the end of the line


10/10 would be ideal if this would import into intune too...


#>

#this code snippet was the one first shared to the group
#extracts the HWID using Microsoft's script and puts it in the root directory
mkdir C:\HWID
Set-Location C:\HWID
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force
Install-Script -Name Get-WindowsAutopilotInfo -Force
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Get-WindowsAutopilotInfo.ps1 -OutputFile AutopilotHWID.csv


#grab the contents of the original HWID file
$filePath = ".\AutoPilotHWID.csv"
$fileContents = Get-Content $filePath


#query wmic for the machine's serial number
$serialNumber = wmic bios get serialNumber
$serialNumber = $serialNumber[2]
#remove white space
$serialNumber = $serialNumber.Replace(" ","")


#HWID csv file is just two lines, assigning each line to variables
$firstLine = $fileContents[0]
$secondLine = $fileContents[1]


#adding the requirements to the end of the first line (",Group Tag")
$firstLine = $firstLine + ",Group Tag"
#adding the requirements to the end of the second line (",AutoPilot_Azure")
$secondLine = $secondLine + ",AutoPilot_Azure"


#creating the new HWID.csv and including the machine serial in the name
$newHWIDfile = "HWID_$serialNumber.csv"
$firstLine | Out-File $newHWIDfile
Add-Content -Path $newHWIDfile -Value $secondLine


#rename HWID.CSV parent folder to include the machine's serial number
Set-Location C:\
Rename-Item .\HWID "HWID_$serialNumber"
$renamedHWIDfolder = "HWID_$serialNumber"

#save folder to flash drive
#query for storage that's drive type 2 (removable)
$removeableStorageDrives = Get-WmiObject win32_logicaldisk | Where-Object {$_.DriveType -eq '2'}


#flash drive Drive letter 
$flashDriveDestination = $removeableStorageDrives.DeviceID


#copying the folder and file to the flash drive
Copy-Item -Path $renamedHWIDfolder -Destination $flashDriveDestination -Recurse -Verbose
