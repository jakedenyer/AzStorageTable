function Remove-AzStorageTableRow
{
	<#
	.SYNOPSIS
		Remove-AzStorageTableRow - Removes a specified table row
	.DESCRIPTION
		Remove-AzStorageTableRow - Removes a specified table row. It accepts multiple deletions through the Pipeline when passing entities returned from the Get-AzureStorageTableRow
		available cmdlets. It also can delete a row/entity using Partition and Row Key properties directly.
	.PARAMETER Table
		Table object of type Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable where the entity exists
	.PARAMETER Entity (ParameterSetName=byEntityPSObjectObject)
		The entity/row with new values to perform the deletion.
	.PARAMETER PartitionKey (ParameterSetName=byPartitionandRowKeys)
		Partition key where the entity belongs to.
	.PARAMETER RowKey (ParameterSetName=byPartitionandRowKeys)
		Row key that uniquely identifies the entity within the partition.		 
	.EXAMPLE
		# Deleting an entry by entity PS Object
		$saContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext	
		[string]$filter1 = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition("firstName",[Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::Equal,"Paulo")
		[string]$filter2 = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition("lastName",[Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::Equal,"Marques")
		[string]$finalFilter = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::CombineFilters($filter1,"and",$filter2)
		$personToDelete = Get-AzStorageTableRowByCustomFilter -table $table -customFilter $finalFilter
		$personToDelete | Remove-AzStorageTableRow -table $table
	.EXAMPLE
		# Deleting an entry by using partitionkey and row key directly
		$saContext = (Get-AzRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext	
		Remove-AzStorageTableRow -table $table -partitionKey "TableEntityDemoFullList" -rowKey "399b58af-4f26-48b4-9b40-e28a8b03e867"
	.EXAMPLE
		# Deleting everything
		$saContext = (Get-AzRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext	
		Get-AzStorageTableRowAll -table $table | Remove-AzureStorageTableRow -table $table
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		$table,

		[Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName="byEntityPSObjectObject")]
		$entity,

		[Parameter(Mandatory=$true,ParameterSetName="byPartitionandRowKeys")]
		[AllowEmptyString()]
		[string]$partitionKey,

		[Parameter(Mandatory=$true,ParameterSetName="byPartitionandRowKeys")]
		[AllowEmptyString()]
		[string]$rowKey
	)

	begin
	{
		$updatedEntityList = @()
		$updatedEntityList += $entity

		if ($updatedEntityList.Count -gt 1)
		{
			throw "Delete operation cannot happen on an array of entities, altough you can pipe multiple items."
		}
		
		$results = @()
	}
	
	process
	{
		if ($PSCmdlet.ParameterSetName -eq "byEntityPSObjectObject")
		{
			$partitionKey = $entity.PartitionKey
			$rowKey = $entity.RowKey
		}

		$entityToDelete = invoke-expression "[Microsoft.WindowsAzure.Storage.Table.DynamicTableEntity](`$table.CloudTable.ExecuteAsync([Microsoft.WindowsAzure.Storage.Table.TableOperation]::Retrieve(`$partitionKey,`$rowKey))).Result.Result"
   
		if ($entityToDelete -ne $null)
		{
   			$results += $table.CloudTable.ExecuteAsync((invoke-expression "[Microsoft.WindowsAzure.Storage.Table.TableOperation]::Delete(`$entityToDelete)"))
		}
	}
	
	end
	{
		return ,$results
	}
}
