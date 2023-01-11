

Set-Location $env:HOMEPATH\youtubedl

if ((Test-Path ".\New") -eq $false) {
    Mkdir "New"
    Set-Location ".\New"
}


do {
    $userInput = Read-Host "`n`nProvide me a youtube link OR Press [q] to quit`n"

    if ($userInput -ne 'q') {

        .\youtube-dl.exe -x --audio-format mp3 "$userInput"
        
    }

}

until ($userInput -eq 'q')



#lazy way to check if mp3tag is installed
#mp3tag has to be used to edit file attributes: file name, song name, artist, playlist

if ((Test-path 'C:\Program Files (x86)\Mp3tag\') -eq $true) {
    start-process "C:\Program Files (x86)\Mp3tag\Mp3tag.exe"
}
