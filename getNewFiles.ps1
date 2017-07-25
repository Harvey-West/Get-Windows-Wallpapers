
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


$existingFiles = Get-ChildItem $targetFilePath -Filter ".png"

logOutput("Hello world")

