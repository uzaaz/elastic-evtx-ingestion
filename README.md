# elastic-evtx-ingestion
🚀 Project OverviewThis project demonstrates a robust pipeline for ingesting and analyzing forensically collected Windows Event Log files (.evtx) into the Elastic Stack (Elasticsearch, Kibana) using Winlogbeat. This process is critical in digital forensics and security operations for efficient threat hunting and evidence review.The pipeline is automated using a PowerShell script to iterate through multiple EVTX files, ensuring each file is treated as a new source for proper ingestion and analysis.🔑 Key FeaturesForensic Ingestion Configuration: Custom winlogbeat-forensic.yml is configured to handle offline EVTX files, setting no_more_events: stop and start_at: oldest1.Batch Automation: A PowerShell script (ingest.ps1) automates the ingestion of all .evtx files found within a specified evidence directory222.Registry Nuking: The batch script critically removes the local Winlogbeat registry data (.\data) before processing each file to force Winlogbeat to treat every EVTX file as a new log source3333.Security Monitoring Setup: Includes steps for installing Sysmon to generate enhanced endpoint telemetry for richer forensic data4444.Cloud Integration: Configuration uses Elastic Cloud ID and API key for secure data upload5.🛠️ Technologies UsedCategoryComponentDescription / PurposeIngestionWinlogbeat (v8.15.3)The dedicated Elastic Beat for shipping Windows event logs6.AnalysisElastic Stack (ELK)Elasticsearch for storage and Kibana for visualization (as seen in the screenshot).Data SourceSysmonOptional tool for generating detailed, high-fidelity security event data7.AutomationPowerShellUsed for the ingest.ps1 batch script to manage file processing and cleanup8.📖 Setup and Execution GuidePrerequisitesDownload Winlogbeat: Get the Windows executable9.https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-8.15.3-windows-x86_64.zipDownload Sysmon (Optional for generating test data)10.Download Sample EVTX Files (Optional)11.https://github.com/sbousseaden/EVTX-ATTACK-SAMPLES1. Directory StructureEnsure your project uses the following directory structure:C:\ELK_Forensics
├── Tools
│   ├── Sysmon\
│   └── winlogbeat\
└── Evidence\
    ├── Discovery\
    └── [Other EVTX files]
2. Install Sysmon (Optional)Install Sysmon to collect rich security events:Bashcd C:\ELK_Forensics\Tools\Sysmon
.\Sysmon64.exe -i
``` [cite: 12, 13]

#### 3. Configure `winlogbeat-forensic.yml`

Create a file named `winlogbeat-forensic.yml` inside `C:\ELK_Forensics\Tools\winlogbeat` with the following content. **Remember to replace the placeholders for your Cloud ID and credentials.**

```yaml
# ================= Forensic Ingestion Config =================
winlogbeat.event_logs:
  - name: ${EVTX_FILE}
    no_more_events: stop
    start_at: oldest
    ignore_older: 87600h  # The 10 year fix
winlogbeat.shutdown_timeout: 30s
winlogbeat.registry_file: winlogbeat-forensic.data

# Your Cloud Details
cloud.id: "YOUR_CLOUD_ID_HERE"
cloud.auth: "elastic:YOUR_PASSWORD_HERE"

output.elasticsearch:
  tty: true
``` [cite: 21, 22, 24, 25, 26, 30, 31]

#### 4. Run Batch Ingestion (Recommended)

Save the following as `ingest.ps1` or paste it directly into a PowerShell window running in the `C:\ELK_Forensics\Tools\winlogbeat` directory:

```powershell
# ELK FORENSIC INGESTOR - BATCH SCRIPT
$toolPath = "C:\ELK_Forensics\Tools\winlogbeat"
$evidencePath = "C:\ELK_Forensics\Evidence"

Set-Location $toolPath
$files = Get-ChildItem -Path $evidencePath -Recurse -Filter *.evtx

foreach ($file in $files) {
    # ... (Rest of the script logic)
    Remove-Item ".\data" -Recurse -Force -ErrorAction SilentlyContinue
    .\winlogbeat.exe -c .\winlogbeat-forensic.yml -E EVTX_FILE="$($file.FullName)"
}
Write-Host "BATCH COMPLETED." -ForegroundColor Green
``` [cite: 37, 40, 41, 46, 53, 55, 57]

### 🧹 Cleanup

To remove the ingested logs from your Elastic deployment (e.g., to clear space or test again), run the following command in Kibana's Dev Tools:

DELETE _data_stream/winlogbeat-*``` 12
