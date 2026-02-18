# create-pr.ps1
# This script creates a Pull Request on GitHub using the REST API.
# It requires a GITHUB_TOKEN environment variable with 'repo' scope.

param(
    [Parameter(Mandatory = $true)]
    [string]$Owner,
    [Parameter(Mandatory = $true)]
    [string]$Repo,
    [Parameter(Mandatory = $true)]
    [string]$Head, # The branch where your changes are (e.g., 'feature-x')
    [Parameter(Mandatory = $true)]
    [string]$Base, # The branch you want to merge into (e.g., 'master')
    [Parameter(Mandatory = $true)]
    [string]$Title,
    [string]$Body = "This PR was automatically created by the Antigravity DevOps Agent."
)

if (-not $env:GITHUB_TOKEN) {
    Write-Error "GITHUB_TOKEN environment variable is not set. Please set it to a valid Personal Access Token."
    exit 1
}

$url = "https://api.github.com/repos/$Owner/$Repo/pulls"

$payload = @{
    title = $Title
    body  = $Body
    head  = $Head
    base  = $Base
} | ConvertTo-Json

$headers = @{
    "Authorization" = "token $env:GITHUB_TOKEN"
    "Accept"        = "application/vnd.github.v3+json"
}

Write-Host "Creating PR: $Title from $Head to $Base..." -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $payload -Headers $headers -ContentType "application/json"
    Write-Host "PR created successfully! Link: $($response.html_url)" -ForegroundColor Green
}
catch {
    Write-Error "Failed to create PR. Error: $_"
    if ($_.Exception.Response) {
        $errorDetails = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorDetails)
        Write-Host "GitHub API Error: $($reader.ReadToEnd())" -ForegroundColor Red
    }
}
