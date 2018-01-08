function Get-CMSiteServer
{
    <#
    Get the default site code from the local console
    #>
    if(Test-Path -Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10\AdminUI\Connection"){Return (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ConfigMgr10\AdminUI\Connection").Server}
    if(Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\ConfigMgr10\AdminUI\Connection"){Return (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\ConfigMgr10\AdminUI\Connection").Server}
    Write-Error "SiteServer was not found in the registry: please provide it via a parameter." -ErrorAction Stop
}