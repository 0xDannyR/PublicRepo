<#
.SYNOPSIS
Uses the Speech Synthesizer .Net class for text-to-speech functionality
.Notes
Author:Danny
#>

Add-Type -AssemblyName system.speech
$obj = New-Object system.speech.synthesis.speechsynthesizer

$userInput = Read-Host "What do you want me to say?"


#continously ask for user input
while ($userinput -ne $null) {
    Write-Host "`nPress [q] to exit" -ForegroundColor Red
    Write-Host "Press [v] to change voice`n" -ForegroundColor Yellow


    #changing voices will alternate between the two available voices commonly installed on Windows 10
    if ($userinput -eq 'v') {

        if ($obj.voice.Name -eq "Microsoft David Desktop") {
            $obj.SelectVoice("Microsoft Zira Desktop")
        }

        elseif ($obj.voice.Name -eq "Microsoft Zira Desktop") {
            $obj.SelectVoice("Microsoft David Desktop")
        }

    }


    if ($userInput -eq 'q') {
        exit
    }

    $obj.speak($userInput)
    $userInput = Read-Host "What do you want me to say?"

}