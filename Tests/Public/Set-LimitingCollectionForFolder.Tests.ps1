$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests structure we can assume:
$here = $here -replace 'Tests', 'CMLimitingCollection'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\CMLimitingCollection\CMLimitingCollection.psm1") -Force

# Use InModuleScope to gain access to private functions
InModuleScope "CMLimitingCollection" {
    Describe 'Public\Set-LimitingCollectionForFolder' -Tags @("01","helper","public") {

        $ValidParameters = @{
            'Path' = '\Assets and Compliance\Overview\User Collections\Install'
            'LimitingCollectionName' = 'Limiting Collection'
            'LimitingCollectionId' = 'A0100147'
            'SiteCode' = 'A01'
            'SiteServer' = 'mysccmsiteserver.mydomain'
        }
        $ValidResponse = @{
            'Path' = '\UserCollection\Install'
            'FolderPath' = "$($ValidParameters.SiteCode):\UserCollection\Install"
            'ContainerNodeId' = '16777407'
            'Name'=$ValidParameters.LimitingCollectionName
        }
        $ContainerItems = @(
            @{'InstanceKey' = 'A0100187'},
            @{'InstanceKey' = 'A0100188'},
            @{'InstanceKey' = 'A0100189'}
        )
        $InvalidParameters = @{
            'Path' = 'C:\User Collections\Install'
            'LimitingCollectionName' = $null
            'LimitingCollectionId' = $null
        }
        $InvalidResponse = @{
            'Path' = $null
            'FolderPath' = "$($ValidParameters.SiteCode):"
            'ContainerNodeId' = $null
            'Name'=$null
        }

        function Get-CMCollection ($Id) { return $ValidResponse }
        function Set-CMCollection { return $null }

        Mock Get-CMSiteCode { return $ValidParameters.SiteCode }
        Mock Get-CMSiteServer { return $ValidParameters.SiteServer }
        mock Mount-CMDrive
        Mock ConvertTo-CMFolderPath { return $ValidResponse.Path }-ParameterFilter { $Path -eq $ValidParameters.Path }
        Mock ConvertTo-CMFolderPath { return $InvalidResponse.FolderPath }-ParameterFilter { $Path -eq $InvalidParameters.Path }
        Mock Test-Path { return $true } -ParameterFilter { $Path -eq $ValidResponse.FolderPath }
        Mock Test-Path { return $false } -ParameterFilter { $Path -eq $InvalidParameters.FolderPath }
        Mock Test-Path { return $false }
        Mock Get-Item { return $ValidResponse }
        Mock Get-CMCollection { return $ValidResponse } -ParameterFilter { $LimitingCollectionName -eq $ValidParameters.LimitingCollectionName -or $LimitingCollectionId -eq $ValidParameters.LimitingCollectionId }
        Mock Get-CMCollection { return $null }
        Mock Set-CMCollection
        Mock Get-WmiObject { return $ContainerItems }
        Mock Dismount-CMDrive

        Context "will accpet a valid path and a limiting collection name" {
            Set-LimitingCollectionForFolder -Path $ValidParameters.Path -LimitingCollectionName $ValidParameters.LimitingCollectionName
            It 'calls Get-CMSiteCode exactly once' {
                Assert-MockCalled Get-CMSiteCode -Times 1 -Exactly
            }
            It 'calls Get-CMSiteServer exactly once' {
                Assert-MockCalled Get-CMSiteServer -Times 1 -Exactly
            }
            It 'calls Mount-CMDrive exactly once' {
                Assert-MockCalled Mount-CMDrive -Times 1 -Exactly
            }
            It 'calls Get-CMCollection exactly once' {
                Assert-MockCalled Get-CMCollection -Times 1 -Exactly
            }
            It 'calls ConvertTo-CMFolderPath exactly once' {
                Assert-MockCalled ConvertTo-CMFolderPath -Times 1 -Exactly
            }
            It 'calls Test-Path exactly once' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidResponse.FolderPath }
            }
            It 'calls Get-Item exactly once' {
                Assert-MockCalled Get-Item -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidResponse.FolderPath }
            }
            It 'calls Get-WmiObject exactly once' {
                Assert-MockCalled Get-WmiObject -Times 1 -Exactly -ParameterFilter { $ComputerName -eq $ValidParameters.SiteServer }
            }
            It 'calls Set-CMCollection once for each collection' {
                Assert-MockCalled Set-CMCollection -Times $ContainerItems.Count -Exactly
            }
            It 'calls Dismount-CMDrive exactly once' {
                Assert-MockCalled Dismount-CMDrive -Times 1 -Exactly
            }
        }

        Context "will accpet a valid path and a limiting collection id" {
            Set-LimitingCollectionForFolder -Path $ValidParameters.Path -LimitingCollectionId $ValidParameters.LimitingCollectionId
            It 'calls Get-CMSiteCode exactly once' {
                Assert-MockCalled Get-CMSiteCode -Times 1 -Exactly
            }
            It 'calls Get-CMSiteServer exactly once' {
                Assert-MockCalled Get-CMSiteServer -Times 1 -Exactly
            }
            It 'calls Mount-CMDrive exactly once' {
                Assert-MockCalled Mount-CMDrive -Times 1 -Exactly
            }
            It 'calls Get-CMCollection exactly once' {
                Assert-MockCalled Get-CMCollection -Times 1 -Exactly
            }
            It 'calls ConvertTo-CMFolderPath exactly once' {
                Assert-MockCalled ConvertTo-CMFolderPath -Times 1 -Exactly
            }
            It 'calls Test-Path exactly once' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidResponse.FolderPath }
            }
            It 'calls Get-Item exactly once' {
                Assert-MockCalled Get-Item -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidResponse.FolderPath }
            }
            It 'calls Get-WmiObject exactly once' {
                Assert-MockCalled Get-WmiObject -Times 1 -Exactly -ParameterFilter { $ComputerName -eq $ValidParameters.SiteServer }
            }
            It 'calls Set-CMCollection once for each collection' {
                Assert-MockCalled Set-CMCollection -Times $ContainerItems.Count -Exactly
            }
            It 'calls Dismount-CMDrive exactly once' {
                Assert-MockCalled Dismount-CMDrive -Times 1 -Exactly
            }
        }

        Context "will not accpet an invalid path" {
            It "fails" {
               { Set-LimitingCollectionForFolder -Path $InvalidParameters.Path -LimitingCollectionId $ValidParameters.LimitingCollectionId } | Should -Throw
            }
        }

        Context "will not accpet an invalid collection id" {
            It "fails" {
               { Set-LimitingCollectionForFolder -Path $ValidParameters.Path -LimitingCollectionId $InvalidParameters.LimitingCollectionId } | Should -Throw
            }
        }

        Context "will not accpet an invalid collection name" {
            It "fails" {
                { Set-LimitingCollectionForFolder -Path $ValidParameters.Path -LimitingCollectionName $InvalidParameters.LimitingCollectionName } | Should -Throw
            }
        }
    }
}