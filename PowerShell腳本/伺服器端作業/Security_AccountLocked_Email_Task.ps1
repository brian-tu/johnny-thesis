# 設定通知寄件人和收件人的電子郵件地址
$From = "johnnytu0401@gmail.com"
$To = "johnnytu0401@gmail.com"

# 設定通知郵件主旨和內容
$Subject = "AD 帳戶最新一筆鎖定事件通知"

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

# 取得最新一筆 AD 帳戶被鎖定事件
$Event = Get-WinEvent -FilterHashtable @{LogName='Security';Id=4740} -MaxEvents 1

if ($Event) {
    # 取得事件資訊
    $EventData = $Event.Properties
    $TargetUserName = $EventData[0].Value
    $TargetDomainName = $EventData[5].Value
    $CallerUserName = $EventData[2].Value
    $CallerDomainName = $EventData[3].Value
    $IpAddress = $EventData[4].Value
    $WorkstationName = $EventData[1].Value

    # 送出通知郵件
    $Message = New-Object System.Net.Mail.MailMessage $From, $To, $Subject, $Body
    $Message.IsBodyHtml = $false
    $Message.SubjectEncoding = [System.Text.Encoding]::UTF8
    $Message.BodyEncoding = [System.Text.Encoding]::UTF8
    $Message.Body = "發生 AD 帳戶鎖定事件，請檢查相關資訊：`r`n"
    $Message.Body += "目標使用者名稱：$TargetUserName`r`n"
    $Message.Body += "目標使用者網域名稱：$TargetDomainName`r`n"
    $Message.Body += "呼叫者使用者名稱：$CallerUserName`r`n"
    $Message.Body += "呼叫者使用者網域名稱：$CallerDomainName`r`n"
    $Message.Body += "來源 IP 位址：$IpAddress`r`n"
    $Message.Body += "工作站名稱：$WorkstationName`r`n"
    $smtp.Send($Message)
}