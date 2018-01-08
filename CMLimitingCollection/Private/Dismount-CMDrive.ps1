function Dismount-CMDrive
{
    <#
    Reset the current directory
    #>
    Set-Location $CurrentDrive
    Start-Sleep 3
    try{
        Get-Module -Name ConfigurationManager | Remove-Module -force
    }
    catch
    {
        Write-Error "Failed to remove the module ConfigurationManager because CMDrive is still in use."
    }
}