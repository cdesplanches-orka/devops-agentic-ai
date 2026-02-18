# promote-to-stage.ps1
# This script promotes a validated image tag from Dev to Stage environment.

param(
    [Parameter(Mandatory = $true)]
    [string]$Service,
    [Parameter(Mandatory = $true)]
    [string]$Tag
)

Write-Host "Promoting $Service with tag $Tag to Stage..." -ForegroundColor Cyan

$stagePath = "..\k8s\envs\$Service-stage.yaml"

if (Test-Path $stagePath) {
    (Get-Content $stagePath) -replace 'tag: ".*"', "tag: `"$Tag`"" | Set-Content $stagePath
    Write-Host "Promotion complete. Changes committed to Stage configuration." -ForegroundColor Green
    
    Set-Location "..\k8s"
    git add .
    git commit -m "promote: $Service to tag $Tag in Stage"
}
else {
    Write-Error "Values file not found at $stagePath"
}
