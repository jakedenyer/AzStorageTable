function Get-AzStorageTableTable
{
	<#
	.SYNOPSIS
		Gets a Table object, it can be from Azure Storage Table or Cosmos DB in preview support.
	.DESCRIPTION
		Gets a Table object, it can be from Azure Storage Table or Cosmos DB in preview support.
	.PARAMETER resourceGroup
        Resource Group where the Azure Storage Account or Cosmos DB are located
    .PARAMETER tableName
        Name of the table to retrieve
    .PARAMETER storageAccountName
        Storage Account name where the table lives
	.EXAMPLE
		# Getting storage table object
		$resourceGroup = "myResourceGroup"
		$storageAccount = "myStorageAccountName"
		$tableName = "table01"
		$table = Get-AzStorageTabletable -resourceGroup $resourceGroup -tableName $tableName -storageAccountName $storageAccount
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(ParameterSetName="AzureRmTableStorage",Mandatory=$true)]
		[string]$resourceGroup,
		
		[Parameter(Mandatory=$true)]
        [String]$tableName,

		[Parameter(ParameterSetName="AzureRmTableStorage",Mandatory=$true)]
		[Parameter(ParameterSetName="AzureTableStorage",Mandatory=$true)]
        [String]$storageAccountName
	)

    $nullTableErrorMessage = [string]::Empty

    switch ($PSCmdlet.ParameterSetName)
    {
        "AzureRmTableStorage"
            {
				$saContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context	
                $nullTableErrorMessage = "Table $tableName could not be retrieved from Storage Account $storageAccountName on resource group $resourceGroupName"
            }
        "AzureTableStorage"
            {
				$saContext = (Get-AzStorageAccount -StorageAccountName $storageAccountName).Context
                $nullTableErrorMessage = "Table $tableName could not be retrieved from Classic Storage Account $storageAccountName"
            }
    }

	[Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable]$table = Get-AzStorageTable -Name $tableName -Context $saContext -ErrorAction SilentlyContinue

	# Creating a new table if one does not exist
	if ($table -eq $null)
	{
		[Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable]$table = New-AzStorageTable -Name $tableName -Context $saContext
	}

    # Checking if there a table got returned
    if ($table -eq $null)
    {
        throw $nullTableErrorMessage
    }

    # Returns the table object
    return [Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable]$table
}






