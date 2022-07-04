
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
add-type -AssemblyName System.Drawing

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

function IsAtLeast16By9 {
PARAM(
    [Parameter(Mandatory=$true)]
    [System.IO.FileSystemInfo]
    $file
)
    $fileName = $file.FullName
    $png = New-Object System.Drawing.Bitmap $fileName
    if ($png.Height -ge 1080 -and $png.Width -ge 1920){
        return $true
    }
    return $false
}

$dateTargetFilePath = $targetFilePath + "\" + (Get-Date -format u).substring(0,10) + "\"
log("Begin copying to: "+$dateTargetFilePath)
mkdir -Force $dateTargetFilePath | Out-Null
$existingFiles = Get-ChildItem $targetFilePath -Recurse -Filter "*.png" #Find all existing files with .png extension
log(""+($existingFiles.Count)+" files exist already")

$newFiles = Get-ChildItem $windowsFilePath #Get all windows wallpaper files
log(""+($newFiles.Count)+" new files to scan") 

#Filter out files that already exist (in $existingFiles) and files that are less than $fileSizeBytesMinimum
$filteredFiles = $newFiles | Where-Object {$_.Name -notin ($existingFiles.Name.Replace(".png", "")) -and (IsAtLeast16By9 -file $_) -eq $true}


log(""+($filteredFiles.Count)+ " unique files")

try{
    #For each filtered file, copy the item to a folder and append ".png" to each file
    $filteredFiles | ForEach-Object{ log("Beginning to copy file:" + $_.Name); $_.FullName | Copy-Item -Destination (Join-Path $dateTargetFilePath ($_.Name+".png"))}
} catch {
    log("Error copying file to: " + $dateTargetFilePath)
}
