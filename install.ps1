    #Requires -RunAsAdministrator

    Write-Output ""

    # Uninstall if already installed
    Write-Output "[apm] Checking if apm module is installed..."
    $exists = Get-Module apm

    if( $exists )
    {
        Write-Output "[apm] The apm powershell module is currently installed."
        Write-Output "[apm] Removing any existing apm powershell module..."
        Remove-Module apm -Force
    }
    else
    {
        Write-Output "[apm] The apm powershell is not currently installed."
    }

    Write-Output "[apm] Removed ProgramData and PSModules apm folders."
    Remove-Item  $Env:ProgramData\apm -Recurse -Force
    Remove-Item  $Env:ProgramFiles\WindowsPowerShell\Modules\apm -Recurse -Force

    Write-Output "[apm] Downloading the latest version."

    Write-Output "[apm] Making sure the storage path exists at $Env:ProgramData\apm"
    $baseFolder = New-Item -Path $Env:ProgramData\apm  -ItemType "directory" -Force

    $url = "https://github.com/NotifiUs/apm/archive/master.zip"
    $filename = "apm-master.zip"

    $location = Join-Path -Path $Env:ProgramData\apm -ChildPath $filename

    # Our web client that will fetch and download our software.
    $web = New-Object System.Net.WebClient

    Write-Output "[apm] Beginning download..."
    # Download the file at $url and save it as $file
    $web.DownloadFile( $url, $location )


    Write-Output "[apm] Extracting powershell module"

    $output = "$Env:ProgramData\apm"

    Expand-Archive -LiteralPath $location -DestinationPath $output -Force

    Write-Output "[apm] Installing apm to $Env:ProgramFiles\WindowsPowerShell\Modules"


    Copy-Item -Path "$Env:ProgramData\apm\apm-master\apm" -Destination "$Env:ProgramFiles\WindowsPowerShell\Modules" -Recurse -Force

    $importResult = Import-Module -Name apm
    Write-Output $importResult | format-table
    Write-Output "[apm] Complete!"

    Write-Output ""
    Write-Output "Official download location:"
    Write-Output "  https://github.com/notifius/apm"
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
    Write-Output "Try running ``apm`` to get started!"
    Write-Output ""