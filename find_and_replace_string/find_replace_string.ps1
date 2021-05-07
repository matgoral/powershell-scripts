#Script to find all word/string in all files in directory and change it

Get-Date
Get-ChildItem -Path "pathToDir" -Recurse | Select-String -Pattern "Pattern" |  Select Line, Path | Export-Csv -path Output.csv

Import-Csv .\Output.csv | ForEach-Object {

     $file = $_.Path
     Copy-Item $file -Destination "$file.back"
     (Get-Content $_.Path).replace('Pattern', 'NewURL') | Set-Content $_.Path

}
Get-Date