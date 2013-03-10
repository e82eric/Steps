Steps
=====
A really minimal dsl and framework for creating development images using powershell.  (Mostly helps with handling restarts between installations) 

Execution:
```powershell
cmd powershell Set-ExecutionPolicy RemoteSigned;. C:\Steps.ps1;Invoke-Steps C:\CreateImage.ps1
```

Start from specific step:
```powershell
cmd powershell Set-ExecutionPolicy RemoteSigned;. C:\Steps.ps1 3;Invoke-Steps C:\CreateImage.ps1
```

Example:
```powershell
ConfigureSteps "Administrator" "pass@word1"

Step 1 {
  Write-Host "Execution Step 1"
}

Step 2 {
  Write-Host "Finished restarting and now executing step 2"
}

Step 3 {
  Write-Host "Finished restarting and now executing step 3"
}

Step 4 {
  Write-Host "Finished restarting and now executing step 4"
}
```
