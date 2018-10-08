function Get-LatestFullAssemblyName
{
	param
	(
		[string]$dllName
	)

	# getting list of all assemblies
	$assemblies = [appdomain]::currentdomain.getassemblies() | Where-Object {$_.location -like "*$dllName"}	
	if ($assemblies -eq $null)
	{
		throw "Could not identify any assembly related to DLL named $dllName"
	}

	$sanitazedAssemblyList = @()
	foreach ($assembly in $assemblies)
	{
		[version]$version = $assembly.fullname.split(",")[1].split("=")[1]
		$sanitazedAssemblyList += New-Object -TypeName psobject -Property @{"version"=$version;"fullName"=$assembly.fullname}
	}

	return ($sanitazedAssemblyList | Sort-Object version -Descending)[0]
}