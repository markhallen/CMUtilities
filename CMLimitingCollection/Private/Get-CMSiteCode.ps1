function Get-CMSiteCode
{
    <#
    Get the default site code from the local console
    #>
    if(Test-Path -Path "HKLM:\SOFTWARE\Microsoft\SMS\Identification"){Return (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SMS\Identification").'Site Code'} # server
    if(Test-Path -Path "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client"){Return (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client").AssignedSiteCode} # client
    Write-Error "SiteCode was not found in the registry: please provide it via a parameter." -ErrorAction Stop
}