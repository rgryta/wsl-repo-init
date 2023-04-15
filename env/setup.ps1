if (-not (Get-Module -ListAvailable -Name WSLTools)) {
    Install-Module -Name WSLTools -Force
} 

Import-Module WSLTools -WarningAction SilentlyContinue
if (-not (Ensure-WSL)) {
	$question = "Yes","No"
	$selected = Get-Select -Prompt "[OPER] Would you like to install HyperV and WSL now?" -Options $question
	if ($selected -eq "Yes") {
		iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/rgryta/PowerShell-WSLTools/main/install-wsl.ps1'))
		Write-Host "Reboot your system now and then restart the script"
	}
	if ($selected -eq "No") {
		Write-Host "Please set up HyperV and WSL manually and then relaunch the script"
	}
	return $false
}

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$distro = 'wsl-repo'
$ignr = wsl --unregister $distro

WSL-Ubuntu-Install -DistroAlias $distro -InstallPath $scriptPath -Version focal

wsl -d $distro -u root -e sh -c "apt-get install -y apt-utils sudo git curl"
wsl -d $distro -u root -e sh -c "echo ``wslpath -a '$scriptPath'``"

Write-Host 'Installation finished. Closing in 5 seconds'
Start-Sleep -Seconds 5