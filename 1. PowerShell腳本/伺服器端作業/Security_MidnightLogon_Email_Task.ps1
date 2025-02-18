# 設定通知寄件人和收件人的電子郵件地址
$From = "johnnytu0401@gmail.com"
$To = "johnnytu0401@gmail.com"

# 設定通知郵件主旨和內容
$Subject = "AD 帳戶夜間登入通知"

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

# 獲取今天的日期
$currentDate = Get-Date
# 定義非上班時間(夜間)範圍
$nonBusinessHoursStart = Get-Date -Year $currentDate.Year -Month $currentDate.AddDays(-1).Month -Day ($currentDate.AddDays(-1).Day) -Hour 22 -Minute 0 -Second 0
$nonBusinessHoursEnd = Get-Date -Year $currentDate.Year -Month $currentDate.Month -Day $currentDate.Day -Hour 6 -Minute 0 -Second 0
# $nonBusinessHoursStart = "22:00"  # 24小時制，非上班時間開始
# $nonBusinessHoursEnd = "06:00"    # 24小時制，非上班時間結束

# 監視事件日誌（Security 日誌）中的登入事件
$events = Get-WinEvent -FilterHashtable @{
    LogName='Security'
    Id=4624
    ProviderName='Microsoft-Windows-Security-Auditing'
} | Where-Object {($_.Properties[5].Value.Length -eq 4 -and $_.Properties[5].Value.ToLower().StartsWith("t")) -or $_.Properties[5].Value.ToLower().StartsWith("ad")}

# 檢查每個事件，如果在非上班時間(夜間)，加入到通知郵件的內容中
$messageBody = "發現以下使用者帳戶在夜間的登入事件。`r`n`r`n"
foreach ($event in $events) {
    $eventTime = $event.TimeCreated
    $loginTime = $eventTime.ToString("HH:mm")
    if ($eventTime -gt $nonBusinessHoursStart -and $eventTime -lt $nonBusinessHoursEnd) {
        $messageBody += "事件發生時間: $($eventTime.ToString('yyyy-MM-dd HH:mm:ss'))`r`n"
        $messageBody += "使用者: $($event.Properties[5].Value)`r`n"
        $messageBody += "Logon Type: $($event.Properties[8].Value)`r`n"
        $messageBody += "Source_Computer: $($event.Properties[11].Value)`r`n"
        $messageBody += "Source_IP: $($event.Properties[18].Value)`r`n`r`n"
    }
}
$messageBody += "事件Count: $($events.Count);$($eventTime);$($nonBusinessHoursStart);$($nonBusinessHoursEnd)`r`n"

# 如果找到事件，發送郵件通知
if ($events.Count -ge 0) {
    $Message = New-Object System.Net.Mail.MailMessage $From, $To, $Subject, $Body
    $Message.IsBodyHtml = $false
    $Message.SubjectEncoding = [System.Text.Encoding]::UTF8
    $Message.BodyEncoding = [System.Text.Encoding]::UTF8
    $Message.Body = $messageBody
    $smtp.Send($Message)
}