# �]�w�q���H��H�M����H���q�l�l��a�}
$From = "johnnytu0401@gmail.com"
$To = "johnnytu0401@gmail.com"

# �]�w�q���l��D���M���e
$Subject = "AD �b��̷s�@����w�ƥ�q��"

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

# ���o�̷s�@�� AD �b��Q��w�ƥ�
$Event = Get-WinEvent -FilterHashtable @{LogName='Security';Id=4740} -MaxEvents 1

if ($Event) {
    # ���o�ƥ��T
    $EventData = $Event.Properties
    $TargetUserName = $EventData[0].Value
    $TargetDomainName = $EventData[5].Value
    $CallerUserName = $EventData[2].Value
    $CallerDomainName = $EventData[3].Value
    $IpAddress = $EventData[4].Value
    $WorkstationName = $EventData[1].Value

    # �e�X�q���l��
    $Message = New-Object System.Net.Mail.MailMessage $From, $To, $Subject, $Body
    $Message.IsBodyHtml = $false
    $Message.SubjectEncoding = [System.Text.Encoding]::UTF8
    $Message.BodyEncoding = [System.Text.Encoding]::UTF8
    $Message.Body = "�o�� AD �b����w�ƥ�A���ˬd������T�G`r`n"
    $Message.Body += "�ؼШϥΪ̦W�١G$TargetUserName`r`n"
    $Message.Body += "�ؼШϥΪ̺���W�١G$TargetDomainName`r`n"
    $Message.Body += "�I�s�̨ϥΪ̦W�١G$CallerUserName`r`n"
    $Message.Body += "�I�s�̨ϥΪ̺���W�١G$CallerDomainName`r`n"
    $Message.Body += "�ӷ� IP ��}�G$IpAddress`r`n"
    $Message.Body += "�u�@���W�١G$WorkstationName`r`n"
    $smtp.Send($Message)
}