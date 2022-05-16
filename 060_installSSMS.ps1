# Optional

if ($env:host_list) {Set-Content hosts.txt $env:host_list -Force}       # env:host_list - values are entered before starting the pipeline
$serverlist = Get-Content hosts.txt                                     # if env:host_list won't be enter, that it take from file in folder
$user = "domain.example.com\$env:admin_user"                            # env:admin_user - pipeline variable
$pass = ConvertTo-SecureString $env:admin_pass -AsPlainText -Force      # env:admin_pass - pipeline variable
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
$s = New-PSSession -ComputerName $serverlist -Credential $cred

Invoke-Command -Session $s -ScriptBlock {e:\distr\MSSQL\SSMS-Setup-ENU.exe /install /quiet /log e:\distr\log.txt /norestart SSMSInstallRoot=e:\MSSMS}