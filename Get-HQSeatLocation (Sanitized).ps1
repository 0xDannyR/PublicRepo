<#
.SYNOPSIS

This will search the Wilmington Seating Chart for an employee by Lastname, Firstname

.Notes

Author: 0xDannyR

ERRORS:
    !   Can't handle duplicate names, MUST SPECIFY FIRST AND LAST NAME IF COMMON NAME
    !   User running this must be a member of 'seating chart' group in AD


.EXAMPLE
PS C:\Users\rojasd\scripts> rojas, danny

.Example
PS C:\Users\rojasd\scripts> danny
#>




#check if the workbook exist
#browse for the workbook using file explorer?

$masterCopy = "\\shared drive\shared folder\another shared folder\Wilmington Seating Chart MAIN.xls"


if (-not(Test-Path $masterCopy)) {

    Write-Warning "The 'Wilmington Seating Chart MAIN.xls' workbook can't be found`nIT MIGHT'VE BEEN MOVED"
    Exit
}

#user temp folder will be working folder
$temp = [System.IO.Path]::GetTempPath()
$temp = $temp.TrimEnd("\")
$copiedWorkbook = "$temp\seating_chart_temp.xls"

#copy the seating chart workbook to ensure we don't screw up the original / putting the new copy in the User's  TEMP Folder
Copy-Item -Path $masterCopy -Destination $copiedWorkbook

#create excel object
$excelObj = New-Object -ComObject excel.Application

#open the workbook
$workBook = $excelObj.Workbooks.Open($copiedWorkbook)

#worksheet to focus on
$workSheet = $workBook.Worksheets("HQ2")
$workSheet.Activate()


$gameover = $false

#continously ask for input until [q] is selected to quit
while (-not $gameover) {

    Write-Host "`nSEARCH FOR A NAME IN THE WILMINGTON SEATING CHART" -ForegroundColor 14
    Write-Host "Enter [q] or [Q] to quit`n" -ForegroundColor 12
    $userinput = Read-host "Enter a [lastname, firstname] OR [lastname] OR [firstname]"


    #exit script and return to location where script was launched
    if ($userinput -eq "q") {

        $gameover = $true

        #close the workbook and quit running the object.
        $workBook.Close()
        $excelObj.Quit()
    }


    else {

        try {
            
        #grab contents of row that matches user input
        $foundNameRow = $workSheet.Rows(($worksheet.Rows.Find($userInput)).Row)

        #value2 contains Sect | Seat | HR Name | Dept. Name | Job Description | Seat Type | Office Code(EXCLUDE) | Phone | Ergonomics and Accommodations (EXCLUDE)
        $foundName = $foundNameRow.value2

        #store the date in custom object
        $employeeInfoCustomObj = [pscustomobject][ordered]@{
            Section     = $foundName.GetValue(1,1)
            Seat        = $foundName.GetValue(1,2)
            Name        = $foundName.GetValue(1,3)
            Department  = $foundName.GetValue(1,4)
            Description = $foundName.GetValue(1,5)
            SeatType    = $foundName.GetValue(1,6)
            Phone       = $foundName.GetValue(1,8)
        }
        $employeeInfoCustomObj
        }
        catch {
            Clear-Host
            Write-Warning "`n`nName Not Found`nPlease Try Again"
        }
    }
}