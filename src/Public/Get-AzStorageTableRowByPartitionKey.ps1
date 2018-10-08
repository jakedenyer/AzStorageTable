function Get-AzStorageTableRowByPartitionKey
{
	<#
	.SYNOPSIS
		Returns one or more rows/entities based on Partition Key
	.DESCRIPTION
		Returns one or more rows/entities based on Partition Key
	.PARAMETER Table
		Table object of type Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable to retrieve entities
	.PARAMETER PartitionKey
		Identifies the table partition
	.EXAMPLE
		# Getting rows by partition Key
		$saContext = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzureStorageTable -Name $tableName -Context $saContext
		Get-AzureStorageTableRowByPartitionKey -table $table -partitionKey $newPartitionKey
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		$table,

		[Parameter(Mandatory=$true)]
		[AllowEmptyString()]
		[string]$partitionKey
	)
	
	# Filtering by Partition Key


	$tableQuery = New-Object -TypeName "Microsoft.WindowsAzure.Storage.Table.TableQuery"

	[string]$filter = `
		[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition("PartitionKey",`
		[Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::Equal,$partitionKey)

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
