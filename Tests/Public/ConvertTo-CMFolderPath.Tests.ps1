$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests structure we can assume:
$here = $here -replace 'Tests', 'CMLimitingCollection'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\CMLimitingCollection\CMLimitingCollection.psm1") -Force

# Use InModuleScope to gain access to private functions
InModuleScope "CMLimitingCollection" {
    Describe 'Public\ConvertTo-CMFolderPath' -Tags @("01","helper","public") {
        $ValidParameters = @{
            'Path' = '\Assets and Compliance\Overview\User Collections\Install'
        }
        $ValidResponse = '\UserCollection\Install'
        $InvalidParameters = @{
            'Path' = 'C:\User Collections\Install'
        }

        Context "returns a valid PS drive path" {
            $r = ConvertTo-CMFolderPath @ValidParameters
            It 'does not return null' {
                $r | Should not be $null
            }
            It 'converts the console folder path to a PS drive path' {
                $r | Should be $ValidResponse
            }
        }
        Context "returns null when passed an invalid path" {
            $r = ConvertTo-CMFolderPath @InvalidParameters
            It 'does return null' {
                $r | Should be $null
            }
        }
    }
}