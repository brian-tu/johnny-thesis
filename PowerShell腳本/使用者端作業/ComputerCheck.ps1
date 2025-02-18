# �]�w��Ʈw�s�u�r��
$connectionString = "Server=tamkang-s1;Database=maintain;User Id=maintain;Password=Zxcv1234;"

# ���J System.Windows.Forms �ե����q��
Add-Type -AssemblyName System.Windows.Forms

# ���o�n�J���ϥΪ̦W��
$UserName = $env:UserName

# ���o�q���W��
$ComputerName = $env:COMPUTERNAME

# ���o�n�J������M�ɶ�
$loginDate = Get-Date -Format "yyyy-MM-dd"
$loginTime = Get-Date -Format "HH:mm:ss"

# ���o���� IP �a�}
$IPAddress = (Test-Connection -ComputerName (hostname) -Count 1).IPV4Address.IPAddressToString

# ���o Windows Update �̪񪺧�s���
$WUStatus = (New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().QueryHistory(0,1)
foreach ($objEntry in $WUStatus) {
    $LastWUDate = '{0:yyyy-MM-dd}' -f $objEntry.Date
}

# ���o Windows Defender ���A
$DefenderStatus = Get-MpComputerStatus
$DefenderRealTimeProtection = $DefenderStatus.RealTimeProtectionEnabled
$DefenderAntivirusEnabled = $DefenderStatus.AntivirusEnabled
$SecureStatus = if ($DefenderStatus.RealTimeProtectionEnabled -and $DefenderStatus.AntivirusEnabled) {
    'protected'
} else {
    'abnormal'
}

# �ͦ��ثe�M�Ω�q���� GPO ���i�ñN��ɥX�� HTML ���
gpresult /f /H C:\Windows\Temp\gpresult.html
# ���J HTML �ɮ�
$htmlContent = Get-Content -Path C:\Windows\Temp\gpresult.html -Raw
# �ϥΥ��h��F���ӴM�� "�K�X���׳̤p��" �M��᪺�ƭ�
if ($htmlContent -match '�K�X���׳̤p��.*?(\d+).*?�Ӧr��') {
    # $matches �O�۰��ܼơA�ΨӦs�񥿫h��F�����ǰt���G
    $minPasswordLength = $matches[1]
} else {
    Write-Output "�䤣��K�X���׳̤p�Ȫ��]�w�C"
}
# ���o�ثe�M�� GPO ���b��K�X��h�̤p�K�X���׬O�_�� 8 �X
$isCompliant = if ($minPasswordLength -eq 8) {
    'Y'
} else {
    'N'
}

# �ϥΥ��h��F���j�M�Ҧ����u�����𪬺A�v�A�æ����䪬�A�]�}�� �� �����^
$firewallStates = @()  # ��l�ƪŰ}�C�Ӧs�x�����𪬺A
foreach ($match in [regex]::Matches($htmlContent, '�����𪬺A.*?(�}��|����)')) {
    $firewallStates += $match.Groups[1].Value
}
# �P�_�C�Ө����𪬺A�O�_���}��
$count = 0
$results = @()  # ��l�ƪŰ}�C�Ӧs�x���G
foreach ($state in $firewallStates) {
    if ($state -eq '�}��') { $count++ }
}
$isCompliant002 = if ($count -eq 3) {
    'Y'
} else {
    'N'
}

# ��l�Ƥ@�ӪŪ����X�Ӧs��s�w�˩Χ�s�����ε{��
$newSoftware = @()
# �w�q�Q�ˬd�����γn�鶷�ŦX�|�}��s���]�w��
$Software1Checked = "*Google Chrome*"  # �ΨӼаO�Q�ˬd�����γn��W�٬� Google Chrome
$Software1SetDate = [datetime]"2024-10-01" # �ΨӼаO�Q�ˬd���γn�骺�|�}��s���(�۰ʧ�s)
$Software1Version = "125.0.6422.60"  # �ΨӼаO�Q�ˬd���γn�骺�|�}��s����
$Software1Updated = $false  # �ΨӼаO�Q�ˬd�����γn��O�_�ŦX�|�}��s���A
$SoftwareUpdated = "Y"  # �ΨӼаO�Ҧ��Q�ˬd�����γn��O�_�ŦX�|�}��s���A
# �M�����U����|�A�d��̪�w�˩Χ�s�����ε{��
foreach ($path in $registryPaths) {
    $installedApps = Get-ChildItem -Path $path | ForEach-Object {
        $appKey = $_
        # ������� InstallDate, DisplayName �M DisplayVersion ����
        try {
            $installDate = $appKey.GetValue("InstallDate")
            $displayName = $appKey.GetValue("DisplayName")
            $displayVersion = $appKey.GetValue("DisplayVersion")
            # �ˬd InstallDate �O�_�����Ī�����榡
            if ($installDate -and $displayName -ne $null) {
                try {
                    # �p�G���ε{���O�Q�ˬd���n��W�١A�аO���w��s
                    if ($displayName -like $Software1Checked) {
                        # ���ձN InstallDate �ഫ�� DateTime �榡
                        $parsedDate = [datetime]::ParseExact($installDate, "yyyyMMdd", $null)
                        # �ˬd���γn�骺�w�˩Χ�s����O�_�j��|�}��s���
                        if ($parsedDate -ge $Software1SetDate) {
                            $Software1Updated = $true
                        # ���ˬd���γn�骺�w�˩Χ�s�����O�_�j��|�}��s����
                        #if ($displayVersion -ne $null) {
                        #    $Software1Updated = $true
                        #}
                        } else {
                            $SoftwareUpdated = "N"
                        }
                    }
                }
                catch {
                    # �p�G InstallDate �L�k�ѪR������A�h���L
                    Write-Verbose "�L�k�ѪR InstallDate: $($displayName) - $($installDate)"
                }
            }
        }
        catch {
            # �p�G�X�{��LŪ�����~�A���L�Ӷ���
            Write-Verbose "�L�kŪ�����ε{������: $($_.PSPath)"
        }
    }
    # �N�d��쪺�s�w�˩Χ�s�����ε{���[�J�춰�X��
    $newSoftware += $installedApps
}

# �إ� SQL ��s���O
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

# �p�G Windows Update �S���b�̪� 30 �Ѥ���s�o�Xĵ�ܳq��
$CheckDate = (Get-Date).AddDays(-30).ToString("yyyy-MM-dd")
if ($LastWUDate -le $CheckDate) {
    # �]�w�T���ت����D�M�T��
    $title = "Windows Update �W�L 30 �ѥ���s"
    $message = "�о��t���� Windows Update �γs����T�H����U�I"
    # ��ܰT���ءA�õ��ݨϥΪ̫��U"�T�w"��
    $alert = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# �p�G���r�n��ҥΧY�ɫO�@���`�o�Xĵ�ܳq��
if ($SecureStatus -ne "protected") {
    # �]�w�T���ت����D�M�T��
    $title = "Windows�w���ʤ����r�n�骬�A���`"
    $message = "�о��t�ҥ�Windows�w���ʶ���[�f�r�Ϋ¯٫O�@]�γs����T�H����U�I"
    # ��ܰT���ءA�õ��ݨϥΪ̫��U"�T�w"��
    $alert = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# �p�G�ϥΪ̹q��GCB�պA�M�β��`�o�Xĵ�ܳq��
if ($isCompliant -ne "Y") {
    # �]�w�T���ت����D�M�T��
    $title = "���x�q��GCB�պA�M�β��`"
    $message = "�о��t�s����T�H����U�B�z�q��GCB�պA�M�β��`���p�I(�̤p�K�X����)"
    # ��ܰT���ءA�õ��ݨϥΪ̫��U"�T�w"��
    $alert = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}
if ($isCompliant002 -ne "Y") {
    # �]�w�T���ت����D�M�T��
    $title = "���x�q��GCB�պA�M�β��`"
    $message = "�о��t�s����T�H����U�B�z�q��GCB�պA�M�β��`���p�I(�����𪬺A)"
    # ��ܰT���ءA�õ��ݨϥΪ̫��U"�T�w"��
    $alert = [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# �p�G�ϥΪ̹q���Q�ˬd�����γn�餣�ŦX��s���A
if ($SoftwareUpdated -ne "Y") {
    # �]�w�T���ت����D�M�T��
    $title = "���x�q���w�ˤ�" + $Software1Checked + "�n��|�}�|����s"
    $message = "�о��t����" + $Software1Checked + "�n��|�}��s�׸ɩγs����T�H����U�I"
    # ��ܰT���ءA�õ��ݨϥΪ̫��U"�T�w"��
    [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}