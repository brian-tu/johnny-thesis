# �]�w�q���H��H�M����H���q�l�l��a�}
$From = "johnnytu0401@gmail.com"
$To = "johnnytu0401@gmail.com"

# �]�w�q���l��D���M���e
$today = Get-Date
$Subject =  $today.ToString("yyyy-MM-dd") + "_����q���]�ư��d�H�����`�q��"

# �]�w SMTP ���A��
$SmtpServer = "smtp.gmail.com"
$SmtpPort = 587
$UserName = "johnnytu0401@gmail.com"
$Password = "wtxz figx qbkl xahx" # ���ε{���M�αK�X
$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName, $securePassword
$smtp = New-Object system.net.mail.smtpClient($SmtpServer, $SmtpPort)
$smtp.EnableSsl = $true
$smtp.Credentials = $Credential

# �]�wSQL Server���s����T
$server = "TAMKANG-s1"
$database = "maintain"
$table = "computer"
$connectionString = "Server=$server;Database=$database;User Id=maintain;Password=Zxcv1234;"

# ===1===
# �p��30�ѫe�����
$thirtyDaysAgo = $today.AddDays(-30).ToString("yyyy-MM-dd")

# �d��SQL��Ʈw�A�p��ŦX���󪺵���
$queryCount = @"
SELECT COUNT(*) AS RecordCount FROM $table WHERE computer_lastupdate < '$thirtyDaysAgo'
"@

# �d��SQL��Ʈw�A���o�ŦX���󪺸ԲӸ��
$queryData = @"
SELECT * FROM $table WHERE computer_lastupdate < '$thirtyDaysAgo'
"@

# �s��SQL�ð���d��
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# �s��SQL�ð���d�ߡ]���ơ^
$commandCount = $connection.CreateCommand()
$commandCount.CommandText = $queryCount
$recordCount = $commandCount.ExecuteScalar()

# �s��SQL�ð���d�ߡ]��ơ^
$commandData = $connection.CreateCommand()
$commandData.CommandText = $queryData
$reader = $commandData.ExecuteReader()

# �c�ضl�󤺮e
$body = "�W�L30�ѥ���s���q���O�������ơG " + $recordCount + "`n"
if ($recordCount -eq 0) {
    $body += "`n"
}
while ($reader.Read()) {
    $body += "�q���W��: " + $reader["computer_name"] + "`n"
    $body += "�q���ϥΪ�: " + $reader["computer_lastuser"] + "`n"
    $body += "�̫��s���: " + $reader["computer_lastupdate"] + "`n"
    $body += "`n"
}

# ===2===
# �d��SQL��Ʈw�A�p��ŦX���󪺵���
$queryCount = @"
SELECT COUNT(*) AS RecordCount FROM $table WHERE computer_lastsecure != 'protected'
"@

# �d��SQL��Ʈw�A���o�ŦX���󪺸ԲӸ��
$queryData = @"
SELECT * FROM $table WHERE computer_lastsecure != 'protected'
"@

# �s��SQL�ð���d��
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# �s��SQL�ð���d�ߡ]���ơ^
$commandCount = $connection.CreateCommand()
$commandCount.CommandText = $queryCount
$recordCount = $commandCount.ExecuteScalar()

# �s��SQL�ð���d�ߡ]��ơ^
$commandData = $connection.CreateCommand()
$commandData.CommandText = $queryData
$reader = $commandData.ExecuteReader()

# �c�ضl�󤺮e
$body += "���r�n�骬�A���`���q���O�������ơG " + $recordCount + "`n"
if ($recordCount -eq 0) {
    $body += "`n"
}
while ($reader.Read()) {
    $body += "�q���W��: " + $reader["computer_name"] + "`n"
    $body += "�q���ϥΪ�: " + $reader["computer_lastuser"] + "`n"
    $body += "���A���`��: " + $reader["computer_lastsecure"] + "`n"
    $body += "`n"
}

# ===3===
# �d��SQL��Ʈw�A�p��ŦX���󪺵���
$queryCount = @"
SELECT COUNT(*) AS RecordCount FROM $table WHERE computer_compliant != 'Y'
"@

# �d��SQL��Ʈw�A���o�ŦX���󪺸ԲӸ��
$queryData = @"
SELECT * FROM $table WHERE computer_compliant != 'Y'
"@

# �s��SQL�ð���d��
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# �s��SQL�ð���d�ߡ]���ơ^
$commandCount = $connection.CreateCommand()
$commandCount.CommandText = $queryCount
$recordCount = $commandCount.ExecuteScalar()

# �s��SQL�ð���d�ߡ]��ơ^
$commandData = $connection.CreateCommand()
$commandData.CommandText = $queryData
$reader = $commandData.ExecuteReader()

# �c�ضl�󤺮e
$body += "GCB�X�W���A���`���q���O�������ơG " + $recordCount + "`n"
if ($recordCount -eq 0) {
    $body += "`n"
}
while ($reader.Read()) {
    $body += "�q���W��: " + $reader["computer_name"] + "`n"
    $body += "�q���ϥΪ�: " + $reader["computer_lastuser"] + "`n"
    $body += "���A���`��: " + $reader["computer_compliant"] + "`n"
    $body += "`n"
}

# ===4===
# �d��SQL��Ʈw�A�p��ŦX���󪺵���
$queryCount = @"
SELECT COUNT(*) AS RecordCount FROM $table WHERE computer_appupdate != 'Y'
"@

# �d��SQL��Ʈw�A���o�ŦX���󪺸ԲӸ��
$queryData = @"
SELECT * FROM $table WHERE computer_appupdate != 'Y'
"@

# �s��SQL�ð���d��
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# �s��SQL�ð���d�ߡ]���ơ^
$commandCount = $connection.CreateCommand()
$commandCount.CommandText = $queryCount
$recordCount = $commandCount.ExecuteScalar()

# �s��SQL�ð���d�ߡ]��ơ^
$commandData = $connection.CreateCommand()
$commandData.CommandText = $queryData
$reader = $commandData.ExecuteReader()

# �c�ضl�󤺮e
$body += "���γn���s���A���`���q���O�������ơG " + $recordCount + "`n"
if ($recordCount -eq 0) {
    $body += "`n"
}
while ($reader.Read()) {
    $body += "�q���W��: " + $reader["computer_name"] + "`n"
    $body += "�q���ϥΪ�: " + $reader["computer_lastuser"] + "`n"
    $body += "���A���`��: " + $reader["computer_appupdate"] + "`n"
    $body += "`n"
}

$reader.Close()
$connection.Close()

# �p�G���ŦX���O���A�o�e�q�l�l��
if ($body) {
    # �e�X�q���l��
    $Message = New-Object System.Net.Mail.MailMessage $From, $To, $Subject, $body
    $Message.IsBodyHtml = $false
    $Message.SubjectEncoding = [System.Text.Encoding]::UTF8
    $Message.BodyEncoding = [System.Text.Encoding]::UTF8
    $smtp.Send($Message)
} else {
    # Write-Host "�L�W�L30�ѥ���s���q���O���C"
}
