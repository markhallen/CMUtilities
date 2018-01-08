using module '.\..\..\CMLimitingCollection\CMLimitingCollection.psm1'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests structure we can assume:
$here = $here -replace 'Tests', 'CMLimitingCollection'

. "$here\$sut"

# Use InModuleScope to gain access to private functions
InModuleScope "CMLimitingCollection" {
    Describe 'Private\Dismount-CMDrive' -Tags @("01","helper","private") {
        $Module = @{
            'Name' = 'ConfigurationManager'
        }
        Mock Set-Location
        Mock Start-Sleep
        Mock Get-Module { return $Module }
        Mock Remove-Module
        Mock Write-Error

        Context "dismounts the PS drive and removes the module" {
            Dismount-CMDrive
            It 'calls Set-Location exactly once' {
                Assert-MockCalled Set-Location -Times 1 -Exactly
            }
            It 'calls Start-Sleep exactly once' {
                Assert-MockCalled Start-Sleep -Times 1 -Exactly
            }
            It 'calls Get-Module exactly once' {
                Assert-MockCalled Get-Module -Times 1 -Exactly -ParameterFilter { $Name -eq $Module.Name }
            }
            It 'calls Remove-Module exactly once' {
                Assert-MockCalled Remove-Module -Times 1 -Exactly
            }
            It 'calls Write-Error zero times' {
                Assert-MockCalled Write-Error -Times 0 -Exactly
            }
        }
    }
}