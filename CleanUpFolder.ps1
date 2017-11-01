# This script cleans up a Folder by moving the files older than N days to a temporary folder.
# After N+M days the files are permanently deleted
# It also sends an HTML report via email

# Source from other scripts
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
. $ScriptPath\CleanUpFolder_Functions.ps1
. $ScriptPath\Send-ToEmail.ps1

# Variables
$BasePath = "C:\Users\roberto\Downloads"
$TempFolder = "C:\Users\roberto\Downloads\PorBorrarse"
$days2Move = 120
$days2Delete = 30
$subdirs = $false
$reportMoved = "$ScriptPath\archivos_movidos.html"
$reportDeleted = "$ScriptPath\archivos_borrados.html"

$files = GetOldFiles -BasePath $BasePath  -DaysOld $days2Move
$CountMoved = $files.Count
$attachments = @()

Write-Output "Se van a mover $CountMoved archivos..."

if ($CountMoved -gt 0 ) {
	
	Export2HTML -FileList $files -HTMLFile $reportMoved
	
	$attachments += $reportMoved
	
	if(!(Test-Path $TempFolder))
	{
		New-Item -Path $TempFolder -ItemType Directory | Out-Null
	}
	
	$files | Move-Item -Destination $TempFolder
	
	Write-Output "se movieron $CountMoved archivos"
}

$filesDel = GetOldFiles -BasePath $TempFolder  -DaysOld ($days2Move + $days2Delete)
$CountDeleted = $filesDel.Count

Write-Output "Se van a ELIMINAR $CountDeleted archivos..."

if ($CountDeleted -gt 0) {
	
	Export2HTML -FileList $filesDel -HTMLFile $reportDeleted
	
	$attachments += $reportDeleted
	
	$filesDel | Remove-Item -Force
}

$Body = "Se movieron <strong>$CountMoved</strong> archivos que tenían más de $days2Move días sin acceder a ellos.<br/>"
$Body += "Los archivos se movieron a la carpeta <code>$TempFolder</code><br/>"
$Body += "Se Eliminaron <strong>$CountDeleted</strong> archivos que tenían más de $($days2Move + $days2Delete) días sin acceder a ellos."
	
Send-ToEmail  -email "rfigueroa@gcmex.com" -subject "$CountMoved Movidos -- $CountDeleted Eliminados" -body $Body -attachments $attachments;

Write-Output "Proceso terminado."