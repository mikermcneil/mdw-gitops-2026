# Set-Wallpaper.ps1
# Downloads a NASA space image and sets it as the desktop wallpaper

$WallpaperURL = "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1920&q=80"
$WallpaperPath = "$env:TEMP\fleet-wallpaper.jpg"

# Download the wallpaper image
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $WallpaperURL -OutFile $WallpaperPath -UseBasicParsing -ErrorAction Stop
} catch {
    Write-Error "Failed to download wallpaper: $_"
    exit 1
}

if (-not (Test-Path $WallpaperPath)) {
    Write-Error "Wallpaper file was not downloaded successfully."
    exit 1
}

# Copy to a permanent location
$PermanentPath = "$env:APPDATA\fleet-wallpaper.jpg"
Copy-Item -Path $WallpaperPath -Destination $PermanentPath -Force

# Set wallpaper using SystemParametersInfo
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE = 0x02

# Set the wallpaper style to Fill (10) via registry
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value 10 -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value 0 -Force

# Apply the wallpaper
$result = [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $PermanentPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

if ($result -eq 0) {
    Write-Error "Failed to set wallpaper."
    exit 1
}

Write-Output "Wallpaper set successfully to $PermanentPath"
