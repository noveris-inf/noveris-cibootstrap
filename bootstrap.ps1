<#
#>

################
# Global settings
$InformationPreference = "Continue"
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2

################
# Modules
Write-Information "Install/Update/Import Noveris.ModuleMgmt"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Remove-Module Noveris.ModuleMgmt -EA SilentlyContinue
Install-Module Noveris.ModuleMgmt -Scope CurrentUser -EA SilentlyContinue
Update-Module Noveris.ModuleMgmt -Scope CurrentUser -EA SilentlyContinue
Import-Module Noveris.ModuleMgmt

Write-Information "Install/Import Noveris.CITools"
Remove-Module Noveris.CITools -EA SilentlyContinue
Import-Module -Name Noveris.CITools -RequiredVersion (Install-PSModuleWithSpec -Name Noveris.CITools -Major 0 -Minor 5)
