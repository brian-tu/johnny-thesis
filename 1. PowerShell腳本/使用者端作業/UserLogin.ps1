# �w�q��Ʈw�s�u�r��
$connectionString = "Server=tamkang-s1;Database=maintain;User Id=maintain;Password=Zxcv1234;"

# �����e�ϥΪ̪��ԲӸ��
$username = $env:USERNAME
$computerName = $env:COMPUTERNAME

# �����e����M�ɶ�
$loginDate = Get-Date -Format "yyyy-MM-dd"
$loginTime = Get-Date -Format "HH:mm:ss"

# ��� IP �a�}
$ipAddress = (Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPv4Address.ToString()

# �P�_�O�_���P�����άP����
$isWeekend = if ((Get-Date).DayOfWeek -eq 'Saturday' -or (Get-Date).DayOfWeek -eq 'Sunday') {
    'Y'
} else {
    'N'
}

# �ϥ� [adsisearcher] �M LDAP �d�������e�ϥΪ̪��y�z��줺�e
try {
    $userSearcher = New-Object DirectoryServices.DirectorySearcher
    $userSearcher.Filter = "(&(objectCategory=person)(objectClass=user)(sAMAccountName=$username))"
    $userSearcher.PropertiesToLoad.Add("description") | Out-Null
    $adUser = $userSearcher.FindOne()

    # ����y�z��쪺��
    $description = if ($adUser.Properties["description"]) {
        $adUser.Properties["description"][0]
    } else {
        ""
    }
} catch {
    Write-Error "�L�k�q AD �����o�ϥΪ̴y�z: $_"
    $description = ""
}

# �P�_�q���W�٬O�_�P�ϥΪ̴y�z�ۦP
$isComputerNameMatch = if ($computerName -eq $description) {
    'Y'
} else {
    'N'
}

# SQL �d�߫��O�A�d�߸ӨϥΪ̳̪�@�����n�J����B�ɶ��ιq���W��
$sqlQuery = @"
SELECT TOP 1 computer_date, computer_time, computer_name 
FROM wmsinfo 
WHERE computer_user = '$username' 
ORDER BY computer_date DESC, computer_time DESC
"@

# ��l���ܼƨӦs��d�ߵ��G
$loginDate1 = ""
$loginTime1 = ""
$computerName1 = ""

# ���� SQL �d�߫��O
try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.CommandText = $sqlQuery
    $reader = $command.ExecuteReader()

    if ($reader.Read()) {
        # ����̪�@�����n�J���
        $loginDate1 = $reader["computer_date"]
        $loginTime1 = $reader["computer_time"]
        $computerName1 = $reader["computer_name"]
    } else {
        # �Y�L��ƫh��ܵL�n�J�O��
        Write-Error "��Ʈw���L�n�J�O��: $_"
    }
    $reader.Close()
    $connection.Close()
} catch {
    Write-Error "�L�k�q��Ʈw�����o�n�J�ԲӸ��: $_"
}

# �w�q SQL ���J���O
$sqlCommand = @"
INSERT INTO wmsinfo (computer_user, computer_date, computer_time, computer_name, computer_ip, computer_daysoff, computer_auth)
VALUES ('$username', '$loginDate', '$loginTime', '$computerName', '$ipAddress', '$isWeekend', '$isComputerNameMatch')
"@

# ���� SQL ���O
try {
    # �إ߸�Ʈw�s�u
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    # �إ� SQL �R�O�ð��洡�J�ާ@
    $command = $connection.CreateCommand()
    $command.CommandText = $sqlCommand
    $command.ExecuteNonQuery()

    # ������Ʈw�s�u
    $connection.Close()
} catch {
    # ��������ܿ��~�T��
    Write-Error "�L�k�O���n�J�ԲӸ��: $_"
}

# ���J System.Windows.Forms �Өϥ� MessageBox
Add-Type -AssemblyName System.Windows.Forms

# �p�G�d�ߵ��G�s�b�A��� MessageBox
if ($loginDate1 -ne "" -and $loginTime1 -ne "" -and $computerName1 -ne "") {
    $message = $username + "�̪�@���n�J��T�G" + "`n" +
               "�n�J���: $loginDate1" + "`n" +
               "�n�J�ɶ�: $loginTime1" + "`n" +
               "�n�J�q��: $computerName1"
    [System.Windows.Forms.MessageBox]::Show($message, "�̪�@���n�J��T", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}