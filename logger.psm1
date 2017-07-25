function logOutput(
    [Parameter(Mandatory=$true)]
    [string]
    $stringToLog,
    [Parameter(Mandatory=$false)]
    [ValidateScript({Test-Path $_})]
    [string]$targetFilePath
){
Write-Host $stringToLog
}