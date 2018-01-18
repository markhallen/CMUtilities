using module '.\..\..\CMLimitingCollection\CMLimitingCollection.psm1'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests structure we can assume:
$here = $here -replace 'Tests', 'CMLimitingCollection'

. "$here\$sut"

# Use InModuleScope to gain access to private functions
InModuleScope "CMLimitingCollection" {
    Describe 'Private\Get-CMSiteCode' -Tags @("01","helper","private","sitecode") {
        $ValidParameters = @{
            'Server' = "HKLM:\SOFTWARE\Microsoft\SMS\Identification"
            'Client' = "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client"
        }
        $ValidReponse = @{
            'SiteCode' = 'A01'
            'Site Code' = 'A01'
            'AssignedSiteCode' = 'A01'
        }
        Mock Test-Path { return $false }
        Mock Get-ItemProperty { return $null }
        Mock Write-Error { Throw }

        Context "returns the site code when run on a server" {
            Mock Test-Path { return $true } -ParameterFilter { $Path -eq $ValidParameters.Server }
            Mock Get-ItemProperty { return $ValidReponse } -ParameterFilter { $Path -eq $ValidParameters.Server }

            $r = Get-CMSiteCode
            It 'calls Test-Path exactly once' {
                Assert-MockCalled Test-Path -Times 1 -Exactly
            }
            It 'calls Test-Path exactly once with the Path to the server' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Server }
            }
            It 'calls Test-Path exactly zero times with the Path to the client' {
                Assert-MockCalled Test-Path -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Client }
            }
            It 'calls Get-ItemProperty exactly once' {
                Assert-MockCalled Get-ItemProperty -Times 1 -Exactly
            }
            It 'calls Get-ItemProperty exactly once with the Path to the server' {
                Assert-MockCalled Get-ItemProperty -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Server }
            }
            It 'calls Get-ItemProperty exactly zero times with the Path to the client' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Client }
            }
            It 'calls Write-Error zero times' {
                Assert-MockCalled Write-Error -Times 0 -Exactly
            }
            It 'returns the site code' {
                $r | Should Be $ValidReponse.SiteCode
            }
        }

        Context "returns the site code when run on a client" {
            Mock Test-Path { return $true } -ParameterFilter { $Path -eq $ValidParameters.Client }
            Mock Get-ItemProperty { return $ValidReponse } -ParameterFilter { $Path -eq $ValidParameters.Client }

            $r = Get-CMSiteCode
            It 'calls Test-Path exactly twice' {
                Assert-MockCalled Test-Path -Times 2 -Exactly
            }
            It 'calls Test-Path exactly once with the Path to the server' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Server }
            }
            It 'calls Test-Path exactly once with the Path to the client' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Client }
            }
            It 'calls Get-ItemProperty exactly once' {
                Assert-MockCalled Get-ItemProperty -Times 1 -Exactly
            }
            It 'calls Get-ItemProperty exactly zero times with the Path to the server' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Server }
            }
            It 'calls Get-ItemProperty exactly once with the Path to the client' {
                Assert-MockCalled Get-ItemProperty -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Client }
            }
            It 'calls Write-Error zero times' {
                Assert-MockCalled Write-Error -Times 0 -Exactly
            }
            It 'returns the site code' {
                $r | Should Be $ValidReponse.SiteCode
            }
        }

        Context "the registry values cannot be found" {
            It "throws an exception" {
               { Get-CMSiteCode } | Should -Throw
            }
            It 'calls Test-Path exactly twice' {
                Assert-MockCalled Test-Path -Times 2 -Exactly
            }
            It 'calls Test-Path exactly once with the Path to the server' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Server }
            }
            It 'calls Test-Path exactly once with the Path to the client' {
                Assert-MockCalled Test-Path -Times 1 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Client }
            }
            It 'calls Get-ItemProperty exactly zero times' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly
            }
            It 'calls Get-ItemProperty exactly zero times with the Path to the server' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Server }
            }
            It 'calls Get-ItemProperty exactly zero times with the Path to the client' {
                Assert-MockCalled Get-ItemProperty -Times 0 -Exactly -ParameterFilter { $Path -eq $ValidParameters.Client }
            }
            It 'calls Write-Error once' {
                Assert-MockCalled Write-Error -Times 1 -Exactly
            }
        }
    }
}