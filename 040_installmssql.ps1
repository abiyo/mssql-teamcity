# Required

if ($env:host_list) {Set-Content hosts.txt $env:host_list -Force}       # env:host_list - values are entered before starting the pipeline
$serverlist = Get-Content hosts.txt                                     # if env:host_list won't be enter, that it take from file in folder
$user = "domain.example.com\$env:admin_user"                            # env:admin_user - pipeline variable
$pass = ConvertTo-SecureString $env:admin_pass -AsPlainText -Force      # env:admin_pass - pipeline variable
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
$s = New-PSSession -ComputerName $serverlist -Credential $cred

Invoke-Command -Session $s -ScriptBlock {
    if ( -not (Get-Service "MSSQLSERVER" -ErrorAction SilentlyContinue))
        {
        e:\distr\MSSQL\MSSQL2019\setup.exe `
        /Q `
        /IACCEPTSQLSERVERLICENSETERMS `
        /ACTION="install" `
        /SQMREPORTING="False" `
        /ERRORREPORTING="False" `
        /FEATURES=SQL,AS,IS,Tools `
        /INSTANCENAME=MSSQLSERVER `
        /TCPENABLED=1 `
        /SQLCOLLATION='Cyrillic_General_CI_AS' `
        /SQLSVCACCOUNT="NT Service\MSSQLSERVER" `
        /SQLSYSADMINACCOUNTS='domain.example.com\ad-group' 'domain.example.com\ad-user' `
        /AGTSVCACCOUNT="NT Service\SQLSERVERAGENT" `
        /ISSVCAccount="NT AUTHORITY\NETWORK SERVICE" `
        /ASSYSADMINACCOUNTS='domain.example.com\ad-group' 'domain.example.com\ad-user' `
        /UpdateEnabled=False `
        /INSTALLSQLDATADIR="e:\Microsoft SQL Server" `
        /INSTANCEDIR="e:\Microsoft SQL Server" `
        /AGTSVCSTARTUPTYPE=Automatic `
        /ASBACKUPDIR="e:\Microsoft SQL Server\OLAP\Backup" `
        /ASCONFIGDIR="e:\Microsoft SQL Server\OLAP\Config" `
        /ASDATADIR="e:\Microsoft SQL Server\OLAP\Data" `
        /ASLOGDIR="e:\Microsoft SQL Server\OLAP\Log" `
        /ASTEMPDIR="e:\Microsoft SQL Server\OLAP\Temp"
        }
    }
