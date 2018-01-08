using module '.\..\..\CMLimitingCollection\CMLimitingCollection.psm1'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests structure we can assume:
$here = $here -replace 'Tests', 'CMLimitingCollection'

. "$here\$sut"

# Use InModuleScope to gain access to private functions
InModuleScope "CMLimitingCollection" {
    Describe 'Private\Mount-CMDrive' -Tags @("01","helper","private") {
        $ValidParameters = @{
            'SiteCode' = 'A01'
            'Name' = 'CurrentDrive'
        }
        Mock Get-CMSiteCode { return $ValidParameters.SiteCode }
        Mock Import-Module
        Mock Set-Variable
        Mock Get-PSDrive
        Mock Write-Error
        Mock Write-Output
        Mock Set-Location

        Context "imports the module and mounts the PS drive" {
            Mount-CMDrive
            It 'calls Get-CMSiteCode exactly once' {
                Assert-MockCalled Get-CMSiteCode -Times 1 -Exactly
            }
            It 'calls Import-Module exactly once' {
                Assert-MockCalled Import-Module -Times 1 -Exactly
            }
            It 'calls Set-Variable exactly once' {
                Assert-MockCalled Set-Variable -Times 1 -Exactly -ParameterFilter { $Name -eq $ValidParameters.Name }
            }
            It 'calls Get-PSDrive exactly once' {
                Assert-MockCalled Get-PSDrive -Times 1 -Exactly
            }
            It 'calls Write-Error zero times' {
                Assert-MockCalled Write-Error -Times 0 -Exactly
            }
            It 'calls Write-Output exactly once' {
                Assert-MockCalled Write-Output -Times 1 -Exactly
            }
            It 'calls Set-Location exactly once' {
                Assert-MockCalled Set-Location -Times 1 -Exactly
            }
        }

        Context "accepts a SideCode param, imports the module and mounts the PS drive" {
            Mount-CMDrive -SiteCode $ValidParameters.SiteCode
            It 'calls Get-CMSiteCode exactly zero times' {
                Assert-MockCalled Get-CMSiteCode -Times 0 -Exactly
            }
            It 'calls Import-Module exactly once' {
                Assert-MockCalled Import-Module -Times 1 -Exactly
            }
            It 'calls Set-Variable exactly once' {
                Assert-MockCalled Set-Variable -Times 1 -Exactly -ParameterFilter { $Name -eq $ValidParameters.Name }
            }
            It 'calls Get-PSDrive exactly once' {
                Assert-MockCalled Get-PSDrive -Times 1 -Exactly
            }
            It 'calls Write-Error zero times' {
                Assert-MockCalled Write-Error -Times 0 -Exactly
            }
            It 'calls Write-Output exactly once' {
                Assert-MockCalled Write-Output -Times 1 -Exactly
            }
            It 'calls Set-Location exactly once' {
                Assert-MockCalled Set-Location -Times 1 -Exactly -ParameterFilter { $Path -eq "$($ValidParameters.SiteCode):" }
            }
        }
    }
}