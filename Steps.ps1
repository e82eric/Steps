param($stepNumber)

$ErrorActionPreference = "Stop"
$script:steps = $null
$script:createScript = $null
$script:scriptPath = $MyInvocation.MyCommand.path
$script:stepNumber = $stepNumber

function Invoke-Steps($createScript) {
	$script:steps = @{}
	$script:createScript = $createScript
	
	. $createScript

	if($script:stepNumber -eq $null) {
		$script:stepNumber = 1
	} else {
		ClearRestartRegistrySettings
	}
	
	if($script:steps.ContainsKey($script:stepNumber ) -eq $true){
		$script:steps.get_item($script:stepNumber )
		$script:stepNumber ++
		RestartAndRun
	}
}

function Step ($stepNumber, $action) {
	$script:steps.add($stepNumber, $action)
}

function ClearRestartRegistrySettings() {
	Write-Host "Clearing Restart Settings"

	#Set-ItemProperty -Path $script:winLogonPath -Name AutoAdminLogon -Value 0
	#Remove-ItemProperty $script:winLogonPath -Name DefaultUserName
	#Remove-ItemProperty $script:winLogonPath -Name DefaultPassword
	#Remove-ItemProperty $script:winLogonPath -Name ForceAutoLogon
	#Remove-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name temp_run
}

function RestartAndRun() {
	$commandText = "cmd /k powershell . $script:scriptPath -stepNumber $script:stepNumber; Invoke-Steps $script:createScript" 
	
	Write-Host $commandText
	
	Invoke-Steps $script:createScript
	#Set-ItemProperty -Path $script:winLogonPath -Name AutoAdminLogon -Value 1
	#New-ItemProperty -Path $script:winLogonPath -Name DefaultUserName -Value "$script:domainNetBios\Administrator"
	#New-ItemProperty -Path $script:winLogonPath -Name DefaultPassword -Value $script:password
	#New-ItemProperty -Path $script:winLogonPath -PropertyType DWORD -Name ForceAutoLogon -Value 1
	#New-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name temp_run -Value $commandText

	#Restart-Computer
}