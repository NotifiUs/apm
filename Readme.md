
# Amtelco Package Manager (apm)

A package manager to streamline installation of Amtelco Intelligent Series applications.
You must have an active Field Service contract with Amtelco.

# Use Case

The primary use case is for automated and/or unattended software installations for Amtelco Intelligent Series software applications. 

`apm` replaces the process of logging in, finding, downloading, and going through the installation process for Amtelco software with simple command-line interface (similar in concept to apt, yum, homebrew, composer, npm, yarn, etc. )

# Requirements

> Minimum version of the Windows PowerShell engine required by this module

    PowerShellVersion = '5.1'
  
> Minimum version of the .NET Framework required by this module

    DotNetFrameworkVersion = '4.0'


While we're in beta, we're keeping the requirements fairly strict. 
As we get more installs under our belt at beta sites, we'll relax these requirements to allow usage across more diverse environments.


# Quick Start

From a powershell running as administrator:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/NotifiUs/apm/master/install.ps1'))
apm -credentials save
apm -install supervisor
apm -install soft-agent
apm -install telephone-agent
```

# Automated install script (beta)

Taking the cue from [Chocolatey.org](https://chocolatey.org), we're testing a one-line install script.

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/NotifiUs/apm/master/install.ps1'))

This script will install `apm` to `$Env:ProgramFiles\WindowsPowerShell\Modules\apm` so it's available in all session shells.

Once the module is imported, you can run `apm` or `amtelco` in any powershell.


# Manual Installation and Usage

`apm` is a Windows PowerShell Module. After you download and extract the zip file from Github, you can manage the `apm` PowerShell module like this:

    cd path/to/extracted/zip/archive
    Import-Module -Name .\apm
    Get-Module
    Get-Module apm
    Remove-Module apm
    
In this scenario, the module is only available in the current shell's session. You can copy the `apm` folder to a location within `$Env:PSModulePath` for auto-discovery. 


# Updating to the latest version

Run the automated install script again to update to the latest published version. 

# Administrative rights

`apm` requires administrative rights to install programs. Please use an elevated command prompt. 

The module will not import unless running as administrator. 


# Behind the scenes

`apm` directly connects to the official Amtelco FTP download site. We do not re-distribute, re-package, or otherwise change or mirror Amtelco software (it's against their terms). 

You, as an end user, are directly connecting, via our script, to Amtelco and downloading their software. 

> You must ensure you read and agree to the Amtelco terms and licensing before using this program. 


Only the latest general availability release is installable. 
This is because Amtelco removes and does not provide an archive of older versions.

We only connect to the Amtelco download site through TLS (https) only.


## How does the package installation work?

We use `msiexec` to install Amtelco packages like this:
   
    msiexec.exe /package C:\ProgramData\apm\WinOpSetup.msi /passive /qn

To uninstall Amtelco packages, we use the WMI `Win32_Product` API to search for the program.
We then remove the program using the `.uninstall()` method of the `Win32_Product` object.

We keep a copy of the downloaded package in a local cache directory. 
The default cache directory location is `C:\ProgramData\apm\`
    

# Authentication with Amtelco

When you run a command that needs to download a package file from Amtelco, a Windows credentials 
authentication prompt will appear. Enter the username and password just as if you were logging into their website directly.

## Authentication when using automation

You'll need to interactively provide credentials initially. 
Once saved, you can run any command automated without being prompted for credentials. 

```powershell
PS C:\> apm -credentials save
```

To clear your credentials (delete the encrypted file):
```powershell
PS C:\> apm -credentials clear
```

Please note, performing an upgrade to a new version of apm will wipe out your saved credentials.

# Seeing what's available to install

Get a list of installable packages

```powershell
PS C:\> apm -available

[apm] Available packages are:

Name                           Value
----                           -----
supervisor                     Intelligent Series Supervisor application
telephone-agent                Operator application for Infinity
soft-agent                     Operator application for Genesis

```

# Uninstalling software

    PS C:\> apm -remove supervisor

This option will uninstall supervisor and leave behind the registry settings (consistent with manual behavior when uninstalling.) 


# View about information about apm

You can see the current version and about section of apm by running:

    PS C:\> apm -about


# Copyright Notice

Amtelco, Intelligent Series, Infinity, Genesis, and related terms are copyright of Amtelco.

# License

Amtelco Package Manager (apm) is open-source software licensed under the MIT license.

