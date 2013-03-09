function AddPSSnapIn($name) {
	if ((Get-PSSnapin | ? { $_.Name -eq $name }) -eq $null){
		Add-PsSnapin $name
	}
}

function ImportModule($name) {
	if(-not(Get-Module -name $name)) {
		Import-Module $name
	}
}

function ExecutePowershellScript($cmd) {
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec:  $lastexitcode")
    }
}