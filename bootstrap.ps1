<#
#>

################
# Global settings
$InformationPreference = "Continue"
$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2


<#
#>
Function Use-PowerShellGallery
{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("AllUsers", "CurrentUser")]
        [string]$Scope = "CurrentUser"
    )

    process
    {
        Write-Verbose "Installing Nuget package provider"
        if ($PSCmdlet.ShouldProcess("Nuget Provider", "Update"))
        {
            Write-Verbose "Attempting nuget provider update"
            try {
                # Set TLS support to 1.1 and 1.2 explicitly
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls13
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false -Scope $Scope
            } catch {
                Write-Warning "Couldn't install nuget package provider"
            }
        }

        Write-Verbose "Trusting PSGallery"
        if ($PSCmdlet.ShouldProcess("PSGallery Repository", "Trust"))
        {
            try {
                Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
            } catch {
                Write-Verbose ("Set-PSRepository for PSGallery failed: " + $_)
            }
        }
    }
}

################
# Modules
Write-Information "Install/Update/Import ModuleMgmt"
# Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Use-PowerShellGallery
Remove-Module ModuleMgmt -EA SilentlyContinue
Install-Module ModuleMgmt -Scope CurrentUser -EA SilentlyContinue
Update-Module ModuleMgmt -Scope CurrentUser -EA SilentlyContinue
Import-Module ModuleMgmt

Write-Information "Install/Import CITools"
Remove-Module CITools -EA SilentlyContinue
Import-Module -Name CITools -RequiredVersion (Install-PSModuleWithSpec -Name CITools -Major 1)
Import-Module -Name GitHubApiTools -RequiredVersion (Install-PSModuleWithSpec -Name CITools -Major 1)
