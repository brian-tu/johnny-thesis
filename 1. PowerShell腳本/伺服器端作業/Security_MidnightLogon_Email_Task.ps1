# �]�w�q���H��H�M����H���q�l�l��a�}
$From = "johnnytu0401@gmail.com"
$To = "johnnytu0401@gmail.com"

# �]�w�q���l��D���M���e
$Subject = "AD �b��]���n�J�q��"

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

# ������Ѫ����
$currentDate = Get-Date
# �w�q�D�W�Z�ɶ�(�]��)�d��
$nonBusinessHoursStart = Get-Date -Year $currentDate.Year -Month $currentDate.AddDays(-1).Month -Day ($currentDate.AddDays(-1).Day) -Hour 22 -Minute 0 -Second 0
$nonBusinessHoursEnd = Get-Date -Year $currentDate.Year -Month $currentDate.Month -Day $currentDate.Day -Hour 6 -Minute 0 -Second 0
# $nonBusinessHoursStart = "22:00"  # 24�p�ɨ�A�D�W�Z�ɶ��}�l
# $nonBusinessHoursEnd = "06:00"    # 24�p�ɨ�A�D�W�Z�ɶ�����

# �ʵ��ƥ��x�]Security ��x�^�����n�J�ƥ�
$events = Get-WinEvent -FilterHashtable @{
    LogName='Security'
    Id=4624
    ProviderName='Microsoft-Windows-Security-Auditing'
} | Where-Object {($_.Properties[5].Value.Length -eq 4 -and $_.Properties[5].Value.ToLower().StartsWith("t")) -or $_.Properties[5].Value.ToLower().StartsWith("ad")}

# �ˬd�C�Өƥ�A�p�G�b�D�W�Z�ɶ�(�]��)�A�[�J��q���l�󪺤��e��
$messageBody = "�o�{�H�U�ϥΪ̱b��b�]�����n�J�ƥ�C`r`n`r`n"
foreach ($event in $events) {
    $eventTime = $event.TimeCreated
    $loginTime = $eventTime.ToString("HH:mm")
    if ($eventTime -gt $nonBusinessHoursStart -and $eventTime -lt $nonBusinessHoursEnd) {
        $messageBody += "�ƥ�o�ͮɶ�: $($eventTime.ToString('yyyy-MM-dd HH:mm:ss'))`r`n"
        $messageBody += "�ϥΪ�: $($event.Properties[5].Value)`r`n"
        $messageBody += "Logon Type: $($event.Properties[8].Value)`r`n"
        $messageBody += "Source_Computer: $($event.Properties[11].Value)`r`n"
        $messageBody += "Source_IP: $($event.Properties[18].Value)`r`n`r`n"
    }
}
$messageBody += "�ƥ�Count: $($events.Count);$($eventTime);$($nonBusinessHoursStart);$($nonBusinessHoursEnd)`r`n"

# �p�G���ƥ�A�o�e�l��q��
if ($events.Count -ge 0) {
    $Message = New-Object System.Net.Mail.MailMessage $From, $To, $Subject, $Body
    $Message.IsBodyHtml = $false
    $Message.SubjectEncoding = [System.Text.Encoding]::UTF8
    $Message.BodyEncoding = [System.Text.Encoding]::UTF8
    $Message.Body = $messageBody
    $smtp.Send($Message)
}