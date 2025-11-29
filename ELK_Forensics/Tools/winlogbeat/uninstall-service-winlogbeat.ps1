# Delete and stop the service if it already exists.
if (Get-Service winlogbeat -ErrorAction SilentlyContinue) {
  Stop-Service winlogbeat
  (Get-Service winlogbeat).WaitForStatus('Stopped')
  Start-Sleep -s 1
  sc.exe delete winlogbeat
}
