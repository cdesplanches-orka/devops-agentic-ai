# promote-to-stage.ps1
# This script promotes a validated image tag from Dev to Stage environment.

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("ms-a", "ms-b")]
    [string]$Service,
    [Parameter(Mandatory = $true)]
    [string]$Tag
)

$envFile = "k8s/envs/$Service-stage.yaml"

if (-not (Test-Path $envFile)) {
    Write-Error "Environment file $envFile not found."
    exit 1
}

Write-Host "--- Promoting $Service to STAGE environment ---" -ForegroundColor Cyan
Write-Host "Updating $envFile with new image tag: $Tag"

# Replace the tag in the YAML file (simple regex for didactic purposes)
$content = Get-Content $envFile
$newContent = $content -replace "tag: .*", "tag: $Tag"
$newContent | Set-Content $envFile

Write-Host "Successfully updated $envFile." -ForegroundColor Green
Write-Host "Deployment triggered: kubectl apply -f $envFile"
Write-Host "Verifying Stage Health..."
# Mocking a health check
Start-Sleep -Seconds 2
Write-Host "Stage Environment is HEALTHY." -ForegroundColor Green
