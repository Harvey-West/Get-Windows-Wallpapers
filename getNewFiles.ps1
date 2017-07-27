
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
$debug = $true
function log($outputString){
    if($debug){
        Write-Host $outputString
    } else {
        logOutput -stringToLog $outputString -targetFilePath $logFilePath
    }
}

$existingFiles = Get-ChildItem $targetFilePath -Filter "*.png"
log(""+($existingFiles.Count)+" files exist already")

$newFiles = Get-ChildItem $windowsFilePath
log(""+($newFiles.Count)+" new files to scan") 

$fileSizeBytesMinimum = 200*1000
$filteredFiles = $newFiles | Where-Object {$_.Name -notin ($existingFiles.Name.Replace(".png", "")) -and $_.Length -gt $fileSizeBytesMinimum}
log(""+($filteredFiles.Count)+ " unique files greater than " + $fileSizeBytesMinimum + "B")