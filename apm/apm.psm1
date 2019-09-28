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
    Write-Warning "THIS SOFTWARE IS CURRENTLY NOT PRODUCTION READY. THANK YOU FOR BETA TESTING."
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
    Write-Output "Save your Amtelco FTP credentials securely"
    Write-Output "apm -credentials save"
    Write-Output ""
    Write-Output "Install the latest general availability release of Intelligent Series Supervisor"
    Write-Output "apm -install supervisor"
    Write-Output ""
    Write-Output "Uninstall the currently installed version of Intelligent Series Supervisor"
    Write-Output "apm -remove supervisor"
    Write-Output ""
    Write-Output "See information about apm"
    Write-Output "apm -about"
    Write-Output ""
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  -credentials <save|clear>   Specify the package to install. Supported packages are soft-agent, telephone-agent, and supervisor"
    Write-Output "  -install <package>          Specify the package to install. Supported packages are soft-agent, telephone-agent, and supervisor"
    Write-Output "  -remove <package>           Removes the specified package from the system."
    Write-Output "  -about                      Displays the application version and contact information"
    Write-Output "  -available                  Displays a list of available packages supported"
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
            $url = "https://service.amtelco.com/ftp/softwaredisk/ISeries_5.03.0x/Soft_Agent/Current_Release/5.03.6774.63/Amtelco.Agent.Agent.Setup.msi"
            $filename = "Amtelco_Intelligent_Series_Soft_Agent_5.03.6774.63.msi"
        }
        "telephone-agent" {
              $url = "https://service.amtelco.com/ftp/softwaredisk/ISeries_5.03.0x/Windows_Operator/Current_Release/5.60.6774.19/WinOpSetup.msi"
              $filename = "Amtelco_Infinity_Telephone_Agent_5.60.6774.19.msi"
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

    Write-Output "[apm] Setting filename to $filename"

    # Set our location and filename to save the file
    $location = Join-Path -Path $folder -ChildPath $filename

    # Check if credentials exist
    if( ( Test-Path "$folder\credentials.xml" ) )
    {
       # This loads the encrypted credential string that was previously saved
       $credentials = Import-CliXml -Path "$folder\credentials.xml"
    }
    else
    {
        # This prompts a username/password message in a secure way to enter your service code.
        $credentials = Get-Credential -Message "Please authenticate with service.amtelco.com"
    }

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
        Write-Output "[apm] Application successfully installed! It's recommended to reboot your machine once you are done installing applications."
        Write-Output ""
    }
    else {
        Write-Output "[apm] ERROR installing application"
        Write-Output "[apm] Exit code of installer: $($result.ExitCode)"
        Write-Output "[apm] This probably means you need to remove the existing application first. "
        Write-Output ""
        Write-Output "Hint! Try: apm -remove $package"
        Write-Output ""
    }

    Write-Output "[apm] Done! Thank you for using apm $appVersion"
    Write-Output ""

    return
}

function Set-Credentials
{
    Param( [string] $action )

    Write-Output "[apm] Making sure the storage path exists at $folder"
    $created = New-Item -Path $folder -ItemType "directory" -Force


    if( $action -eq "save" )
    {
        Write-Output "[apm] Your service code will be encrypted and saved to the local filesystem."
        Write-Output "[apm] Please enter the username you use to login to Amtelco FTP site"

        $credentials = Get-Credential

        $credentials | Export-CliXml -Path "$folder\credentials.xml" -Force

        Write-Output ""
        Write-Output "[apm] Your credentials have been saved!"
        Write-Output ""
    }
    elseif( $action -eq "clear" )
    {

        if( Test-Path "$folder\credentials.xml" )
        {
            Remove-Item  "$folder\credentials.xml" -Force
        }

        Write-Output ""
        Write-Output "[apm] Your credentials have been cleared!"
        Write-Output ""
    }
    else
    {
    }

}

function Remove-Everything
{
    Write-Output "[apm] Cleaning all downloaded packages and settings"
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
            $appRemoval = "Soft Agent"
        }
        "telephone-agent" {
            $appRemoval = "Infinity Telephone Agent"
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

function apm
{
    param(
        [string] $install,
        [string] $remove,
        [switch] $about,
        [switch] $available,
        [string] $credentials
    )

    # Set our variables needed throughout the script
    $script:folder = "$Env:ProgramData\apm"
    $script:appVersion = "v0.0.4"

    # Show our welcome message
    Get-WelcomeMessage

    # Walk through the command line options
    if( $available )
    {
        # Show list of available packages
        Get-AvailableMessage
    }
    elseif( $about )
    {
        # Show the about message
        Get-AboutMessage
    }
    elseif( $credentials -and $credentials -ne "" )
    {
        Set-Credentials $credentials
    }
    elseif( $install -and $install -ne "" )
    {
        # Install the package
        Get-SoftwarePackage $install
    }
    elseif( $remove -and $remove -ne "" )
    {
        # Remove the package
        Remove-SoftwarePackage $remove
    }
    else
    {
        # Show our usage message
        Get-UsageMessage 
    }
}

# Export an alias "amtelco" so we can run "apm" or "amtelco" in the command line
New-Alias -Name amtelco -Value apm
