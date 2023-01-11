<#
.SYNOPSIS
Retreive the stored key (password) for a network profile on the system
.Notes
Will only work with network profiles that have a stored key.
Author: Danny
#>



Clear-Host
$outputArray = netsh wlan show profiles
$bucket = [System.Collections.ArrayList]@()

#fetches only the lines that contain the user profile name
foreach ($item in $outputArray) {

    if ($item.Contains("All User Profile")) {
        $bucket.Add($item) > $null
    }


}


#isolate the profile names
for ($i = 0; $i -lt $bucket.Count; $i++) {
    $bucket[$i] = $bucket[$i].Trim("    All User Profile     :")
}


#create the menu
$hashTable = @{}
for ($i = 0; $i -lt $bucket.Count; $i++) {
    $hashTable.add($i,$bucket[$i])
}


$hashTable
[int]$userInput = Read-Host "`nEnter the corresponding number to see the wifi password`n"


#check if number entered is valid
if (-not($hashTable.ContainsKey($userInput))) {
    Write-Host "The Number you entered is invalid, good job." -ForegroundColor Red
    Exit
}


$userProfileName = $hashTable.Item($userInput)

$command = netsh wlan show profiles $userProfileName key=clear


#only write the Index containing the string "Security Key" to the screen
for ($i = 0; $i -lt $command.Count; $i++) {

    if ($command[$i].Contains("Key Content")) {
        $password = $command[$i].Trim("    Key Content            : ")
        #$password = $password.Trim("    Key Content            : ")
    }


}


Write-Host "`nThe Password for that network is:`n$password" -ForegroundColor Green