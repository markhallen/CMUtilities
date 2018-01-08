using module '.\..\..\CMLimitingCollection\CMLimitingCollection.psm1'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests structure we can assume:
$here = $here -replace 'Tests', 'CMLimitingCollection'

. "$here\$sut"

# Use InModuleScope to gain access to private functions
InModuleScope "CMLimitingCollection" {
    Describe 'Private\Get-CMSiteServer' -Tags @("01","helper","private","Server") {
        $ValidParameters = @{
            'Reg64bit' = "HKLM:\SOFTWARE\Microsoft\ConfigMgr10\AdminUI\Connection"
            'Reg32bit' = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\ConfigMgr10\AdminUI\Connection"
        }
        $ValidReponse = @{
            'Server' = 'SCCMSERVER01.LOCAL'
        }
        Mock Test-Path { return $false }
        Mock Get-ItemProperty { return $null }
        Mock Write-Error

        Context "returns the server when found in the default registry" {
            Mock Test-Path { return $true } -ParameterFilter { $Path -eq $ValidParameters.Reg64bit }
            Mock Get-ItemProperty { return $ValidReponse } -ParameterFilter { $Path -eq $ValidParameters.Reg64bit }

            $r = Get-CMSiteServer
            It 'calls Test-Path exactly once' {
                Assert-MockCalled Test-Path -Times 1 -Exactly
            }
            It 'calls Test-Path exactly once with the Path to the 64 bit registry' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg64bit }
            }
            It 'calls Test-Path exactly zero times with the Path to the 32 bit registry' {
                Assert-MockCalled Test-Path -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg32bit }
            }
            It 'calls Get-ItemProperty exactly once' {
                Assert-MockCalled Get-ItemProperty -Times 1 -Exactly
            }
            It 'calls Get-ItemProperty exactly once with the Path to the 64 bit registry' {
                Assert-MockCalled Get-ItemProperty -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg64bit }
            }
            It 'calls Get-ItemProperty exactly zero times with the Path to the 32 bit registry' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg32bit }
            }
            It 'calls Write-Error zero times' {
                Assert-MockCalled Write-Error -Times 0 -Exactly
            }
            It 'returns the server' {
                $r | Should Be $ValidReponse.Server
            }
        }

        Context "returns the server when found in the wow 32 bit registry" {
            Mock Test-Path { return $true } -ParameterFilter { $Path -eq $ValidParameters.Reg32bit }
            Mock Get-ItemProperty { return $ValidReponse } -ParameterFilter { $Path -eq $ValidParameters.Reg32bit }

            $r = Get-CMSiteServer
            It 'calls Test-Path exactly twice' {
                Assert-MockCalled Test-Path -Times 2 -Exactly
            }
            It 'calls Test-Path exactly once with the Path to the 64 bit registry' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg64bit }
            }
            It 'calls Test-Path exactly once with the Path to the 32 bit registry' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg32bit }
            }
            It 'calls Get-ItemProperty exactly once' {
                Assert-MockCalled Get-ItemProperty -Times 1 -Exactly
            }
            It 'calls Get-ItemProperty exactly zero times with the Path to the 64 bit registry' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg64bit }
            }
            It 'calls Get-ItemProperty exactly once with the Path to the 32 bit registry' {
                Assert-MockCalled Get-ItemProperty -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg32bit }
            }
            It 'calls Write-Error zero times' {
                Assert-MockCalled Write-Error -Times 0 -Exactly
            }
            It 'returns the server' {
                $r | Should Be $ValidReponse.Server
            }
        }

        Context "the registry values cannot be found" {
            It "throws an exception" {
               Get-CMSiteServer | Should Throw
            }
            It 'calls Test-Path exactly twice' {
                Assert-MockCalled Test-Path -Times 2 -Exactly
            }
            It 'calls Test-Path exactly once with the Path to the 64 bit registry' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg64bit }
            }
            It 'calls Test-Path exactly once with the Path to the 32 bit registry' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg32bit }
            }
            It 'calls Get-ItemProperty exactly zero times' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly
            }
            It 'calls Get-ItemProperty exactly zero times with the Path to the 64 bit registry' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg64bit }
            }
            It 'calls Get-ItemProperty exactly zero times with the Path to the 32 bit registry' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Reg32bit }
            }
            It 'calls Write-Error once' {
                Assert-MockCalled Write-Error -Times 1 -Exactly
            }
        }
    }
}