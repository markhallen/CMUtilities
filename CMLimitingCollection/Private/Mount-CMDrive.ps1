function Mount-CMDrive ($SiteCode=$null) {
    <#
    Import the CM POSH module and mount the CM drive
    #>
    if(!($SiteCode)) { $SiteCode = Get-CMSiteCode }
    try {
        Import-Module ($env:SMS_ADMIN_UI_PATH.Substring(0,$env:SMS_ADMIN_UI_PATH.Length - 5) + '\ConfigurationManager.psd1') | Out-Null
        Set-Variable -Scope Script -Name CurrentDrive -Value "$($pwd.Drive.Name):"
        Get-PSDrive -Name $SiteCode | Out-Null
    }
    catch {
        Write-Error "There was a problem loading the Configuration Manager powershell module and accessing the site's PSDrive." -ErrorAction Stop
    }
    Write-Output "Connected to ConfigMgr site $SiteCode"
    Set-Location -Path "$($SiteCode):" | Out-Null
}