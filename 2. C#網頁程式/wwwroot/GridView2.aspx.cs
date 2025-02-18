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
public partial class TAMKANG_GridView2: System.Web.UI.Page 
{
private SqlConnection connection;
private SqlCommand command;
private SqlDataAdapter adapter;
private DataTable dt;
private string strConnection;
private string strConnectionName = "maintain";
protected void Page_Load(object sender, EventArgs e)
{
	/* 建立資料庫連線 */
	strConnection = ConfigurationManager.ConnectionStrings[strConnectionName].ConnectionString;
	connection = new SqlConnection(strConnection);
	command = new SqlCommand();
	command.Connection = connection;
	if (!IsPostBack)
		GVGetData();
}
/// <summary>
/// 取得資料
/// </summary>
private DataTable GetData()
{
    dt = new DataTable();
	if (Radio1.Checked) {
		command.CommandText = "SELECT * FROM wmsinfo Order By computer_date DESC";
	}
	else {
		command.CommandText = "SELECT * FROM wmsinfo WHERE computer_date >= '" + Label1.Text + "' Order By computer_date DESC";
	}	
    adapter = new SqlDataAdapter(command); 
    adapter.Fill(dt);
    return dt;
}
/// <summary>
/// 取得資料
/// </summary>
private void GVGetData()
{
    DataTable _dt;
    if (ViewState["se"] == null)
    {
        _dt = GetData();
        gv.DataSource = _dt;
        gv.DataBind();
    }
    else
    {
        string se = Convert.ToString(ViewState["se"]);
        SortDirection sd = (SortDirection)ViewState["sd"];
        this.GVGetData(sd, se);
    }
}
/// <summary>
/// 取得排序資料
/// </summary>
private void GVGetData(SortDirection pSortDirection, string pSortExpression)
{
    DataTable _dt = GetData();

    string sSort = string.Empty;
    if (pSortDirection == SortDirection.Ascending)
    {
        sSort = pSortExpression;
    }
    else
    {
        sSort = string.Format("{0} {1}", pSortExpression, "DESC"); 
    }
    DataView dv = _dt.DefaultView;
    dv.Sort = sSort;
    gv.DataSource = dv;
    gv.DataBind();
}
/// <summary>
/// 編輯資料
/// </summary>
protected void gv_RowEditing(object sender, GridViewEditEventArgs e)
{
    gv.EditIndex = e.NewEditIndex;
    GVGetData();
}
/// <summary>
/// 取消編輯
/// </summary>
protected void gv_RowCancelingEdit(object sender, 
    GridViewCancelEditEventArgs e)
{
    gv.EditIndex = -1;
    GVGetData();
}
/// <summary>
/// 更新資料
/// </summary>
protected void gv_RowUpdating(object sender, GridViewUpdateEventArgs e)
{
    string strcomputer_name, strcomputer_ip, strcomputer_user, strcomputer_date, strcomputer_time, strcomputer_daysoff, strcomputer_auth;
    
    strcomputer_name = ((Label)gv.Rows[e.RowIndex].Cells[0].FindControl("lblcomputer_nameEdit")).Text;
    strcomputer_ip = ((TextBox)gv.Rows[e.RowIndex].Cells[0].FindControl("tbcomputer_ipEdit")).Text;
    strcomputer_user = ((TextBox)gv.Rows[e.RowIndex].Cells[0].FindControl("tbcomputer_userEdit")).Text;
    strcomputer_date = ((Label)gv.Rows[e.RowIndex].Cells[0].FindControl("tbcomputer_dateEdit")).Text;
    strcomputer_time = ((Label)gv.Rows[e.RowIndex].Cells[0].FindControl("tbcomputer_timeEdit")).Text;
    strcomputer_daysoff = ((TextBox)gv.Rows[e.RowIndex].Cells[0].FindControl("tbcomputer_daysoffEdit")).Text;
    strcomputer_auth = ((TextBox)gv.Rows[e.RowIndex].Cells[0].FindControl("tbcomputer_authEdit")).Text; 
    
    /* 更新資料 */
    command.Parameters.Clear();
    command.Parameters.AddWithValue("computer_name", strcomputer_name);
    command.Parameters.AddWithValue("computer_ip", strcomputer_ip);
    command.Parameters.AddWithValue("computer_user", strcomputer_user);
    command.Parameters.AddWithValue("computer_date", strcomputer_date);
    command.Parameters.AddWithValue("computer_time", strcomputer_time);
    command.Parameters.AddWithValue("computer_daysoff", strcomputer_daysoff);
    command.Parameters.AddWithValue("computer_auth", strcomputer_auth);

    command.CommandText = 
        @"UPDATE wmsinfo SET, computer_ip=@computer_ip, " +
        @"computer_user=@computer_user, computer_daysoff=@computer_daysoff, " +
        @"computer_auth=@computer_auth " +
        @"WHERE computer_name=@computer_name";
    
    connection.Open();
    command.ExecuteNonQuery();
    connection.Close();
    
    gv.EditIndex = -1;
    GVGetData();
}

/// <summary>
/// 刪除資料
/// </summary>
protected void gv_RowDeleting(object sender, GridViewDeleteEventArgs e)
{
    string strcomputer_name;
    strcomputer_name = ((Label)gv.Rows[e.RowIndex].Cells[0].
        FindControl("lblcomputer_name")).Text;
    /* 刪除資料 */
    command.Parameters.Clear();
    command.Parameters.AddWithValue("computer_name", strcomputer_name);
    command.CommandText = 
        "DELETE FROM wmsinfo WHERE computer_name=@computer_name ";
    connection.Open();
    command.ExecuteNonQuery();
    connection.Close();
    GVGetData();
}

protected void lbInsert_Click(object sender, EventArgs e)
{
    gv.FooterRow.Visible = true;
}

protected void lbCancelSave_Click(object sender, EventArgs e)
{
    gv.FooterRow.Visible = false;
}
/// <summary>
/// 儲存資料
/// </summary>
protected void lbSave_Click(object sender, EventArgs e)
{
    string strcomputer_name, strcomputer_ip, strcomputer_user, strcomputer_date, strcomputer_time, strcomputer_daysoff, strcomputer_auth;
    
    strcomputer_name = ((TextBox)gv.FooterRow.Cells[0].FindControl("tbcomputer_nameFooter")).Text;
    strcomputer_ip = ((TextBox)gv.FooterRow.Cells[0].FindControl("tbcomputer_ipFooter")).Text;
    strcomputer_user = ((TextBox)gv.FooterRow.Cells[0].FindControl("tbcomputer_userFooter")).Text;
    strcomputer_date = ((TextBox)gv.FooterRow.Cells[0].FindControl("tbcomputer_dateFooter")).Text;
    strcomputer_time = ((TextBox)gv.FooterRow.Cells[0].FindControl("tbcomputer_timeFooter")).Text;
    strcomputer_daysoff = ((TextBox)gv.FooterRow.Cells[0].FindControl("tbcomputer_daysoffFooter")).Text;
    strcomputer_auth = ((TextBox)gv.FooterRow.Cells[0].FindControl("tbcomputer_authFooter")).Text; 
    
    /* 新增資料 */
    command.Parameters.Clear();
    command.Parameters.AddWithValue("computer_name", strcomputer_name);
    command.Parameters.AddWithValue("computer_ip", strcomputer_ip);
    command.Parameters.AddWithValue("computer_user", strcomputer_user);
    command.Parameters.AddWithValue("computer_date", strcomputer_date);
    command.Parameters.AddWithValue("computer_time", strcomputer_time);
    command.Parameters.AddWithValue("computer_daysoff", strcomputer_daysoff);
    command.Parameters.AddWithValue("computer_auth", strcomputer_auth);

    command.CommandText = 
        @"INSERT INTO wmsinfo (computer_name, computer_ip, " + 
        @"computer_user, computer_date, computer_time, computer_daysoff, computer_auth) VALUES (@computer_name, " +
        @"@computer_ip, @computer_user, @computer_date, @computer_time, @computer_daysoff, @computer_auth)";
    
    connection.Open();
    command.ExecuteNonQuery();
    connection.Close();
    
    GVGetData();
}
/// <summary>
/// 換頁
/// </summary>
protected void gv_PageIndexChanging(object sender, GridViewPageEventArgs e)
{
    gv.PageIndex = e.NewPageIndex;
    GVGetData();
}
/// <summary>
/// 排序
/// </summary>
protected void gv_Sorting(object sender, GridViewSortEventArgs e)
{
    string se = ViewState["se"] != null ? 
        Convert.ToString(ViewState["se"]) : string.Empty;
    SortDirection sd = ViewState["sd"] != null ? 
        (SortDirection)ViewState["sd"] : SortDirection.Ascending;

    if (string.IsNullOrEmpty(se))
    {
        se = e.SortExpression;
        sd = SortDirection.Ascending;
    }
    // 如果欄位與本來不同
    if (se != e.SortExpression)
    {
        // 切換為目前所指定欄位
        se = e.SortExpression;
        // 指定排列方式為升冪
        sd = SortDirection.Ascending;
    }
    // 如果欄位與本來相同
    else
    {
        // 切換升冪為降冪，降冪為升冪
        if (sd == SortDirection.Ascending)
            sd = SortDirection.Descending;
        else
            sd = SortDirection.Ascending;
    }
    // 紀錄欄位與排列方式 ( 升冪或降冪 )
    ViewState["se"] = se;
    ViewState["sd"] = sd;
    GVGetData(sd, se);
}
/// <summary>
/// 選取資料期間起始日
/// </summary>
protected void SubmitBtn_Click(Object Sender, EventArgs e) 
{
	if (Radio1.Checked) {
		Label1.Text = "";
	}
	else if (Radio2.Checked) {
		Label1.Text = DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd");
	}
	else if (Radio3.Checked) {
		Label1.Text = DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd");
	}
	else if (Radio4.Checked) {
		Label1.Text = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
	}
	else if (Radio5.Checked) {
		Label1.Text = DateTime.Now.AddYears(-1).ToString("yyyy-MM-dd");
	}
	GVGetData();
}
}