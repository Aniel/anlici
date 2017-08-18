function ReinstallExtension(){
    Write-Host "Building package with vsce ..."
    vsce package -o build.vsix
    code --uninstall-extension aniel.anlici
    code --install-extension build.vsix
    Remove-Item build.vsix
}
$locaction = Get-Location
$path = Join-Path $locaction 'themes'
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $path
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $false
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName
Write-Host "Start watching for file changes..."
while($TRUE){
	$result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created, 1000);
	if($result.TimedOut){
		continue;
	}
	write-host "File " $result.Name " Changed. Installing extension.."
	ReinstallExtension
}