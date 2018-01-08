function Set-LimitingCollectionForFolder {
    <#
    .SYNOPSIS
    Set the limiting collection for a group of collections.

    .DESCRIPTION
    Given a group of collections the limiting collection of each will be set to the value specificed.

    .PARAMETER Path
    The path to the console folder containing the collections to be updated.

    .PARAMETER LimitingCollectionName
    The name of the new limiting collection.

    .PARAMETER LimitingCollectionId
    The CollectionId of the new limiting collection.

    .PARAMETER SiteCode
    [Optional] Connect to the specified site. If no value is provided the default site
    used by the locally installed SCCM client will be used.

    .PARAMETER SiteServer
    [Optional] Connect to the specified site server. If no value is provided the default site
    server used by the locally installed SCCM console will be used.

    .NOTES
    Author: Mark Allen
    Created: 14/12/2017
    References:

    .EXAMPLE
    Set-LimitingCollection -Collections PR1 -LimitingCollectionName "Windows desktops"
    Set the limiting collection to "Windows desktops"
    #>
    [CmdletBinding( DefaultParameterSetName = "LimitingCollectionName" ) ]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path=$null,
        [Parameter(ParameterSetName='LimitingCollectionName',Mandatory=$true)]
        $LimitingCollectionName,
        [Parameter(ParameterSetName='LimitingCollectionId',Mandatory=$true)]
        $LimitingCollectionId,
        [Parameter(Mandatory=$false)]
        [string]$SiteCode = $null,
        [Parameter(Mandatory=$false)]
        [string]$SiteServer = $null
    )

    Begin
    {
        if($SiteCode -eq ''){$SiteCode = Get-CMSiteCode}
        if($SiteServer -eq ''){$SiteServer = Get-CMSiteServer}
        Mount-CMDrive($SiteCode)
    }

    Process
    {
        try {
            if($null -eq $LimitingCollectionName){
                $LimitingCollectionName = (Get-CMCollection -Id $LimitingCollectionId).Name
                if(-not $LimitingCollectionName) { Write-Error "Failed to retrieve limiting collection from ID: ""$LimitingCollectionId""." -ErrorAction Stop }
            } elseif($null -eq (Get-CMCollection -LimitingCollectionName $LimitingCollectionName)) {
                Write-Error "Failed to retrieve limiting collection from name: ""$LimitingCollectionName""." -ErrorAction Stop
            }
            Write-Output "LimitingCollectionName = $LimitingCollectionName"

            $FolderPath = $SiteCode + ':' + (ConvertTo-CMFolderPath -Path $Path)
            if(!(Test-Path -Path $FolderPath)){Write-Error """$Path"" was not found in ConfigMgr: please provide a valid console path." -ErrorAction Stop}

            try {
                $ContainerNodeID = (Get-Item -Path $FolderPath).ContainerNodeID
                Write-Output "ContainerNodeId = $ContainerNodeID"
            }
            catch {
                Write-Error "Failed to retrieve ContainerNodeID for container ""$FolderPath""."
            }

            try {
                $ContainerItems = Get-WmiObject -ComputerName $SiteServer -Namespace root\sms\site_$SiteCode -Query "select * from SMS_ObjectContainerItem where ContainerNodeID='$ContainerNodeID'"
            }
            catch {
                Write-Error "Failed to retrieve objects for container ""$FolderPath""."
            }
            if($ContainerItems -eq $null -or $ContainerItems.Count -eq 0) {Write-Error "The container ""$FolderPath"" does not contain any objects." -ErrorAction Stop}

            foreach ($Item in $ContainerItems) {
                try {
                    Set-CMCollection -CollectionId $Item.InstanceKey -LimitingCollectionName $LimitingCollectionName
                    Write-Output "Limiting collection updated to ""$LimitingCollectionName"" for collection ID: ""$($Item.InstanceKey)""."
                }
                catch {
                    Write-Error "Failed to update limiting collection for collection ID: ""$($Item.InstanceKey)""." -ErrorAction Continue
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSitem)
        }
        finally {
            Dismount-CMDrive
        }
    }

    End
    {
        Write-Output "The limiting collection for collections in ""$Path"" has been updated to ""$LimitingCollectionName""."    
    }
}