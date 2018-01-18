# CMLimitingCollection

In Microsoft System Center Configuration Manager, given a collection folder the limiting collection of each collection therein will be set to the value specified.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* PowerShell
* The SCCM console is required
* An account with permission to modify collections

### Installing

#### From source

Copy locally and then import the module.

`Import-Module .\CMLimitingCollection\CMLimitingCollection.psm1`

#### From PowerShell Gallery

`Import-Module CMLimitingCollection`

### Basic usage

1. Copy the folder path from the console folder

![Image of copying the console folder path](https://markallenit.com/blog/wp-content/uploads/2018/01/Copy-console-coll-path.png)

2. Invoke the Set-LimitingCollection funtion and paste the console folder path and the target limiting collection name

`Set-LimitingCollection -Path "\Assets and Compliance\Overview\Device Collections\Applications" -LimitingCollectionName "Windows desktops"`

### Syntax

    Set-LimitingCollectionForFolder -Path <String> -LimitingCollectionName <Object> [-SiteCode <String>] [-SiteServer <String>] [<CommonParameters>]

    Set-LimitingCollectionForFolder -Path <String> -LimitingCollectionId <Object> [-SiteCode <String>] [-SiteServer <String>] [<CommonParameters>]

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

## Running the tests

Unit tests can be run using Invoke-Pester

## Built With

* PowerShell
* Microsoft System Center Configuration Manager
* Pester

## Tested With

* PowerShell 5.1
* Microsoft System Center Configuration Manager 1706
* Pester 3.4.0

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).

## Authors

* **Mark Allen** - *Initial work* - [markhallen](https://github.com/markhallen)

See also the list of [contributors](https://github.com/markhallen/CMLimitingCollection/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
