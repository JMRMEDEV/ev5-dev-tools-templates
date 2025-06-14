# upload.ps1 — Upload .bin file to EV5 USB device using --program=XYZ syntax

# Default to 'main' if no --program=... provided
$Program = "main"

# === Parse CLI args (e.g. --program=robotLogic) ===
foreach ($arg in $args) {
    if ($arg -like "--program=*") {
        $Program = $arg -replace "^--program=", ""
    }
}

# === Locate EV5 USB Drive ===
$ev5Drive = Get-Volume | Where-Object { $_.FileSystemLabel -eq "EV5" }

if ($ev5Drive -eq $null) {
    Write-Host "ERROR: EV5 USB drive not found. Please ensure the device is plugged in and mounted."
    exit 1
}

$driveLetter = $ev5Drive.DriveLetter + ":"
$sourceFile = "$Program.bin"
$destination = Join-Path $driveLetter "$Program.bin"

# === Copy File ===
if (!(Test-Path $sourceFile)) {
    Write-Host "ERROR: Binary file '$sourceFile' not found. Please build it first."
    exit 1
}

Write-Host "Copying '$sourceFile' to '$destination'..."
Copy-Item -Path $sourceFile -Destination $destination -Force

Write-Host "Upload complete."
