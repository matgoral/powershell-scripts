#Script to find all word/string in all files in directory and change it

#Start Transcript
$LogFileOutput = ".\Logs\LogOutput.txt"
Start-Transcript -path $LogFileOutput

Get-Date

Write-Output "Start - searching for files"

Get-ChildItem -Path "path" -Recurse | Select-String -Pattern "OLD_STRING" |  Select Line, Path | Export-Csv -path Findings.csv

Write-Output "Found:"
Import-Csv .\Findings.csv | Measure-Object | Select Count
Write-Output "------------------------------"
Get-Date

Write-Output "Starting swap string in files"
$errors=0
$counter=0

Import-Csv .\Findings.csv | ForEach-Object {
    
    $file = $_.Path
#Create backup file ---- WARNING! In case of a large number of files, check the free space on the disk.
     #
     #Copy-Item $file -Destination "$file.back"
#Replace OLD string with NEW
     (Get-Content $_.Path).replace('OLD_STRING', 'NEW_STRING') | Set-Content $_.Path

     $CHECK = Select-String -Path $file -Pattern "OLD_STRING"

    if ($CHECK -ne $null)
        {
            Write-Output "ERROR: $file"
            $errors++
        }
    else
        {
            Write-Output "OK: $file"
            $counter++ 
        }
}

Write-Output "ERRORS: $errors"
Write-Output "OK: $counter"

Write-Output "Script done"
Write-Output "------------------------------"
Get-Date

Stop-Transcript