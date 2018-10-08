function Get-PSObjectFromEntity
{
	# Internal function
	# Converts entities output from the ExecuteQuery method of table into an array of PowerShell Objects

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		$entityList
	)

	$returnObjects = @()

	if (-not [string]::IsNullOrEmpty($entityList))
	{
		foreach ($entity in $entityList)
		{
			$entityNewObj = New-Object -TypeName psobject
			$entity.Properties.Keys | ForEach-Object {Add-Member -InputObject $entityNewObj -Name $_ -Value $entity.Properties[$_].PropertyAsObject -MemberType NoteProperty}

			# Adding table entity other attributes
			Add-Member -InputObject $entityNewObj -Name "PartitionKey" -Value $entity.PartitionKey -MemberType NoteProperty
			Add-Member -InputObject $entityNewObj -Name "RowKey" -Value $entity.RowKey -MemberType NoteProperty
			Add-Member -InputObject $entityNewObj -Name "TableTimestamp" -Value $entity.Timestamp -MemberType NoteProperty
			Add-Member -InputObject $entityNewObj -Name "Etag" -Value $entity.Etag -MemberType NoteProperty

			$returnObjects += $entityNewObj
		}
	}

	return $returnObjects

}