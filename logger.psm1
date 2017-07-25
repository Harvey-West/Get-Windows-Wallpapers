function logOutput(
    [CmdletBinding()]
    [Parameter(Position = 0, Mandatory=$true)]
    [string]
    $stringToLog,
    [Parameter(Position = 1, Mandatory=$true)]
    [ValidateScript({Test-Path $_})]
    $targetFilePath
){
if (!(Test-Path ($targetFilePath+"\test.log")))
{
   New-Item -path $targetFilePath -name "test.log" -type "file"
   Write-Host "Created new file and text content added"
}
$logFile = $targetFilePath+"\test.log"
$currentTime = "[" + (Get-Date) + "] : "
$finalString = $currentTime + $stringToLog
Write-Host $finalString
Add-Content $logFile $finalString
}