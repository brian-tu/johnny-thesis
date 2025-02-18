# 設定通知寄件人和收件人的電子郵件地址
$From = "johnnytu0401@gmail.com"
$To = "johnnytu0401@gmail.com"

# 設定通知郵件主旨和內容
$today = Get-Date
$Subject =  $today.ToString("yyyy-MM-dd") + "_網域電腦設備健康信任異常通知"

# 設定 SMTP 伺服器
$SmtpServer = "smtp.gmail.com"
$SmtpPort = 587
$UserName = "johnnytu0401@gmail.com"
$Password = "wtxz figx qbkl xahx" # 應用程式專用密碼
$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName, $securePassword
$smtp = New-Object system.net.mail.smtpClient($SmtpServer, $SmtpPort)
$smtp.EnableSsl = $true
$smtp.Credentials = $Credential

# 設定SQL Server的連接資訊
$server = "TAMKANG-s1"
$database = "maintain"
$table = "computer"
$connectionString = "Server=$server;Database=$database;User Id=maintain;Password=Zxcv1234;"

# ===1===
# 計算30天前的日期
$thirtyDaysAgo = $today.AddDays(-30).ToString("yyyy-MM-dd")

# 查詢SQL資料庫，計算符合條件的筆數
$queryCount = @"
SELECT COUNT(*) AS RecordCount FROM $table WHERE computer_lastupdate < '$thirtyDaysAgo'
"@

# 查詢SQL資料庫，取得符合條件的詳細資料
$queryData = @"
SELECT * FROM $table WHERE computer_lastupdate < '$thirtyDaysAgo'
"@

# 連接SQL並執行查詢
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# 連接SQL並執行查詢（筆數）
$commandCount = $connection.CreateCommand()
$commandCount.CommandText = $queryCount
$recordCount = $commandCount.ExecuteScalar()

# 連接SQL並執行查詢（資料）
$commandData = $connection.CreateCommand()
$commandData.CommandText = $queryData
$reader = $commandData.ExecuteReader()

# 構建郵件內容
$body = "超過30天未更新的電腦記錄之筆數： " + $recordCount + "`n"
if ($recordCount -eq 0) {
    $body += "`n"
}
while ($reader.Read()) {
    $body += "電腦名稱: " + $reader["computer_name"] + "`n"
    $body += "電腦使用者: " + $reader["computer_lastuser"] + "`n"
    $body += "最後更新日期: " + $reader["computer_lastupdate"] + "`n"
    $body += "`n"
}

# ===2===
# 查詢SQL資料庫，計算符合條件的筆數
$queryCount = @"
SELECT COUNT(*) AS RecordCount FROM $table WHERE computer_lastsecure != 'protected'
"@

# 查詢SQL資料庫，取得符合條件的詳細資料
$queryData = @"
SELECT * FROM $table WHERE computer_lastsecure != 'protected'
"@

# 連接SQL並執行查詢
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# 連接SQL並執行查詢（筆數）
$commandCount = $connection.CreateCommand()
$commandCount.CommandText = $queryCount
$recordCount = $commandCount.ExecuteScalar()

# 連接SQL並執行查詢（資料）
$commandData = $connection.CreateCommand()
$commandData.CommandText = $queryData
$reader = $commandData.ExecuteReader()

# 構建郵件內容
$body += "防毒軟體狀態異常的電腦記錄之筆數： " + $recordCount + "`n"
if ($recordCount -eq 0) {
    $body += "`n"
}
while ($reader.Read()) {
    $body += "電腦名稱: " + $reader["computer_name"] + "`n"
    $body += "電腦使用者: " + $reader["computer_lastuser"] + "`n"
    $body += "狀態異常值: " + $reader["computer_lastsecure"] + "`n"
    $body += "`n"
}

# ===3===
# 查詢SQL資料庫，計算符合條件的筆數
$queryCount = @"
SELECT COUNT(*) AS RecordCount FROM $table WHERE computer_compliant != 'Y'
"@

# 查詢SQL資料庫，取得符合條件的詳細資料
$queryData = @"
SELECT * FROM $table WHERE computer_compliant != 'Y'
"@

# 連接SQL並執行查詢
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# 連接SQL並執行查詢（筆數）
$commandCount = $connection.CreateCommand()
$commandCount.CommandText = $queryCount
$recordCount = $commandCount.ExecuteScalar()

# 連接SQL並執行查詢（資料）
$commandData = $connection.CreateCommand()
$commandData.CommandText = $queryData
$reader = $commandData.ExecuteReader()

# 構建郵件內容
$body += "GCB合規狀態異常的電腦記錄之筆數： " + $recordCount + "`n"
if ($recordCount -eq 0) {
    $body += "`n"
}
while ($reader.Read()) {
    $body += "電腦名稱: " + $reader["computer_name"] + "`n"
    $body += "電腦使用者: " + $reader["computer_lastuser"] + "`n"
    $body += "狀態異常值: " + $reader["computer_compliant"] + "`n"
    $body += "`n"
}

# ===4===
# 查詢SQL資料庫，計算符合條件的筆數
$queryCount = @"
SELECT COUNT(*) AS RecordCount FROM $table WHERE computer_appupdate != 'Y'
"@

# 查詢SQL資料庫，取得符合條件的詳細資料
$queryData = @"
SELECT * FROM $table WHERE computer_appupdate != 'Y'
"@

# 連接SQL並執行查詢
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# 連接SQL並執行查詢（筆數）
$commandCount = $connection.CreateCommand()
$commandCount.CommandText = $queryCount
$recordCount = $commandCount.ExecuteScalar()

# 連接SQL並執行查詢（資料）
$commandData = $connection.CreateCommand()
$commandData.CommandText = $queryData
$reader = $commandData.ExecuteReader()

# 構建郵件內容
$body += "應用軟體更新狀態異常的電腦記錄之筆數： " + $recordCount + "`n"
if ($recordCount -eq 0) {
    $body += "`n"
}
while ($reader.Read()) {
    $body += "電腦名稱: " + $reader["computer_name"] + "`n"
    $body += "電腦使用者: " + $reader["computer_lastuser"] + "`n"
    $body += "狀態異常值: " + $reader["computer_appupdate"] + "`n"
    $body += "`n"
}

$reader.Close()
$connection.Close()

# 如果有符合的記錄，發送電子郵件
if ($body) {
    # 送出通知郵件
    $Message = New-Object System.Net.Mail.MailMessage $From, $To, $Subject, $body
    $Message.IsBodyHtml = $false
    $Message.SubjectEncoding = [System.Text.Encoding]::UTF8
    $Message.BodyEncoding = [System.Text.Encoding]::UTF8
    $smtp.Send($Message)
} else {
    # Write-Host "無超過30天未更新的電腦記錄。"
}
