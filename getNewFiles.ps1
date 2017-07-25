
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
$existingFiles = Get-ChildItem $targetFilePath -Filter ".png"

Write-Host $logFilePath
logOutput -stringToLog "Hello world" -targetFilePath $logFilePath 

