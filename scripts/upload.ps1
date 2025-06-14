# upload-usb.ps1 — Copy compiled .bin file to EV5 USB device

# === Configuration ===
$BinFile = "main.bin"
$TargetFile = "main.bin"  # Could be renamed if needed

# === Locate EV5 USB Drive ===
$ev5Drive = Get-Volume | Where-Object { $_.FileSystemLabel -eq "EV5" }

if ($ev5Drive -eq $null) {
    Write-Host "ERROR: EV5 USB drive not found. Please ensure the device is plugged in and mounted."
    exit 1
}

$driveLetter = $ev5Drive.DriveLetter + ":"
$destination = Join-Path $driveLetter $TargetFile

# === Copy File ===
if (!(Test-Path $BinFile)) {
    Write-Host "ERROR: Binary file '$BinFile' not found. Please build it first."
    exit 1
}

Write-Host "Copying '$BinFile' to '$destination'..."
Copy-Item -Path $BinFile -Destination $destination -Force

Write-Host "Upload complete."
