function ConvertTo-CMFolderPath {
    <#
    .SYNOPSIS
    Convert the ConfigMgr console folder string into a valid path.

    .DESCRIPTION
    Convert the ConfigMgr console folder string into a valid path.

    .PARAMETER Path
    The path to the console folder containing the collections to be updated.

    .NOTES
    Author: Mark Allen
    Created: 14/12/2017
    References: 

    .EXAMPLE
    ConvertTo-CMFolderPath -Path "\Application\Core applications"
    Convert the path into a value that can be used with the SCCM cmdlets
    #>
    # Specifies a path to one or more locations.
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
        Position=0,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        HelpMessage="Path to one ConfigMgr console location.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    begin {
        $FolderMappings = @{
            "\\Assets and Compliance\\Overview\\Application Management\\Applications" = "\Application"
            "\\Assets and Compliance\\Overview\\Operating Systems\\Boot Images" = "\BootImage"
            "\\Assets and Compliance\\Overview\\Compliance Settings\\Configuration Baselines" = "\ConfigurationBaseline"
            "\\Assets and Compliance\\Overview\\Compliance Settings\\Configuration Items" = "\ConfigurationItem"
            "\\Assets and Compliance\\Overview\\Device Collections" = "\DeviceCollection"
            "\\Assets and Compliance\\Overview\\Operating Systems\\Drivers" = "\Driver"
            "\\Assets and Compliance\\Overview\\Operating Systems\\Driver Packages" = "\DriverPackage"
            "\\Assets and Compliance\\Overview\\Operating Systems\\Operating System Images" = "\OperatingSystemImage"
            "\\Assets and Compliance\\Overview\\Operating Systems\\Operating System Upgrade Packages" = "\OperatingSystemInstaller"
            "\\Assets and Compliance\\Overview\\Application Management\\Packages" = "\Package"
            "\\Monitoring\\Overview\\Queries" = "\Query"
            "\\Assets and Compliance\\Overview\\Software Metering" = "\SoftwareMetering"
            "\\Assets and Compliance\\Overview\\Operating Systems\\Task Sequences" = "\TaskSequence"
            "\\Assets and Compliance\\Overview\\User Collections" = "\UserCollection"
            "\\Assets and Compliance\\Overview\\User State Migration" = "\UserStateMigration"
            "\\Assets and Compliance\\Overview\\Virtual Hard Disks" = "\VirtualHardDisk"
        }
        $ValidPath = $false
    }

    process {
        foreach ($i in $FolderMappings.Keys) {
            if ($Path -match $i){
                $Path = $Path -replace $i, $FolderMappings[$i]
                $ValidPath = $true
                break
            }
        }
    }

    end {
        if($ValidPath){
            $Path
        } else {
            $null
        }
    }
}