function Test-AzStorageTableEmptyKeys
{
	[CmdletBinding()]
	param
	(
		[string]$partitionKey,
        [String]$rowKey
	)
    
    $cosmosDBEmptyKeysErrorMessage = "Cosmos DB table API does not accept empty partition or row keys when using CloudTable.Execute operation, because of this we are disabling this capability in this module and it will not proceed." 

    if ([string]::IsNullOrEmpty($partitionKey) -or [string]::IsNullOrEmpty($rowKey))
    {
        Throw $cosmosDBEmptyKeysErrorMessage
    }
}
