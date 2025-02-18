# 定義資料庫連線字串
$connectionString = "Server=tamkang-s1;Database=maintain;User Id=maintain;Password=Zxcv1234;"

# 獲取當前使用者的詳細資料
$username = $env:USERNAME
$computerName = $env:COMPUTERNAME

# 獲取當前日期和時間
$loginDate = Get-Date -Format "yyyy-MM-dd"
$loginTime = Get-Date -Format "HH:mm:ss"

# 獲取 IP 地址
$ipAddress = (Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPv4Address.ToString()

# 判斷是否為星期六或星期日
$isWeekend = if ((Get-Date).DayOfWeek -eq 'Saturday' -or (Get-Date).DayOfWeek -eq 'Sunday') {
    'Y'
} else {
    'N'
}

# 使用 [adsisearcher] 和 LDAP 查詢獲取當前使用者的描述欄位內容
try {
    $userSearcher = New-Object DirectoryServices.DirectorySearcher
    $userSearcher.Filter = "(&(objectCategory=person)(objectClass=user)(sAMAccountName=$username))"
    $userSearcher.PropertiesToLoad.Add("description") | Out-Null
    $adUser = $userSearcher.FindOne()

    # 獲取描述欄位的值
    $description = if ($adUser.Properties["description"]) {
        $adUser.Properties["description"][0]
    } else {
        ""
    }
} catch {
    Write-Error "無法從 AD 中取得使用者描述: $_"
    $description = ""
}

# 判斷電腦名稱是否與使用者描述相同
$isComputerNameMatch = if ($computerName -eq $description) {
    'Y'
} else {
    'N'
}

# SQL 查詢指令，查詢該使用者最近一次的登入日期、時間及電腦名稱
$sqlQuery = @"
SELECT TOP 1 computer_date, computer_time, computer_name 
FROM wmsinfo 
WHERE computer_user = '$username' 
ORDER BY computer_date DESC, computer_time DESC
"@

# 初始化變數來存放查詢結果
$loginDate1 = ""
$loginTime1 = ""
$computerName1 = ""

# 執行 SQL 查詢指令
try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.CommandText = $sqlQuery
    $reader = $command.ExecuteReader()

    if ($reader.Read()) {
        # 獲取最近一次的登入資料
        $loginDate1 = $reader["computer_date"]
        $loginTime1 = $reader["computer_time"]
        $computerName1 = $reader["computer_name"]
    } else {
        # 若無資料則顯示無登入記錄
        Write-Error "資料庫中無登入記錄: $_"
    }
    $reader.Close()
    $connection.Close()
} catch {
    Write-Error "無法從資料庫中取得登入詳細資料: $_"
}

# 定義 SQL 插入指令
$sqlCommand = @"
INSERT INTO wmsinfo (computer_user, computer_date, computer_time, computer_name, computer_ip, computer_daysoff, computer_auth)
VALUES ('$username', '$loginDate', '$loginTime', '$computerName', '$ipAddress', '$isWeekend', '$isComputerNameMatch')
"@

# 執行 SQL 指令
try {
    # 建立資料庫連線
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    # 建立 SQL 命令並執行插入操作
    $command = $connection.CreateCommand()
    $command.CommandText = $sqlCommand
    $command.ExecuteNonQuery()

    # 關閉資料庫連線
    $connection.Close()
} catch {
    # 捕捉並顯示錯誤訊息
    Write-Error "無法記錄登入詳細資料: $_"
}

# 載入 System.Windows.Forms 來使用 MessageBox
Add-Type -AssemblyName System.Windows.Forms

# 如果查詢結果存在，顯示 MessageBox
if ($loginDate1 -ne "" -and $loginTime1 -ne "" -and $computerName1 -ne "") {
    $message = $username + "最近一次登入資訊：" + "`n" +
               "登入日期: $loginDate1" + "`n" +
               "登入時間: $loginTime1" + "`n" +
               "登入電腦: $computerName1"
    [System.Windows.Forms.MessageBox]::Show($message, "最近一次登入資訊", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}