#Requires -RunAsAdministrator

Write-Output ""

# Uninstall if already installed
Write-Output "[apm] Checking if apm module is installed..."
$exists = Get-Module apm

if( $exists )
{
    Write-Output "[apm] The apm powershell module is currently installed."
    Write-Output "[apm] Removing the existing apm powershell module..."
    Remove-Module apm -Force

}
else
{
    Write-Output "[apm] The apm powershell is not currently installed."
}

Write-Output "[apm] Downloading the latest version."
Write-Output "[apm] Extracting powershell module"
Write-Output "[apm] Installing apm ... "

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