<#
.SYNOPSIS

Run an AD query to grab a user's account info and memberships

.Notes

Can search by SAM account name or Firstname Lastname
Author: Danny Rojas

#>



function GetInfo {

    param (

        [string]$username,
        [string]$firstAndLastName
    )


    #UserInput can be [SAM] or [First and Last Name]
    try {

        $foundName = Get-ADUser $username -Properties *  -Server DURDC002
    }


    catch {

        $foundName = Get-ADUser -Filter { Name -eq $firstAndLastName } -Properties *  -Server DURDC002
    }
    

    #Custom user object to hold all the properties to be displayed (ordered)
    $userObj = [PSCustomObject][ordered]@{
        Username        = $foundName.SamAccountName
        Name            = $foundName.Displayname
        Email           = $foundName.EmailAddress
        Title           = $foundName.Title
        Department      = $foundName.Department
        LastLogonDate   = $foundName.LastLogonDate
        PWLastSet       = $foundName.PasswordLastSet
    }

    #display the properties
    $userObj

    #bucket will hold ALL memberships
    $memberships = $foundName.Memberof
    $bucket = [System.Collections.ArrayList]@()

    #strip all unnecessary characters / Not there yet....
    #index 0 sometimes can't be removed (CosignSigners -> osignSigners)
    foreach ($item in $memberships) {
        $item = $item.split(",")
        $item = $item[0]
        $item = $item.Trim("CN=")
        $bucket.Add($item) > $null
    }


    #shared mailboxes memberships, remove from bucket so they're not dispayed twice
    Write-Host "`n`nSHARED MAILBOXES" -ForegroundColor Yellow

    foreach ($item in $bucket.ToArray()){

        if ($item.contains("(SM)") -eq $true){

            $bucket.Remove($item) > $null
            write-host "$item"
        }

    }

    #licensed software memberships, remove from bucket so they're not dispayed twice
    Write-Host "`n`nLICENSED SOFTWARE" -ForegroundColor Yellow

    foreach ($item in $bucket.ToArray()){

        if ($item.contains("SC_") -eq $true){

            $bucket.Remove($item) > $null
            write-host $item
        }

    }

    #shared drive memberships
    Write-Host "`n`nSHARED DRIVE MEMBERSHIPS" -ForegroundColor Yellow

    #group memberships. Display Bucket contents that should be group memebrships EXCEPT SC_ and (SM)
    Write-Host "`n`nALL OTHER MEMBERSHIPS" -ForegroundColor Yellow

    foreach ($item in $bucket) {
    
        $item | Sort-Object
    }
    
}





#only two options available
$userInput = Read-Host "`nENTER A NUMBER`n[1]FirstName LastName`n[2]Username`n"

switch ($userInput) {

    "1" {

        $firstAndLastName = Read-Host "Enter in First and Last Name"
        GetInfo -firstAndLastName $firstAndLastName

        }
        
        
    "2"{

        $username = Read-Host "Enter in username" 
        GetInfo -username $username

        }


    Default { "Something went wrong, try running again"; break }
}
    

