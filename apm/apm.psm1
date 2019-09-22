
#Requires -RunAsAdministrator

# Remove before going
Set-PSDebug -Strict

function Get-AboutMessage
{
    Write-Output "apm (Amtelco package manager) is an un-official command line utility for installing the latest release of Amtelco Intelligent Series software."
    Write-Output "Created by Patrick Labbett of NotifiUs, LLC for the NAEO community."
    Write-Output ""
    Write-Output "apm version $appVersion"
    Write-Output ""
    Write-Output "Official download location:"
    Write-Output "  https://github.com/notifius/apm"
    Write-Output ""
    Write-Output "Please do not download or run copies of this script from any other location."
    Write-Output "This is the only official download source."
    Write-Output ""
    Write-Output "Contact information:"
    Write-Output "  Email:  support@notifi.us"
    Write-Output "  Web:    https://notifi.us"
    Write-Output ""
    Write-Output "Ways to support this project:"
    Write-Output "  Hire us! Contact patrick.labbett@notifi.us"
    Write-Output "  Subscribe to Call Theory at https://calltheory.com"
    Write-Output ""
    Write-Output "Suggestions/feedback? Send them to support@notifi.us"
    Write-Output "Thank you for using apm!"
    Write-Output ""
    Write-Output "`"It's dangerous to go alone. Take this.`""
    Write-Output ""
    Write-Output "          />__________________________________"
    Write-Output "[##=APM=###[]_________________________________>"
    Write-Output "          \>"
    Write-Output ""
    
     return
}
function Get-WelcomeMessage
{
    Write-Output ""
    Write-Output "[apm] Welcome to the amtelco package manager (apm) $appVersion by Patrick Labbett <patrick.labbett@notifi.us>"
    Write-Output ""
}


function Get-AdminRequiredMessage
{
    Write-Output "[apm] Please run this command as an administrator."
    Write-Output ""
}
function Get-UsageMessage
{
    Write-Output "Description:"
    Write-Output ""
    Write-Output "apm (Amtelco package manager) is an un-official command line utility for installing the latest release of Amtelco Intelligent Series software."
    Write-Output "Created by Patrick Labbett of NotifiUs, LLC for the NAEO community."
    Write-Output ""
    Write-Output "Usage:"
    Write-Output ""
    Write-Output "See a list of installable software packages"
    Write-Output "apm -available"
    Write-Output ""
    Write-Output "Install the latest general availability release of Intelligent Series Supervisor"
    Write-Output "apm -install supervisor"
    Write-Output ""
    # Write-Output "Install the latest general availability release from the 5.02 branch"
    # Write-Output ".\apm.ps1 -install supervisor -version 5.02"
    # Write-Output ""
    Write-Output "Install the latest general availability release and save the installer to c:\custom"
    Write-Output "apm -install supervisor -folder C:\custom"
    Write-Output ""
    Write-Output "Uninstall the currently installed version of Intelligent Series Supervisor"
    Write-Output "apm -remove supervisor"
    Write-Output ""
    # Write-Output "Update apm to the latest version:"
    # Write-Output ".\apm.ps1 -selfupdate"
    # Write-Output ""
    Write-Output "See information about apm"
    Write-Output "apm -about"
    Write-Output ""
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  -folder C:\path     Specify the folder where downloaded installer files are saved. Defaults to C:\apm"
    Write-Output "  -install            Specify the package to install. Supported packages are soft-agent, telephone-agent, and supervisor"
    Write-Output "  -remove             Removes the specified package from the system."
    # Write-Output "  -version 5.03       Specify the major version branch to download the package from."
    # Write-Output "  -selfupdate         Updates apm to the latest version"
    Write-Output "  -about              Displays the application version and contact information"
    Write-Output "  -available          Displays a list of available packages supported"
    Write-Output ""
     return
}

function Get-AvailableMessage
{

    $packages = @{
        supervisor = "Intelligent Series Supervisor application";
        "soft-agent" = "Operator application for Genesis";
        "telephone-agent" = "Operator application for Infinity";

    }
    
    Write-Output "[apm] Available packages are:"
    Write-Output $packages | Format-Table
    
     return
}

