<#
Unlocks a DTS tech administrative AB account
#>
Clear-Host
$userInput = Read-Host "Provide a Firstname and Lastname`nI'll unlock their AB account"

try {
    Clear-Host
    $foundName = Get-ADUser -Filter { Name -eq $userInput } | Select-Object SamAccountName
    $foundName = $foundName.SamAccountName
    $abAccount = "ab$foundName"

    $lockStatus = Get-ADUser -Identity $abAccount -Properties * | Select-Object LockedOut
    $lockStatus = $lockStatus.LockedOut
    #account is locked
    if ($lockStatus -ne $false) {
        Write-Host "The account LockedOut status is currently: True`nEnter your credentials and I'll unlock the account now!" -ForegroundColor Yellow
        $credentials = Get-Credential -Message "Give me creds"
        Unlock-ADAccount -Identity $abAccount -Credential $credentials
        Write-Host "The account is now unlocked,You're welcome." -ForegroundColor Green
    }

    #account is unlocked
    if ($lockStatus -ne $true) {
        Write-Host "The account is not locked..." -ForegroundColor Yellow
    }

}
catch{
    Write-Warning "An error has occurred, ABORTING MISSION"
    Break
}

#final check
$lockStatus = Get-ADUser -Identity $abAccount -Properties * | Select-Object LockedOut
$lockStatus = $lockStatus.LockedOut
Write-host "The Account LockedOut Status is:$lockstatus" -ForegroundColor Yellow

