﻿$ErrorActionPreference = 'Stop';

$packageName= 'prometheus-windows-exporter.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/prometheus-community/windows_exporter/releases/download/v0.15.0/windows_exporter-0.15.0-386.msi'
$url64      = 'https://github.com/prometheus-community/windows_exporter/releases/download/v0.15.0/windows_exporter-0.15.0-amd64.msi'

$pp = Get-PackageParameters

$silentArgs = "/quiet /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""

if ($pp["EnabledCollectors"] -ne $null -and $pp["EnabledCollectors"] -ne '') {
  $silentArgs += " ENABLED_COLLECTORS=$($pp["EnabledCollectors"])"
  Write-Host "Collectors: `'$($pp["EnabledCollectors"])`'"
}

if ($pp["ListenAddress"] -ne $null -and $pp["ListenAddress"] -ne '') {
  $silentArgs += " LISTEN_ADDR=$($pp["ListenAddress"])"
  Write-Host "Listen Address: `'$($pp["ListenAddress"])`'"
}

if ($pp["ListenPort"] -ne $null -and $pp["ListenPort"] -ne '') {
  $silentArgs += " LISTEN_PORT=$($pp["ListenPort"])"
  Write-Host "Listen Port: `'$($pp["ListenPort"])`'"
}

if ($pp["MetricsPath"] -ne $null -and $pp["MetricsPath"] -ne '') {
  $silentArgs += " METRICS_PATH=$($pp["MetricsPath"])"
  Write-Host "Metrics Path: `'$($pp["MetricsPath"])`'"
}

if ($pp["TextFileDir"] -ne $null -and $pp["TextFileDir"] -ne '') {
  $silentArgs += " TEXTFILE_DIR=$($pp["TextFileDir"])"
  Write-Host "Textfile Directory: `'$($pp["TextFileDir"])`'"
}

if ($pp["ExtraFlags"] -ne $null -and $pp["ExtraFlags"] -ne '') {
  $silentArgs += " EXTRA_FLAGS=$($pp["ExtraFlags"])"
  Write-Host "Extra flags: `'$($pp["ExtraFlags"])`'"
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  softwareName  = 'windows_exporter*'

  checksum      = '40C5C4CBFB28DCE62EF88BF8748F3A1B1367D6AFF232C41EC1382E17C57EA5D6'
  checksumType  = 'sha256'
  checksum64    = '37F2D0BCDE3CD5F324FF8A5B8B38BE3EA515DA65167DAD923CC4284E2410D924'
  checksumType64= 'sha256'

  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
