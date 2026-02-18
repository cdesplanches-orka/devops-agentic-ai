# build-and-test.ps1
# This script builds Docker images and runs tests for both microservices.

$services = @("ms-a", "ms-b")

foreach ($service in $services) {
    Write-Host "--- Processing $service ---" -ForegroundColor Cyan
    
    # 1. Install dependencies and run local tests
    Set-Location "..\apps\$service"
    Write-Host "Running local npm tests..."
    npm install
    npm test
    
    # 2. Build Docker Image (requires Docker Desktop)
    Write-Host "Building Docker image..."
    $tag = $(git rev-parse --short HEAD)
    docker build -t "devops/${service}:${tag}" .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed for $service"
        exit 1
    }
}

Write-Host "All builds and tests passed!" -ForegroundColor Green
