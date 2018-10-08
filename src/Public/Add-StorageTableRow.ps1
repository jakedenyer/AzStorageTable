function Add-StorageTableRow
{
	<#
	.SYNOPSIS
		Adds a row/entity to a specified table
	.DESCRIPTION
		Adds a row/entity to a specified table
	.PARAMETER Table
		Table object of type Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable where the entity will be added
	.PARAMETER PartitionKey
		Identifies the table partition
	.PARAMETER RowKey
		Identifies a row within a partition
	.PARAMETER Property
		Hashtable with the columns that will be part of the entity. e.g. @{"firstName"="Paulo";"lastName"="Marques"}
	.EXAMPLE
		# Adding a row
		$saContext = (Get-AzRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext
		Add-StorageTableRow -table $table -partitionKey $partitionKey -rowKey ([guid]::NewGuid().tostring()) -property @{"firstName"="Paulo";"lastName"="Costa";"role"="presenter"}
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		$table,
		
		[Parameter(Mandatory=$true)]
		[AllowEmptyString()]
        [String]$partitionKey,

		[Parameter(Mandatory=$true)]
		[AllowEmptyString()]
        [String]$rowKey,

		[Parameter(Mandatory=$false)]
        [hashtable]$property
	)
	
	# Creates the table entity with mandatory partitionKey and rowKey arguments
	$entity = New-Object -TypeName "Microsoft.WindowsAzure.Storage.Table.DynamicTableEntity" -ArgumentList $partitionKey, $rowKey
    
    # Adding the additional columns to the table entity
	foreach ($prop in $property.Keys)
	{
		if ($prop -ne "TableTimestamp")
		{
			$entity.Properties.Add($prop, $property.Item($prop))
		}
	}
    
 	return ($table.CloudTable.Execute((invoke-expression "[Microsoft.WindowsAzure.Storage.Table.TableOperation]::insert(`$entity)")))
 
}

