# Verification script for live images
Write-Host "🚀 Starting Live Verification..." -ForegroundColor Cyan

# 1. Pull latest images
Write-Host "📥 Pulling latest images from GHCR..." -ForegroundColor Yellow
docker compose -f docker-compose.live.yml pull

# 2. Start services
Write-Host "⚡ Starting services..." -ForegroundColor Yellow
docker compose -f docker-compose.live.yml up -d

# 3. Wait for maturity
Write-Host "⏳ Waiting for services to be healthy..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# 4. Perform End-to-End test
Write-Host "🔍 Testing Aggregation Endpoint (gRPC + REST)..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3001/api/b/aggregate" -Method Get
    Write-Host "✅ Test Succeeded!" -ForegroundColor Green
    Write-Host "Result: " -NoNewline
    $response | ConvertTo-Json | Write-Host
}
catch {
    Write-Host "❌ Test Failed!" -ForegroundColor Red
    Write-Host "Logs from microservice-b:"
    docker compose -f docker-compose.live.yml logs microservice-b
}

# 5. Cleanup
# Write-Host "🧹 Cleaning up..." -ForegroundColor Yellow
# docker compose -f docker-compose.live.yml down
