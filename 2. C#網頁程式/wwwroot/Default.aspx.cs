using System;  
using System.Data;  
using System.Configuration;  
using System.Collections;  
using System.Web;  
using System.Web.Security;  
using System.Web.UI;  
using System.Web.UI.WebControls;  
using System.Web.UI.WebControls.WebParts;  
using System.Web.UI.HtmlControls;  
using System.Data.SqlClient;
using System.DirectoryServices;

public partial class WebApplication2_Default: System.Web.UI.Page 
{
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        // �q�������o�ϥΪ̿�J�� AD �b���M�K�X
        string adUsername = txtUsername.Text;
        string adPassword = txtPassword.Text;

        // �I�s LDAP ���Ҥ�k
        if (AuthenticateUser(adUsername, adPassword))
        {
            // ���o�ϥΪ� IP �M��e���
            string userIpAddress = HttpUtility.JavaScriptStringEncode(Request.UserHostAddress);
            string currentDate = HttpUtility.JavaScriptStringEncode(DateTime.Now.ToString("yyyy-MM-dd"));

            // �d�߱��󤤪�����Ų�O���G���A
            string authStatus = "Y";

            // �I�s�ˬd��Ʈw��k
            bool isRecordExist = CheckDatabaseForRecord(adUsername, userIpAddress, currentDate, authStatus);

            if (isRecordExist)
            {
                // �d�߳]�����Ҫ�4�����d�X�W
                bool isRecord4Exist = CheckDatabaseForComputer(userIpAddress, currentDate);
                if (isRecord4Exist)
                {
                    // ���o��e�ɶ�
                    DateTime currentTime = DateTime.Now;
                    int currentHour = currentTime.Hour;
                    if (currentHour >= 8 && currentHour < 23)
                    {
                        // �d�ߨϥΪ̪�������T
                        string department = GetADUserDepartment(adUsername);

                        // �ˬd�����O�_�� "��T��"
                        if (department == "��T��")
                        {
                            // ���\�T��
                            Response.Redirect("http://tamkang-s1/gridview");
                        }
                        else
                        {
                            // ���~�T��
                            Response.Write("<script>alert('�L�k�}�Һ����G���ŦX��������s�����v������T�աC');</script>");
                            Response.End();
                            Response.Redirect("http://tamkang-s1/");
                        }
                   }
                   else
                   {
                       // ���~�T��
                       Response.Write("<script>alert('�L�k�}�Һ����G���ŦX�ɶ��ݩʦs�����v�����W�Z�ɶ��C');</script>");
                       Response.End();
                       Response.Redirect("http://tamkang-s1/");
                   }
                }
                else
                {
                    // ���~�T��
                    Response.Write("<script>alert('�L�k�}�Һ����G���ŦX�]�����Ҫ�4���]�ư��d�X�W�C');</script>");
                    Response.End();
                    Response.Redirect("http://tamkang-s1/");
                }
            }
            else
            {
                // ���~�T��
                Response.Write("<script>alert('�L�k�}�Һ����G���ŦX�ϥΪ̱b���j�w�ӤH�O�޹q�����������ҡC');</script>");
                Response.End();
                Response.Redirect("http://tamkang-s1/");
            }
        }
        else
        {
            // AD ���ҥ���
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('AD ���ҥ��ѡA���ˬd�z���b���αK�X�C');", true);
        }
    }

    // �ϥ� LDAP �i�� AD �b���M�K�X����
    private bool AuthenticateUser(string username, string password)
    {
        bool isAuthenticated = false;
        string domain = "tamkang.com.tw"; // �z�� AD ����W��
        string ldapPath = $"LDAP://{domain}";

        try
        {
            // �ϥαb���B�K�X�إ� DirectoryEntry
            using (DirectoryEntry entry = new DirectoryEntry(ldapPath, $"{domain}\\{username}", password))
            {
                // ���ճX�� NativeObject �ݩ����ҳs�u
                try
                {
                    object obj = entry.NativeObject;
                    isAuthenticated = true; // ���Ҧ��\
                    //// ����즹�S�X���Y�N��b���K�X���ġA�H�U�[�X�j�M AD �Ҧ��W�� username ������
                    //DirectorySearcher search = new DirectorySearcher(entry);
                    //// �j�M AD �b���W�٬� username ������
                    //search.Filter = "(SAMAccountName=" + username + ")";
                    //foreach (SearchResult r in search.FindAll())
                    //{
                    //    Response.Write(r.Properties["distinguishedName"][0].ToString());
                    //}
                }
                catch (Exception ex)
                {
                    // �ݩ����ҿ��~��ܿ��~�T��
                    // Response.Write(ex.Message);
                }
            }
        }
        catch (DirectoryServicesCOMException)
        {
            // ���ҥ���
            isAuthenticated = false;
        }
        return isAuthenticated;
    }

    // �ˬd��Ʈw��ƪ�wmsinfo�O�_�s�b�ŦX���󪺰O��
    private bool CheckDatabaseForRecord(string username, string ipAddress, string logindate, string authStatus)
    {
        bool recordExists = false;

        // �]�w��Ʈw�s�u�r�� (�Юھڱz�����Ҷi��t�m)
        string connectionString = "Server=TAMKANG-s1;Database=maintain;User Id=maintain;Password=Zxcv1234;";

        // �]�w�d�߻y�y
        string query = @"
            SELECT COUNT(1) FROM wmsinfo 
            WHERE computer_user = @Username 
                AND computer_ip = @IPAddress 
                AND computer_date = @LoginDate
                AND computer_auth = @AuthStatus";

        // �ϥ� ADO.NET ����d��
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                // �K�[�d�߰Ѽ�
                command.Parameters.AddWithValue("@Username", username);
                command.Parameters.AddWithValue("@IPAddress", ipAddress);
                command.Parameters.AddWithValue("@LoginDate", logindate);
                command.Parameters.AddWithValue("@AuthStatus", authStatus);

                try
                {
                    connection.Open();
                    int count = (int)command.ExecuteScalar(); // ����d�ߨè��o���G

                    // �P�_�O�_�s�b�ŦX���󪺰O��
                    recordExists = count > 0;
                }
                catch (Exception ex)
                {
                    // �O�����~����ܿ��~�T��
                    Response.Write("<script>alert('��Ʈw�d�߿��~�G" + ex.Message + "');</script>");
                }
            }
        }

        return recordExists;
    }

    // �ˬd��Ʈw��ƪ�Computer�O�_�s�b�ŦX���󪺰O��
    private bool CheckDatabaseForComputer(string ipAddress, string logindate)
    {
        bool record4Exists = false;

        // �]�w��Ʈw�s�u�r�� (�Юھڱz�����Ҷi��t�m)
        string connectionString = "Server=TAMKANG-s1;Database=maintain;User Id=maintain;Password=Zxcv1234;";

        // �]�w�d�߻y�y
        string query = @"
            SELECT COUNT(1) FROM computer 
            WHERE computer_ip = @IPAddress 
                AND computer_lastdate = @LoginDate 
                AND computer_lastwu = @lastwu
                AND computer_lastsecure = @lastsecure 
                AND computer_compliant = @compliant
                AND computer_appupdate = @appupdate";

        // �ϥ� ADO.NET ����d��
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                // �K�[�d�߰Ѽ�
                command.Parameters.AddWithValue("@IPAddress", ipAddress);
                command.Parameters.AddWithValue("@LoginDate", logindate);
                command.Parameters.AddWithValue("@lastwu", "Y");
                command.Parameters.AddWithValue("@lastsecure", "protected");
                command.Parameters.AddWithValue("@compliant", "Y");
                command.Parameters.AddWithValue("@appupdate", "Y");

                try
                {
                    connection.Open();
                    int count = (int)command.ExecuteScalar(); // ����d�ߨè��o���G

                    // �P�_�O�_�s�b�ŦX���󪺰O��
                    record4Exists = count > 0;
                }
                catch (Exception ex)
                {
                    // �O�����~����ܿ��~�T��
                    Response.Write("<script>alert('��Ʈw�d�߿��~�G" + ex.Message + "');</script>");
                }
            }
        }

        return record4Exists;
    }

    private string GetADUserDepartment(string userName)
    {
        try
        {
            // �]�w LDAP ���|�A�ìd�ߨϥΪ̱b��
            string ldapPath = "LDAP://tamkang.com.tw"; // �������z������
            DirectoryEntry entry = new DirectoryEntry(ldapPath);
            DirectorySearcher search = new DirectorySearcher(entry)
            {
                Filter = $"(sAMAccountName={userName})" // �ϥ� sAMAccountName (�n�J�W��) �d��
            };

            // �j�M�è��o�ϥΪ̸�T
            search.PropertiesToLoad.Add("department"); // �[�������ݩ�
            SearchResult result = search.FindOne();

            if (result != null && result.Properties["department"].Count > 0)
            {
                return result.Properties["department"][0].ToString(); // �^�ǳ�����쪺��
            }
            else
            {
                return null; // �Y����쳡����T�A�^�� null
            }
        }
        catch (Exception ex)
        {
            // ���~�B�z
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('�d�ߵo�Ϳ��~: {ex.Message}');", true);
            return null;
        }
    }
}