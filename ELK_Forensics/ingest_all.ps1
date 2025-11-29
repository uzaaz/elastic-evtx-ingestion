# ========================================================
#  ELK FORENSIC INGESTOR - BATCH SCRIPT
# ========================================================
$toolPath = "C:\ELK_Forensics\Tools\winlogbeat"
$evidencePath = "C:\ELK_Forensics\Evidence"

Set-Location $toolPath
$files = Get-ChildItem -Path $evidencePath -Recurse -Filter *.evtx

foreach ($file in $files) {
    Write-Host "------------------------------------------------" -ForegroundColor Cyan
    Write-Host "PROCESSING: $($file.Name)" -ForegroundColor Yellow
    
    # CRITICAL: Nuke the registry to force Winlogbeat to treat the file as new
    if (Test-Path ".\data") {
        Remove-Item ".\data" -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Execute Ingestion
    .\winlogbeat.exe -c .\winlogbeat-forensic.yml -E EVTX_FILE="$($file.FullName)"
}

Write-Host "BATCH COMPLETED." -ForegroundColor Green