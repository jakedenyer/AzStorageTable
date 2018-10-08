function Get-AzStorageTableRowAll
{
	<#
	.SYNOPSIS
		Returns all rows/entities from a storage table - no filtering
	.DESCRIPTION
		Returns all rows/entities from a storage table - no filtering
	.PARAMETER Table
		Table object of type Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable to retrieve entities
	.EXAMPLE
		# Getting all rows
		$saContext = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext
		Get-AzStorageTableRowAll -table $table
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		$table
	)

	# No filtering

	$tableQuery = New-Object -TypeName "Microsoft.WindowsAzure.Storage.Table.TableQuery"

	$token = $null
	do
	{
		$results = $table.CloudTable.ExecuteQuerySegmentedAsync($tableQuery, $token)
		$token = $results.ContinuationToken;

	} while ($token -ne $null)


	if (-not [string]::IsNullOrEmpty($results.Result.Results))
	{
		return (Get-PSObjectFromEntity -entityList $results.Result.Results)
	}
}
