# Set execution policy if not set
$ExecutionPolicy = Get-ExecutionPolicy
if ($ExecutionPolicy -ne "RemoteSigned") {
Set-ExecutionPolicy RemoteSigned -Force
}

# Cleanup logs older than the set of days in numbers
$days = 30

# Path of the logs that you like to cleanup
$IISLogPath = "C:\inetpub\logs\LogFiles\"
$ExchangeLoggingPath = "C:\Program Files\Microsoft\Exchange Server\V15\Logging\"
$ExchangeLoggingPath2 = "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\"
$ETLLoggingPath = "C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\ETLTraces\"
$ETLLoggingPath2 = "C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\Logs\"

# Deleted files log
$LogFileName = "L:\Exchange Scripts\Exchange-Clean-Logs-Script\Exchange-Clean-Logs-Script-Deleted-Files.log"

# Clean the logs
Function CleanLogfiles($TargetFolder) {
    Write-Host -Debug -ForegroundColor Yellow -BackgroundColor Cyan $TargetFolder
     if (Test-Path $TargetFolder) {
         $Now = Get-Date
         $LastWrite = $Now.AddDays(-$days)
         $Files = Get-ChildItem $TargetFolder -Recurse | Where-Object { $_.Name -like "*.log" -or $_.Name -like "*.blg" -or $_.Name -like "*.etl" } | Where-Object { $_.lastWriteTime -le "$lastwrite" } | Select-Object FullName
         foreach ($File in $Files) {
             $FullFileName = $File.FullName  
             Write-Host "Deleting file $FullFileName" -ForegroundColor "yellow"
             $DeletingFile = "Deleting file $FullFileName"
             $DeletingFile >> $LogFileName
             Remove-Item $FullFileName -ErrorAction SilentlyContinue | out-null
         }
     }
     Else {
         Write-Host "The folder $TargetFolder doesn't exist! Check the folder path!" -ForegroundColor "red"
     }

 }

# Run cleanup function with paths
CleanLogfiles($IISLogPath)
CleanLogfiles($ExchangeLoggingPath)
CleanLogfiles($ExchangeLoggingPath2)
CleanLogfiles($ETLLoggingPath)
CleanLogfiles($ETLLoggingPath2)
