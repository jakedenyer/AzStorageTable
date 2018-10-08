function Get-AzStorageTableRowByColumnName
{
	<#
	.SYNOPSIS
		Returns one or more rows/entities based on a specified column and its value
	.DESCRIPTION
		Returns one or more rows/entities based on a specified column and its value
	.PARAMETER Table
		Table object of type Microsoft.WindowsAzure.Commands.Common.Storage.ResourceModel.AzureStorageTable to retrieve entities
	.PARAMETER ColumnName
		Column name to compare the value to
	.PARAMETER Value
		Value that will be looked for in the defined column
	.PARAMETER Operator
		Supported comparison operator. Valid values are "Equal","GreaterThan","GreaterThanOrEqual","LessThan" ,"LessThanOrEqual" ,"NotEqual"
	.EXAMPLE
		# Getting row by firstname
		$saContext = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
		$table = Get-AzStorageTable -Name $tableName -Context $saContext
		Get-AzStorageTableRowByColumnName -table $table -columnName "firstName" -value "Paulo" -operator Equal
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		$table,

		[Parameter(Mandatory=$true)]
		[string]$columnName,

		[Parameter(ParameterSetName="byString",Mandatory=$true)]
		[AllowEmptyString()]
		[string]$value,

		[Parameter(ParameterSetName="byGuid",Mandatory=$true)]
		[guid]$guidValue,

		[Parameter(Mandatory=$true)]
		[validateSet("Equal","GreaterThan","GreaterThanOrEqual","LessThan" ,"LessThanOrEqual" ,"NotEqual")]
		[string]$operator
	)
	
	# Filtering by Partition Key

	$tableQuery = New-Object -TypeName "Microsoft.WindowsAzure.Storage.Table.TableQuery"

	if ($PSCmdlet.ParameterSetName -eq "byString") {
		[string]$filter = `
			[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition($columnName,[Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::$operator,$value)
	}

	if ($PSCmdlet.ParameterSetName -eq "byGuid") {
		[string]$filter = `
			[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterConditionForGuid($columnName,[Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::$operator,$guidValue)
	}

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