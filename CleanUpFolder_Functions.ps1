
#Returns files with Last Access Time older than $daysOld
Function GetOldFiles{
	
	param([string]$BasePath,
        [int]$DaysOld)
		
	$limit = (Get-Date).AddDays($DaysOld * -1)
	
	$files = @(Get-ChildItem -Path $BasePath | Where-Object { !$_.PSIsContainer -and $_.LastAccessTime -lt $limit })
	
	RETURN $files
	
}

# Writes the list of Files to an HTML file
Function Export2HTML {
	
	param([object]$FileList,
        [string]$HTMLFile)
		
$Header = @'

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Archivos próximos a Eliminarse</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="http://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js" charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="http://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" charset="UTF-8"/>
<script>

    $(document).ready(function() {
		$('#myTable').DataTable();
	} );

</script> 
</head>
<body> 

'@

$htmlTable = $FileList | Select Name, @{Name="Kbytes";Expression={ "{0:N1}" -f ($_.Length / 1Kb) } }, LastAccessTime | ConvertTo-HTML -Fragment 

$htmlTable = $htmlTable -Replace "<table>", "<table id=`"myTable`" class=`"display`" cellspacing=`"0`" width=`"100%`"><thead>" `
-Replace "</th></tr>", "</th></tr></thead><tbody>" `
-Replace "</table>", "</tbody></table>" `
-Replace "<colgroup><col/><col/><col/></colgroup>", "" `
-Replace "<colgroup>", "" `
-Replace "<col/>", "" `
-Replace "</colgroup>", ""

Set-Content $HTMLFile "$Header $htmlTable </body></html>"

# Output to the pipeline
Write-Output $HTMLFile
	
}