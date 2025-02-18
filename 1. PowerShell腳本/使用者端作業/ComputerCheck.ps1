# 設定資料庫連線字串
$connectionString = "Server=tamkang-s1;Database=maintain;User Id=maintain;Password=Zxcv1234;"

# 載入 System.Windows.Forms 組件執行通知
Add-Type -AssemblyName System.Windows.Forms

# 取得登入的使用者名稱
$UserName = $env:UserName

# 取得電腦名稱
$ComputerName = $env:COMPUTERNAME

# 取得登入的日期和時間
$loginDate = Get-Date -Format "yyyy-MM-dd"
$loginTime = Get-Date -Format "HH:mm:ss"

# 取得本機 IP 地址
$IPAddress = (Test-Connection -ComputerName (hostname) -Count 1).IPV4Address.IPAddressToString

# 取得 Windows Update 最近的更新日期
$WUStatus = (New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().QueryHistory(0,1)
foreach ($objEntry in $WUStatus) {
    $LastWUDate = '{0:yyyy-MM-dd}' -f $objEntry.Date
}

# 取得 Windows Defender 狀態
$DefenderStatus = Get-MpComputerStatus
$DefenderRealTimeProtection = $DefenderStatus.RealTimeProtectionEnabled
$DefenderAntivirusEnabled = $DefenderStatus.AntivirusEnabled
$SecureStatus = if ($DefenderStatus.RealTimeProtectionEnabled -and $DefenderStatus.AntivirusEnabled) {
    'protected'
} else {
    'abnormal'
}

# 生成目前套用於電腦的 GPO 報告並將其導出為 HTML 文件
gpresult /f /H C:\Windows\Temp\gpresult.html
# 載入 HTML 檔案
$htmlContent = Get-Content -Path C:\Windows\Temp\gpresult.html -Raw
# 使用正則表達式來尋找 "密碼長度最小值" 和其後的數值
if ($htmlContent -match '密碼長度最小值.*?(\d+).*?個字元') {
    # $matches 是自動變數，用來存放正則表達式的匹配結果
    $minPasswordLength = $matches[1]
} else {
    Write-Output "找不到密碼長度最小值的設定。"
}
# 取得目前套用 GPO 之帳戶密碼原則最小密碼長度是否為 8 碼
$isCompliant = if ($minPasswordLength -eq 8) {
    'Y'
} else {
    'N'
}

# 使用正則表達式搜尋所有的「防火牆狀態」，並收集其狀態（開啟 或 關閉）
$firewallStates = @()  # 初始化空陣列來存儲防火牆狀態
foreach ($match in [regex]::Matches($htmlContent, '防火牆狀態.*?(開啟|關閉)')) {
    $firewallStates += $match.Groups[1].Value
}
# 判斷每個防火牆狀態是否為開啟
$count = 0
$results = @()  # 初始化空陣列來存儲結果
foreach ($state in $firewallStates) {
    if ($state -eq '開啟') { $count++ }
}
$isCompliant002 = if ($count -eq 3) {
    'Y'
} else {
    'N'
}

# 初始化一個空的集合來存放新安裝或更新的應用程式
$newSoftware = @()
# 定義被檢查的應用軟體須符合漏洞更新的設定值
$Software1Checked = "*Google Chrome*"  # 用來標記被檢查的應用軟體名稱為 Google Chrome
$Software1SetDate = [datetime]"2024-10-01" # 用來標記被檢查應用軟體的漏洞更新日期(自動更新)
$Software1Version = "125.0.6422.60"  # 用來標記被檢查應用軟體的漏洞更新版本
$Software1Updated = $false  # 用來標記被檢查的應用軟體是否符合漏洞更新狀態
$SoftwareUpdated = "Y"  # 用來標記所有被檢查的應用軟體是否符合漏洞更新狀態
# 遍歷註冊表路徑，查找最近安裝或更新的應用程式
foreach ($path in $registryPaths) {
    $installedApps = Get-ChildItem -Path $path | ForEach-Object {
        $appKey = $_
        # 嘗試獲取 InstallDate, DisplayName 和 DisplayVersion 的值
        try {
            $installDate = $appKey.GetValue("InstallDate")
            $displayName = $appKey.GetValue("DisplayName")
            $displayVersion = $appKey.GetValue("DisplayVersion")
            # 檢查 InstallDate 是否為有效的日期格式
            if ($installDate -and $displayName -ne $null) {
                try {
                    # 如果應用程式是被檢查的軟體名稱，標記為已更新
                    if ($displayName -like $Software1Checked) {
                        # 嘗試將 InstallDate 轉換為 DateTime 格式
                        $parsedDate = [datetime]::ParseExact($installDate, "yyyyMMdd", $null)
                        # 檢查應用軟體的安裝或更新日期是否大於漏洞更新日期
                        if ($parsedDate -ge $Software1SetDate) {
                            $Software1Updated = $true
                        # 或檢查應用軟體的安裝或更新版本是否大於漏洞更新版本
                        #if ($displayVersion -ne $null) {
                        #    $Software1Updated = $true
                        #}
                        } else {
                            $SoftwareUpdated = "N"
                        }
                    }
                }
                catch {
                    # 如果 InstallDate 無法解析為日期，則跳過
                    Write-Verbose "無法解析 InstallDate: $($displayName) - $($installDate)"
                }
            }
        }
        catch {
            # 如果出現其他讀取錯誤，跳過該項目
            Write-Verbose "無法讀取應用程式項目: $($_.PSPath)"
        }
    }
    # 將查找到的新安裝或更新的應用程式加入到集合中
    $newSoftware += $installedApps
}

# 建立 SQL 更新指令
$sqlCommand = @"
IF EXISTS (SELECT * FROM computer WHERE computer_name = '$ComputerName')
BEGIN
    UPDATE computer
    SET computer_lastuser = '$UserName',
        computer_lastdate = '$loginDate',
        computer_lasttime = '$loginTime',
        computer_ip = '$IPAddress',
        computer_lastupdate = '$LastWUDate',
        computer_lastsecure = '$SecureStatus',
        computer_compliant = '$isCompliant',
        computer_appupdate = '$SoftwareUpdated'
    WHERE computer_name = '$ComputerName';
END
ELSE
BEGIN
    INSERT INTO computer (computer_name, computer_lastuser, computer_lastdate, computer_lasttime, computer_ip, computer_lastupdate, computer_lastsecure, computer_compliant, computer_appupdate)
    VALUES ('$ComputerName', '$UserName', '$loginDate', '$loginTime', '$IPAddress', '$LastWUDate', '$SecureStatus', '$isCompliant', '$SoftwareUpdated');
END
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

# 如果 Windows Update 沒有在最近 30 天內更新發出警示通知
$CheckDate = (Get-Date).AddDays(-30).ToString("yyyy-MM-dd")
if ($LastWUDate -le $CheckDate) {
    # 設定訊息框的標題和訊息
    $title = "Windows Update 超過 30 天未更新"
    $message = "請儘速完成 Windows Update 或連絡資訊人員協助！"
    # 顯示訊息框，並等待使用者按下"確定"鍵
    $alert = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# 如果防毒軟體啟用即時保護異常發出警示通知
if ($SecureStatus -ne "protected") {
    # 設定訊息框的標題和訊息
    $title = "Windows安全性之防毒軟體狀態異常"
    $message = "請儘速啟用Windows安全性項目[病毒及威脅保護]或連絡資訊人員協助！"
    # 顯示訊息框，並等待使用者按下"確定"鍵
    $alert = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# 如果使用者電腦GCB組態套用異常發出警示通知
if ($isCompliant -ne "Y") {
    # 設定訊息框的標題和訊息
    $title = "本台電腦GCB組態套用異常"
    $message = "請儘速連絡資訊人員協助處理電腦GCB組態套用異常狀況！(最小密碼長度)"
    # 顯示訊息框，並等待使用者按下"確定"鍵
    $alert = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}
if ($isCompliant002 -ne "Y") {
    # 設定訊息框的標題和訊息
    $title = "本台電腦GCB組態套用異常"
    $message = "請儘速連絡資訊人員協助處理電腦GCB組態套用異常狀況！(防火牆狀態)"
    # 顯示訊息框，並等待使用者按下"確定"鍵
    $alert = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# 如果使用者電腦被檢查的應用軟體不符合更新狀態
if ($SoftwareUpdated -ne "Y") {
    # 設定訊息框的標題和訊息
    $title = "本台電腦安裝之" + $Software1Checked + "軟體漏洞尚未更新"
    $message = "請儘速完成" + $Software1Checked + "軟體漏洞更新修補或連絡資訊人員協助！"
    # 顯示訊息框，並等待使用者按下"確定"鍵
    [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}