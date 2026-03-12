# configure-cloudflare-warp.ps1
# Post-install configuration for Cloudflare WARP on Windows
# Writes registry keys for Cloudflare WARP client and enables the service

$RegistryPath = "HKLM:\SOFTWARE\Policies\Cloudflare\WARP"

# Create the registry path if it does not exist
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set organization name (replace YOUR_ORG_NAME with your Cloudflare Zero Trust org)
Set-ItemProperty -Path $RegistryPath -Name "organization" -Value "YOUR_ORG_NAME" -Type String -Force

# Enable auto-connect
Set-ItemProperty -Path $RegistryPath -Name "auto_connect" -Value 1 -Type DWord -Force

# Disable onboarding screens
Set-ItemProperty -Path $RegistryPath -Name "onboarding" -Value 0 -Type DWord -Force

# Allow users to toggle the WARP switch
Set-ItemProperty -Path $RegistryPath -Name "switch_locked" -Value 0 -Type DWord -Force

# Enable the WARP client
Set-ItemProperty -Path $RegistryPath -Name "enable" -Value 1 -Type DWord -Force

# Ensure the CloudflareWARP service is running
$service = Get-Service -Name "CloudflareWARP" -ErrorAction SilentlyContinue
if ($service) {
    Set-Service -Name "CloudflareWARP" -StartupType Automatic
    if ($service.Status -ne "Running") {
        Start-Service -Name "CloudflareWARP"
    }
}

# Register the WARP client
$warpCli = "${env:ProgramFiles}\Cloudflare\Cloudflare WARP\warp-cli.exe"
if (Test-Path $warpCli) {
    & $warpCli --accept-tos register 2>$null
    & $warpCli --accept-tos connect 2>$null
}

Write-Output "Cloudflare WARP post-install configuration applied successfully."
