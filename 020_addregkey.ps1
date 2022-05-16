# Required

if ($env:host_list) {Set-Content hosts.txt $env:host_list -Force}       # env:host_list - values are entered before starting the pipeline
$serverlist = Get-Content hosts.txt                                     # if env:host_list won't be enter, that it take from file in folder
$user = "domain.example.com\$env:admin_user"                            # env:admin_user - pipeline variable
$pass = ConvertTo-SecureString $env:admin_pass -AsPlainText -Force      # env:admin_pass - pipeline variable
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
$s = New-PSSession -ComputerName $serverlist -Credential $cred

Invoke-Command -Session $s -ScriptBlock {reg add "HKLM\SOFTWARE\Microsoft\Cryptography\Protect\Providers\df9d8cd0-1501-11d1-8c7a-00c04fc297eb" /v ProtectionPolicy /t REG_DWORD /d 1 /f}