# Delete and stop the service if it already exists.
if (Get-Service winlogbeat -ErrorAction SilentlyContinue) {
  Stop-Service winlogbeat
  (Get-Service winlogbeat).WaitForStatus('Stopped')
  Start-Sleep -s 1
  sc.exe delete winlogbeat
}

$workdir = Split-Path $MyInvocation.MyCommand.Path

# Create the new service.
New-Service -name winlogbeat `
  -displayName Winlogbeat `
  -binaryPathName "`"$workdir\winlogbeat.exe`" --environment=windows_service -c `"$workdir\winlogbeat.yml`" --path.home `"$workdir`" --path.data `"$env:PROGRAMDATA\winlogbeat`" --path.logs `"$env:PROGRAMDATA\winlogbeat\logs`" -E keystore.path=`"$workdir\data\winlogbeat.keystore`" -E logging.files.redirect_stderr=true"

# Attempt to set the service to delayed start using sc config.
Try {
  Start-Process -FilePath sc.exe -ArgumentList 'config winlogbeat start= delayed-auto'
}
Catch { Write-Host -f red "An error occurred setting the service to delayed start." }
