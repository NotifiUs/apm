#
# Module manifest for module 'apm'
#
# Created on: 09/21/2019
#

@{

    # Script module or binary module file associated with this manifest
    RootModule = '.\apm.psm1'

    # Version number of this module.
    ModuleVersion = '0.0.3'
    
    # ID used to uniquely identify this module
    GUID = '6AEC2CFE-3B2D-44C5-9349-ABB1739B181C'
    
    # Author of this module
    Author = 'Patrick Labbett'
    
    # Company or vendor of this module
    CompanyName = 'NotifiUs, LLC'
    
    # Copyright statement for this module
    Copyright = '(c) 2019 NotifiUs, LLC. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'apm (Amtelco package manager) is an un-official command line utility for installing the latest release of Amtelco Intelligent Series software'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = '4.0'
    
    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    # ScriptsToProcess = @()

    # Functions to export from this module
    FunctionsToExport = 'apm'
    
    # Cmdlets to export from this module
    CmdletsToExport = '*'

    # Variables to export from this module
    # VariablesToExport = '*'
    
    # Aliases to export from this module
    AliasesToExport = 'amtelco'
    
    # List of all modules packaged with this module
    ModuleList = @(
        'apm.psm1'
    )
    
    # List of all files packaged with this module
    FileList = @(
        'apm.psm1',
        'apm.psd1'
    )
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess
    # PrivateData = ''
    
    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/notifius/apm'
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
    
    }