# Last amended: 26th July, 2026
# Powershell script
## Script to set VSCode terminal to open in the current
##  folder rather than in some other folder. It configures
##   VSCode's Settings through powershell script.

# cd /home/$USER
# wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/misc/script.ps1
#  powershell.exe -ExecutionPolicy Bypass -File '/home/ashok/script.ps1'

#------------------------
## ONLY for WSL Ubuntu
#------------------------

# 1. Target the correct Windows folder path
$dirPath = "$env:C:\Users\ashok\AppData\Roaming\Code\User"
$settingsPath = "$dirPath\settings.json"

# 2. Force create the folder path if it does not exist yet
if (!(Test-Path $dirPath)) {
    New-Item -ItemType Directory -Path $dirPath -Force
}

# 3. Read existing settings or build a clean object if it is a brand new file
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
} else {
    $settings = [PSCustomObject]@{ }
}

# 4. Inject the directory execution properties
$settings | Add-Member -NotePropertyName "python.terminal.executeInFileDir" -NotePropertyValue $true -Force
$settings | Add-Member -NotePropertyName "terminal.integrated.cwd" -NotePropertyValue '${fileDirname}' -Force
#$settings | Add-Member -NotePropertyName "terminal.integrated.cwd" -NotePropertyValue '/home/ashok' -Force


# 5. Convert back to JSON format and save
$settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath

################3
# Last amended: 27th July, 2026
# Powershell script
## Script to set VSCode to always open in the same folder
##  It configures VSCode's Settings through powershell script.

# 1. Define the VS Code settings file path
$dirPath = "$env:C:\Users\ashok\AppData\Roaming\Code\User"
$settingsPath = "$dirPath\settings.json"

# 2. Check if the file exists; if not, create an empty JSON object
if (-not (Test-Path $settingsPath)) {
    New-Item -ItemType File -Path $settingsPath -Force | Out-Null
    Set-Content -Path $settingsPath -Value "{}"
}

# 3. Read and parse the existing JSON data
$settings = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json

# 4. Add or update the window.restoreWindows setting
$settings | Add-Member -NotePropertyName "window.restoreWindows" -NotePropertyValue 'preserve' -Force

# 5. Save the updated configuration back to the file
$settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath

Write-Host "VS Code setting updated successfully!" -ForegroundColor Green

