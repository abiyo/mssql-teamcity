# Required, if will be used copy from smb-share

if ($env:host_list) {Set-Content hosts.txt $env:host_list -Force}       # env:host_list - values are entered before starting the pipeline
$serverlist = Get-Content hosts.txt                                     # if env:host_list won't be enter, that it take from file in folder
$user = "domain.example.com\$env:admin_user"                            # env:admin_user - pipeline variable
$pass = ConvertTo-SecureString $env:admin_pass -AsPlainText -Force      # env:admin_pass - pipeline variable
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
$s = New-PSSession -ComputerName $serverlist -Credential $cred
$Distr = "\\smb-share.example.com\share\MSSQL2019\"
$DistrSMS = "\\smb-share.example.com\share\SSMS-Setup-ENU.exe"
$Dest = "E:\distr\MSSQL\"

Invoke-Command -Computername $serverlist -Credential $cred -ScriptBlock {New-Item -Path $using:Dest -ItemType Directory -Force}
Invoke-Command -Computername $serverlist -Credential $cred -ScriptBlock {Copy-Item -path $using:Distr -Destination $using:Dest -Recurse -Force} -ConfigurationName dsql2
Invoke-Command -Computername $serverlist -Credential $cred -ScriptBlock {Copy-Item -path $using:DistrSMS -Destination $using:Dest -Recurse -Force} -ConfigurationName dsql2
#Remove-PSSession $serverlist