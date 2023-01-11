<#
.SYNOPSIS
Set the user property: CHANGE PASSWORD AT LOGON to Disable
Can choose [f] to feed a .txt file of usernames
.Notes
Author: Danny
#>


Write-Host "DISABLE 'Change Password At Logon' for a user" -ForegroundColor Yellow
$userInput = Read-Host "`nGive me a username`nPress [f] to provide .txt file"


#File Explorer window will open to allow  choosing of .txt file
#.txt file needs to have only one username per line
if ($userInput -eq 'f') {
    Add-Type -AssemblyName System.Windows.Forms
    $chosenFile = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = $PWD 
        Filter           = "txt files (*.txt)|*.txt"
        Title            = 'SELECT A .TXT FILE WITH 1 USERNAME PER LINE'
    }

    $null = $chosenFile.ShowDialog()
    $filename = $chosenFile.FileName
    $openfile = Get-Content $filename


    #read usernames line by line
    foreach ($user in $openfile) {
        $username = Get-ADUser $user -Server DURDC002 | Select-Object Name  
        $username = $username.name
        Write-Host "Disabling $username to change password at next logon" -ForegroundColor Green
        Set-ADUser -Identity $user -ChangePasswordAtLogon $false -Verbose  -Server DURDC002
    }

}


#if a text file isn't fed to this script then it will just continously ask for usernames, one at a time.
else {
    $username = Get-ADUser $userInput -Server DURDC002 | Select-Object Name


    #checking if user exists (with !(not) operator), error will terminate script
    if (!$?) {
        Write-Host $error[0]"`nTry running this again" -ForegroundColor Red
    }

    else {
        $username = $username.name
        Write-Host "`nSetting $username to NOT change password at next logon" -ForegroundColor Green
        Set-ADUser -Identity $userInput -ChangePasswordAtLogon $false -Verbose  -Server DURDC002

        do {
            $userInput = Read-Host "Provide me another username OR Press [q] to quit"

            if ($userInput -ne 'q') {
                $username = Get-ADUser $userInput -Server DURDC002 | Select-Object Name
                $username = $username.name
                Write-Host "`nSetting $username to NOT change password at next logon" -ForegroundColor Green
                Set-ADUser -Identity $userInput -ChangePasswordAtLogon $false -Verbose  -Server DURDC002
            }

        }

        until ($userInput -eq 'q')
    }
    
}