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
        // 從網頁取得使用者輸入的 AD 帳號和密碼
        string adUsername = txtUsername.Text;
        string adPassword = txtPassword.Text;

        // 呼叫 LDAP 驗證方法
        if (AuthenticateUser(adUsername, adPassword))
        {
            // 取得使用者 IP 和當前日期
            string userIpAddress = HttpUtility.JavaScriptStringEncode(Request.UserHostAddress);
            string currentDate = HttpUtility.JavaScriptStringEncode(DateTime.Now.ToString("yyyy-MM-dd"));

            // 查詢條件中的身分鑑別結果狀態
            string authStatus = "Y";

            // 呼叫檢查資料庫方法
            bool isRecordExist = CheckDatabaseForRecord(adUsername, userIpAddress, currentDate, authStatus);

            if (isRecordExist)
            {
                // 查詢設備驗證的4項健康合規
                bool isRecord4Exist = CheckDatabaseForComputer(userIpAddress, currentDate);
                if (isRecord4Exist)
                {
                    // 取得當前時間
                    DateTime currentTime = DateTime.Now;
                    int currentHour = currentTime.Hour;
                    if (currentHour >= 8 && currentHour < 23)
                    {
                        // 查詢使用者的部門資訊
                        string department = GetADUserDepartment(adUsername);

                        // 檢查部門是否為 "資訊組"
                        if (department == "資訊組")
                        {
                            // 成功訊息
                            Response.Redirect("http://tamkang-s1/gridview");
                        }
                        else
                        {
                            // 錯誤訊息
                            Response.Write("<script>alert('無法開啟網頁：不符合部門角色存取授權須為資訊組。');</script>");
                            Response.End();
                            Response.Redirect("http://tamkang-s1/");
                        }
                   }
                   else
                   {
                       // 錯誤訊息
                       Response.Write("<script>alert('無法開啟網頁：不符合時間屬性存取授權須為上班時間。');</script>");
                       Response.End();
                       Response.Redirect("http://tamkang-s1/");
                   }
                }
                else
                {
                    // 錯誤訊息
                    Response.Write("<script>alert('無法開啟網頁：不符合設備驗證的4項設備健康合規。');</script>");
                    Response.End();
                    Response.Redirect("http://tamkang-s1/");
                }
            }
            else
            {
                // 錯誤訊息
                Response.Write("<script>alert('無法開啟網頁：不符合使用者帳號綁定個人保管電腦的身分驗證。');</script>");
                Response.End();
                Response.Redirect("http://tamkang-s1/");
            }
        }
        else
        {
            // AD 驗證失敗
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('AD 驗證失敗，請檢查您的帳號或密碼。');", true);
        }
    }

    // 使用 LDAP 進行 AD 帳號和密碼驗證
    private bool AuthenticateUser(string username, string password)
    {
        bool isAuthenticated = false;
        string domain = "tamkang.com.tw"; // 您的 AD 網域名稱
        string ldapPath = $"LDAP://{domain}";

        try
        {
            // 使用帳號、密碼建立 DirectoryEntry
            using (DirectoryEntry entry = new DirectoryEntry(ldapPath, $"{domain}\\{username}", password))
            {
                // 嘗試訪問 NativeObject 屬性驗證連線
                try
                {
                    object obj = entry.NativeObject;
                    isAuthenticated = true; // 驗證成功
                    //// 執行到此沒出錯即代表帳號密碼有效，以下加碼搜尋 AD 所有名為 username 的項目
                    //DirectorySearcher search = new DirectorySearcher(entry);
                    //// 搜尋 AD 帳號名稱為 username 的項目
                    //search.Filter = "(SAMAccountName=" + username + ")";
                    //foreach (SearchResult r in search.FindAll())
                    //{
                    //    Response.Write(r.Properties["distinguishedName"][0].ToString());
                    //}
                }
                catch (Exception ex)
                {
                    // 屬性驗證錯誤顯示錯誤訊息
                    // Response.Write(ex.Message);
                }
            }
        }
        catch (DirectoryServicesCOMException)
        {
            // 驗證失敗
            isAuthenticated = false;
        }
        return isAuthenticated;
    }

    // 檢查資料庫資料表wmsinfo是否存在符合條件的記錄
    private bool CheckDatabaseForRecord(string username, string ipAddress, string logindate, string authStatus)
    {
        bool recordExists = false;

        // 設定資料庫連線字串 (請根據您的環境進行配置)
        string connectionString = "Server=TAMKANG-s1;Database=maintain;User Id=maintain;Password=Zxcv1234;";

        // 設定查詢語句
        string query = @"
            SELECT COUNT(1) FROM wmsinfo 
            WHERE computer_user = @Username 
                AND computer_ip = @IPAddress 
                AND computer_date = @LoginDate
                AND computer_auth = @AuthStatus";

        // 使用 ADO.NET 執行查詢
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                // 添加查詢參數
                command.Parameters.AddWithValue("@Username", username);
                command.Parameters.AddWithValue("@IPAddress", ipAddress);
                command.Parameters.AddWithValue("@LoginDate", logindate);
                command.Parameters.AddWithValue("@AuthStatus", authStatus);

                try
                {
                    connection.Open();
                    int count = (int)command.ExecuteScalar(); // 執行查詢並取得結果

                    // 判斷是否存在符合條件的記錄
                    recordExists = count > 0;
                }
                catch (Exception ex)
                {
                    // 記錄錯誤或顯示錯誤訊息
                    Response.Write("<script>alert('資料庫查詢錯誤：" + ex.Message + "');</script>");
                }
            }
        }

        return recordExists;
    }

    // 檢查資料庫資料表Computer是否存在符合條件的記錄
    private bool CheckDatabaseForComputer(string ipAddress, string logindate)
    {
        bool record4Exists = false;

        // 設定資料庫連線字串 (請根據您的環境進行配置)
        string connectionString = "Server=TAMKANG-s1;Database=maintain;User Id=maintain;Password=Zxcv1234;";

        // 設定查詢語句
        string query = @"
            SELECT COUNT(1) FROM computer 
            WHERE computer_ip = @IPAddress 
                AND computer_lastdate = @LoginDate 
                AND computer_lastwu = @lastwu
                AND computer_lastsecure = @lastsecure 
                AND computer_compliant = @compliant
                AND computer_appupdate = @appupdate";

        // 使用 ADO.NET 執行查詢
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                // 添加查詢參數
                command.Parameters.AddWithValue("@IPAddress", ipAddress);
                command.Parameters.AddWithValue("@LoginDate", logindate);
                command.Parameters.AddWithValue("@lastwu", "Y");
                command.Parameters.AddWithValue("@lastsecure", "protected");
                command.Parameters.AddWithValue("@compliant", "Y");
                command.Parameters.AddWithValue("@appupdate", "Y");

                try
                {
                    connection.Open();
                    int count = (int)command.ExecuteScalar(); // 執行查詢並取得結果

                    // 判斷是否存在符合條件的記錄
                    record4Exists = count > 0;
                }
                catch (Exception ex)
                {
                    // 記錄錯誤或顯示錯誤訊息
                    Response.Write("<script>alert('資料庫查詢錯誤：" + ex.Message + "');</script>");
                }
            }
        }

        return record4Exists;
    }

    private string GetADUserDepartment(string userName)
    {
        try
        {
            // 設定 LDAP 路徑，並查詢使用者帳號
            string ldapPath = "LDAP://tamkang.com.tw"; // 替換為您的網域
            DirectoryEntry entry = new DirectoryEntry(ldapPath);
            DirectorySearcher search = new DirectorySearcher(entry)
            {
                Filter = $"(sAMAccountName={userName})" // 使用 sAMAccountName (登入名稱) 查詢
            };

            // 搜尋並取得使用者資訊
            search.PropertiesToLoad.Add("department"); // 加載部門屬性
            SearchResult result = search.FindOne();

            if (result != null && result.Properties["department"].Count > 0)
            {
                return result.Properties["department"][0].ToString(); // 回傳部門欄位的值
            }
            else
            {
                return null; // 若未找到部門資訊，回傳 null
            }
        }
        catch (Exception ex)
        {
            // 錯誤處理
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('查詢發生錯誤: {ex.Message}');", true);
            return null;
        }
    }
}