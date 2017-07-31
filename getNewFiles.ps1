
PARAM(
    [Parameter(Mandatory=$false)]
    [ValidateScript({Test-Path $_})]
    [string]
    $windowsFilePath,
    [Parameter(Mandatory=$false)]
    [ValidateScript({Test-Path $_})]
    [string]$targetFilePath
)
Import-Module -Name "./logger.psm1" #import standard logging module
$currentFilePath = (Get-Item -Path ".\" -Verbose).FullName
$logFilePath = $currentFilePath + "\Logs\" #All log files to be written to this location
$debug = $false #If true, only output to console not to log file
<#
.Synopsis
    Writes a string to host if in debug, else use module logger to write to log file.
#>
function log($outputString){
    if($debug){
        Write-Host $outputString
    } else {
        logOutput -stringToLog $outputString -targetFilePath $logFilePath
    }
}
$dateTargetFilePath = $targetFilePath + "\" + (Get-Date -format u).substring(0,10) + "\"
log("Begin copying to: "+$dateTargetFilePath)
mkdir -Force $dateTargetFilePath | Out-Null
$existingFiles = Get-ChildItem $targetFilePath -Recurse -Filter "*.png" #Find all existing files with .png extension
log(""+($existingFiles.Count)+" files exist already")

$newFiles = Get-ChildItem $windowsFilePath #Get all windows wallpaper files
log(""+($newFiles.Count)+" new files to scan") 

$fileSizeBytesMinimum = 200*1000 #File size minimum to try and eliminate non 16-9 wallpapers

#Filter out files that already exist (in $existingFiles) and files that are less than $fileSizeBytesMinimum
$filteredFiles = $newFiles | Where-Object {$_.Name -notin ($existingFiles.Name.Replace(".png", "")) -and $_.Length -gt $fileSizeBytesMinimum}
log(""+($filteredFiles.Count)+ " unique files greater than " + $fileSizeBytesMinimum + "B")

try{
    #For each filtered file, copy the item to a folder and append ".png" to each file
    $filteredFiles | ForEach-Object{ log("Beginning to copy file:" + $_.Name); $_.FullName | Copy-Item -Destination (Join-Path $dateTargetFilePath ($_.Name+".png"))}
} catch {
    log("Error copying file to: " + $dateTargetFilePath)
}

