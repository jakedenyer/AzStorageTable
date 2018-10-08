#Requires -Modules Az.Storage, Az.Profile, Az.Resources

New-Alias -Name Add-AzStorageTableRow -Value Add-StorageTableRow
$arr = @()

$Public  = Get-ChildItem $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue
$Private = Get-ChildItem $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue

$arr += $($Public | Select-Object -ExpandProperty BaseName)
$arr += $($Private | Select-Object -ExpandProperty BaseName)
# Dot source the files
foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $arr -Alias *