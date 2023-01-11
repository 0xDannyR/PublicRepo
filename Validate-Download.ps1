<#
.Description
Validate a downloads hash value with one provided and compare if they're the same

.Notes
will start with sha256

user interaction will need some kind of gui. cli menu, wpf form(?)
#>

Add-Type -AssemblyName System.Windows.Forms


$downloadsFolder = Resolve-Path $env:homepath\Downloads
$downloadsFolder = $downloadsFolder.path

$chosenFile = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = $downloadsFolder
    Title            = 'Select a file to compare its hash value'
}

$null = $chosenFile.ShowDialog()
$filename = $chosenFile.FileName


$fileHashObject = Get-FileHash $filename
$fileHashAlgorithm = $fileHashObject.Algorithm
$fileHashValue = $fileHashObject.Hash

$userInputHash = Read-Host "What is the SHA256 hash value to compare?`n"

#Clear-Host

Write-Host "Comparing $fileHashAlgorithm hashes..."

if ($fileHashValue -ne $userInputHash) {
    Write-Host "THE HASHES DON'T MATCH" -ForegroundColor Red
}

elseif ($fileHashValue -eq $userInputHash) {
    Write-Host "Hashes are identical" -ForegroundColor Green
}