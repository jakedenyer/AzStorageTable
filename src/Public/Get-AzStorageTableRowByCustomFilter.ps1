function Get-AzStorageTableRowByCustomFilter
{
	<#
	.SYNOPSIS
		Returns one or more rows/entities based on custom filter.
	.DESCRIPTION
		Returns one or more rows/entities based on custom filter. This custom filter can be
		built using the Microsoft.WindowsAzure.Storage.Table.TableQuery class or direct text.
	.PARAMETER Table
		Table object of type Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable to retrieve entities
	.PARAMETER customFilter
		Custom filter string.
	.EXAMPLE
		# Getting row by firstname by using the class Microsoft.WindowsAzure.Storage.Table.TableQuery
		$saContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext
		Get-AzStorageTableRowByCustomFilter -table $table -customFilter $finalFilter
	.EXAMPLE
		# Getting row by firstname by using text filter directly (oData filter format)
		$saContext = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext
		Get-AzStorageTableRowByCustomFilter -table $table -customFilter "(firstName eq 'User1') and (lastName eq 'LastName1')"
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		$table,

		[Parameter(Mandatory=$true)]
		[string]$customFilter
	)
	
	# Filtering by Partition Key
	$tableQuery = New-Object -TypeName "Microsoft.WindowsAzure.Storage.Table.TableQuery"

	$tableQuery.FilterString = $customFilter

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
