@{

    # ID used to uniquely identify this module
    GUID = '6936459b-8db4-4ed5-a890-5659169d26a5'
    
    # Author of this module
    Author = 'Jake Denyer (Original by Paulo Marques)'
    
    # Company or vendor of this module
    CompanyName = 'Secure-24'
    
    # Copyright statement for this module
    Copyright = ''
    
    # Description of the functionality provided by this module
    Description = ''
    
    # HelpInfo URI of this module
    HelpInfoUri = ''
    
    # Version number of this module
    ModuleVersion = '1.0.0'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '6.1'
    
    
    # Script module or binary module file associated with this manifest
    #ModuleToProcess = ''
    
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    RootModule = @('AzStorageTable.psm1')
    RequiredModules = @('Az.Storage', 'Az.Profile', 'Az.Resources')
    
    }