function AddToPath ($pathToAdd) {
	$env:path += ";$pathToAdd\"
	[Environment]::SetEnvironmentVariable("PATH", $env:path, "MACHINE")
}
