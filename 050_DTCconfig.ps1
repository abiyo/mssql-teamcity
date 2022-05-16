# Optional

if ($env:host_list) {Set-Content hosts.txt $env:host_list -Force}       # env:host_list - values are entered before starting the pipeline
$serverlist = Get-Content hosts.txt                                     # if env:host_list won't be enter, that it take from file in folder
$user = "domain.example.com\$env:admin_user"                            # env:admin_user - pipeline variable
$pass = ConvertTo-SecureString $env:admin_pass -AsPlainText -Force      # env:admin_pass - pipeline variable
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
$s = New-PSSession -ComputerName $serverlist -Credential $cred

Invoke-Command -Session $s -ScriptBlock {
    net stop msdtc
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC" /v AllowOnlySecureRpcCalls /t REG_DWORD /d 0 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC" /v TurnOffRpcSecurity /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security" /v NetworkDtcAccess /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security" /v NetworkDtcAccessAdmin /t REG_DWORD /d 0 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security" /v NetworkDtcAccessClients /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security" /v NetworkDtcAccessInbound /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security" /v NetworkDtcAccessOutbound /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security" /v NetworkDtcAccessTransactions /t REG_DWORD /d 1 /f
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security" /v FallbackToUnsecureRPCIfNecessary /t REG_DWORD /d 0 /f
    net start msdtc
    }
