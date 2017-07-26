
PARAM(
    [Parameter(Mandatory=$false)]
    [ValidateScript({Test-Path $_})]
    [string]
    $windowsFilePath,
    [Parameter(Mandatory=$false)]
    [ValidateScript({Test-Path $_})]
    [string]$targetFilePath
)
Import-Module -Name "./logger.psm1"
$currentFilePath = (Get-Item -Path ".\" -Verbose).FullName
$logFilePath = $currentFilePath + "\Logs\"
$existingFiles = Get-ChildItem $targetFilePath -Filter "*.png"
logOutput -stringToLog (""+($existingFiles.Count)+" files exist already") -targetFilePath $logFilePath 

$newFiles = Get-ChildItem $windowsFilePath
logOutput -stringToLog (""+($newFiles.Count)+" new files to scan") -targetFilePath $logFilePath 
$newFiles = $newFiles | Where-Object ($existingFiles -notcontains $_)

