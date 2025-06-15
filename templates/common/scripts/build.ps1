# build.ps1 — GNU-style argument parsing for cross-platform CLI usage

# Step into project root (one level above /scripts)
Set-Location -Path (Join-Path $PSScriptRoot "..")

# === Default Configuration ===
$Program = "main"

# === Parse CLI args (e.g. --program=robotLogic) ===
foreach ($arg in $args) {
    if ($arg -like "--program=*") {
        $Program = $arg -replace "^--program=", ""
    }
}

# === Paths ===
$Include = "$env:EV5_SDK\includeRTOSEV5"
$ObjectDir = "$Include\o"
$LinkerScript = "$ObjectDir\stm32_flash.ld"

$CC = "arm-none-eabi-gcc"
$OBJCOPY = "arm-none-eabi-objcopy"
$IncludeFlags = @("-I$Include")

# === Compilation ===
Write-Host "Compiling $Program.c..."
& $CC $IncludeFlags -mcpu=cortex-m3 -mthumb -Os -fsigned-char -w -gdwarf-2 `
    -DF_CPU=72000000UL -std=gnu99 -c "$Program.c" -o "$Program.o"

if (!(Test-Path "$Program.o")) {
    Write-Host "ERROR: Compilation failed. $Program.o not created."
    exit 1
}

# === Link ===
$SupportObjs = Get-ChildItem -Path $ObjectDir -Filter *.o | ForEach-Object { $_.FullName }

Write-Host "Linking to produce $Program.elf..."
& $CC -mcpu=cortex-m3 -mthumb -L"$ObjectDir" -T"$LinkerScript" `
    '-Wl,--gc-sections' "-Wl,-Map=$Program.map,-cref" `
    $SupportObjs "$Program.o" -lm -o "$Program.elf"

if (!(Test-Path "$Program.elf")) {
    Write-Host "ERROR: Linking failed. $Program.elf not created."
    exit 1
}

# === Convert to BIN ===
Write-Host "Creating $Program.bin..."
& $OBJCOPY -O binary "$Program.elf" "$Program.bin"

if (!(Test-Path "$Program.bin")) {
    Write-Host "ERROR: Binary conversion failed. $Program.bin not created."
    exit 1
}

# === Cleanup ===
Write-Host "Cleaning up intermediate files..."
Remove-Item -Force -ErrorAction SilentlyContinue "$Program.o", "$Program.elf", "$Program.map"

Write-Host "Build complete. Output: $Program.bin"