function Get-SoftwarePackage
{
    Param( [string] $package )

    switch( $package )
    {
        "supervisor" {
            $url = "https://service.amtelco.com/ftp/softwaredisk/ISeries_5.03.0x/Supervisor/Current_Release/5.03.6774.60/ISSupSetup.msi"
            $filename = "Amtelco_Intelligent_Series_Supervisor_5.03.6774.60.msi"
        }
        "soft-agent" { 
            Write-Output ""
            Write-Output "[apm] Support for Soft Agent coming soon!"
            Write-Output ""
             return
            
        }
        "telephone-agent" {
            Write-Output ""
            Write-Output "[apm] Support for Telephone Agent coming soon!"
            Write-Output ""
             return
            
         }
         default {
            Write-Output ""
            Write-Output "[apm] No package found using this alias. Please try supervisor, soft-agent, or telephone-agent"
            Write-Output ""
             return
            
         }
    }

    Write-Output "[apm] Making sure the storage path exists at $folder"
    $created = New-Item -Path $folder -ItemType "directory" -Force
    
    Write-Output "[apm] Package link selected: $url"

    $filename = "Amtelco_Intelligent_Series_Supervisor_5.03.6774.60.msi"
    Write-Output "[apm] Setting filename to $filename"


    # Set our location and filename to save the file
    $location = Join-Path -Path $folder -ChildPath $filename

    # This prompts a username/password message in a secure way to enter your service code.
    $credentials = Get-Credential -Message "Please authenticate with service.amtelco.com"

    if( ! $credentials )
    {
        Write-Output "[apm] No username and password given...exiting."
        Write-Output ""
         return
    }

    # Our web client that will fetch and download our software.
    $web = New-Object System.Net.WebClient

    # Assign our entered credentials to our web client.
    $web.Credentials = $credentials

    Write-Output "[apm] Beginning download..."
    # Download the file at $url and save it as $file
    $web.DownloadFile( $url, $location ) 

    Write-Output "[apm] ...download complete."

    Write-Output "[apm] Downdload successfully saved to $location"

    Write-Output "[apm] Installing package..."

    $result = Start-Process -FilePath "msiexec.exe" -ArgumentList "/package `"$location`" /passive /qn" -Wait -Passthru

    

    if( $result.ExitCode -eq 0 )
    {
        Write-Output "[apm] Application successfully installed! It's recommended to reboot your machine."
        Write-Output ""
    }
    else {
        Write-Output "[apm] ERROR installing application"
        Write-Output "[apm] Exit code of installer:"
        Write-Output $result.ExitCode
        Write-Output "" 
    }

    Write-Output "[apm] Done! Thank you for using apm $appVersion"
    Write-Output ""

     return
}

function Get-SelfUpdateMessage
{
    Write-Output "[apm] Self update capability is under development"
    Write-Output ""
    return
}
function Remove-SoftwarePackage
{
    Param( [string] $remove )

    switch( $remove )
    {
        "supervisor" {
            $appRemoval = "Intelligent Series Supervisor"
        }
        "soft-agent" { 
            Write-Output ""
            Write-Output "[apm] Support for Soft Agent coming soon!"
            Write-Output ""
             return
            
        }
        "telephone-agent" {
            Write-Output ""
            Write-Output "[apm] Support for Telephone Agent coming soon!"
            Write-Output ""
             return
            
         }
         default {
            Write-Output ""
            Write-Output "[apm] No package found using this alias. Please try supervisor, soft-agent, or telephone-agent"
            Write-Output ""
             return
            
         }
    }

    Write-Output "[apm] Searching for installed application... (This can take a few moments)"
    $installed = Get-WmiObject -Class Win32_Product -Filter "Name = '$appRemoval' and Vendor = 'Amtelco'"

    if( $installed )
    {
        Write-Output $installed

        Write-Output "[apm] Removing program: $remove ($appRemoval). Please wait..."
    
        #$uninstallResult = $app.uninstall();
        $uninstallResult = $installed.uninstall()

       if( $uninstallResult.ReturnValue -eq 0 )
       {
        Write-Output "[apm] Successfully removed $appRemoval!"
       }
       else
       {
        Write-Output "[apm] ERROR removing application. Try removing it manually."
       }
        
       Write-Output "[apm] Done! Thank you for using apm $appVersion"
        Write-Output ""
        return
    }
    else {
        Write-Output "[apm] Program is not installed. Nothing to do."
        Write-Output ""
        return
    }
   
}


function APM
{
    param(
    
        [string] $folder = "C:\apm\",
        [string] $install,
        [string] $remove,
        [string] $version,
        [switch] $about,
        [switch] $available,
        [switch] $selfupdate
    )

    $script:appVersion = "v0.0.1"

    Get-WelcomeMessage
    
    if( $available )
    {
        Get-AvailableMessage
    }
    # elseif( $selfupdate )
    # {
    #     Get-SelfUpdateMessage
    # }
    elseif( $about )
    {
        Get-AboutMessage
    }
    elseif( $install -and $install -ne "" )
    {
        Get-SoftwarePackage $install
    }
    elseif( $remove -and $remove -ne "" )
    {
        Remove-SoftwarePackage $remove  
    }
    else
    {
        Get-UsageMessage 
    }
}

New-Alias -Name amtelco -Value APM
