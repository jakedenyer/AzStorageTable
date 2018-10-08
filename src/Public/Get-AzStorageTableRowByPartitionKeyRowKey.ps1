function Get-AzStorageTableRowByPartitionKeyRowKey
{
	<#
	.SYNOPSIS
		Returns one entitie based on Partition Key and RowKey
	.DESCRIPTION
		Returns one entitie based on Partition Key and RowKey
	.PARAMETER Table
		Table object of type Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable to retrieve entities
	.PARAMETER PartitionKey
		Identifies the table partition
	.PARAMETER RowKey
        Identifies the row key in the partition
	.EXAMPLE
		# Getting rows by Partition Key and Row Key
		$saContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext
		Get-AzStorageTableRowByPartitionKeyRowKey -table $table -partitionKey $newPartitionKey -rowKey $newRowKey
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		$table,

		[Parameter(Mandatory=$true)]
		[AllowEmptyString()]
		[string]$partitionKey,

		[Parameter(Mandatory=$true)]
		[AllowEmptyString()]
		[string]$rowKey

	)
	
	# Filtering by Partition Key and Row Key


	$tableQuery = New-Object -TypeName "Microsoft.WindowsAzure.Storage.Table.TableQuery,$assemblySN"

	[string]$filter1 = `
		[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition("PartitionKey",`
		[Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::Equal,$partitionKey)

	[string]$filter2 = `
		[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition("RowKey",`
		[Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::Equal,$rowKey)

        [string]$filter = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::CombineFilters($filter1,"and",$filter2)


	$tableQuery.FilterString = $filter

	$token = $null
	do
	{
		$result = $table.CloudTable.ExecuteQuerySegmentedAsync($tableQuery, $token)
		$token = $result.ContinuationToken;

	} while ($token -ne $null)

	if (-not [string]::IsNullOrEmpty($result.Result.Results))
	{
		return (Get-PSObjectFromEntity -entityList $result.Result.Results)
	}
}
