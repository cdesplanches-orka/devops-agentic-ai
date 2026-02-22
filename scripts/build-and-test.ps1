# build-and-test.ps1
# This script builds Docker images and runs tests for both microservices.
# Run from the repository root or scripts/ directory.

$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptRoot "..")

$services = @("ms-a", "ms-b")

foreach ($service in $services) {
    Write-Host "--- Processing $service ---" -ForegroundColor Cyan

    $servicePath = Join-Path $repoRoot "apps\$service"
    if (-not (Test-Path $servicePath)) {
        Write-Error "Service path not found: $servicePath (ensure submodules are initialized: git submodule update --init)"
        exit 1
    }

    try {
        Push-Location $servicePath

        # 1. Install dependencies and run local tests
        Write-Host "Running local npm tests..."
        npm install
        npm test

        # 2. Build Docker Image (requires Docker Desktop)
        Write-Host "Building Docker image..."
        $tag = $(git rev-parse --short HEAD)
        docker build -t "devops/${service}:${tag}" .

        if ($LASTEXITCODE -ne 0) {
            throw "Build failed for $service"
        }
    }
    finally {
        Pop-Location
    }
}

Write-Host "All builds and tests passed!" -ForegroundColor Green
