
# Amtelco Package Manager (APM)

A package manager to streamline installation of Amtelco Intelligent Series applications.
You must have an active Field Service contract with Amtelco.

# Use Case

The primary use case is for automated and/or unattended software installations for Amtelco Intelligent Series software applications. 

APM replaces the process of logging in, finding, downloading, and going through the installation process for Amtelco software with simple command-line interface (similar in concept to apt, yum, homebrew, composer, npm, yarn, etc. )

# Manual Installation and Usage

APM is a Windows PowerShell Module. After you download and extract, you can manage the APM PowerShell module like this:

    PS C:\> Import-Module -Name .\apm
    PS C:\> Get-Module
    PS C:\> Get-Module apm
    PS C:\> Remove-Module apm
    
In this scenario, the module is only available in the current shell's session. You can copy the `apm` folder to a location within $Env:PSModulePath for auto-discovery. 

## Automated install script (beta)

Taking the cue from [Chocolatey.org](https://chocolatey.org), we're testing a one-line install script.

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/NotifiUs/apm/master/install.ps1'))

This script will install `apm` to `$Env:ProgramFiles\WindowsPowerShell\Modules\apm` so it's available in all session shells.

This also allows us to bypass having to issue a `WM_SETTINGCHANGE ` broadcast to update the module path. 

Once the module is imported, you can run `apm` or `amtelco` in any powershell.


## Updating to the latest version

Run the automated install script again to update to the latest published version. 

# Administrative rights

APM requires administrative rights to install programs. Please use an elevated command prompt. 

The module will not import unless running as administrator. 


# Behind the scenes

APM directly connects to the official Amtelco FTP download site. We do not re-distribute, re-package, or otherwise change or mirror Amtelco software (it's against their terms). 

You, as an end user, are directly connecting, via our script, to Amtelco and downloading their software. 

> You must ensure you read and agree to the Amtelco terms and licensing before using this program. 

APM calls msiexec.exe to silently install requested versions. We use the WMI API to find installed applications and remove them. 

> Only the latest general availability release is installable. This is because Amtelco removes and does not provide an archive of older versions.

We connect to the Amtelco site through TLS (https) only.


## How does msiexec work?

Install a package:
   
    msiexec.exe /package WinOpSetup.msi /passive /qn

Uninstall a package:
    
    msiexec.exe /uninstall WinOpSetup.msi /q
    
We actually use the WMI `Win32_Product` API to search, which is slower and has downsides. 

> Todo: Tets and use the registry method of uninstalling applications

We keep a copy of the downloaded `.msi` in a local cache directory. 
The default cache directory location is `C:\ProgramData\apm\`

# Quick Start

```powershell
PS C:\> apm -install supervisor
PS C:\> apm -install soft-agent
PS C:\> apm -install telephone-agent
```
    

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


# View about information about APM

You can see the current version and about section of APM by running:

    PS C:\> apm -about


# Copyright Notice

Amtelco, Intelligent Series, Infinity, Genesis, and related terms are copyright of Amtelco.

# License

Amtelco Package Manager (APM) is open-source software licensed under the MIT license.

