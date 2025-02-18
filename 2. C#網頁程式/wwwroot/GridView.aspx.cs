using System;
using System.Data;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
public partial class TAMKANG_GridView: System.Web.UI.Page 
{
private SqlConnection connection;
private SqlCommand command;
private SqlDataAdapter adapter;
private DataTable dt;
private string strConnection;
private string strConnectionName = "maintain";
protected void Page_Load(object sender, EventArgs e)
{
	/* �إ߸�Ʈw�s�u */
	strConnection = ConfigurationManager.ConnectionStrings[strConnectionName].ConnectionString;
	connection = new SqlConnection(strConnection);
	command = new SqlCommand();
	command.Connection = connection;
	if (!IsPostBack)
		GVGetData();
}
/// <summary>
/// ���o���
/// </summary>
private DataTable GetData()
{
    dt = new DataTable();
    command.CommandText = "SELECT computer_name, computer_ip, computer_lastuser, computer_lastdate, computer_lasttime, computer_lastupdate, computer_lastsecure, computer_compliant, computer_appupdate FROM computer";
    adapter = new SqlDataAdapter(command);
    adapter.Fill(dt);
    return dt;
}


/// <summary>
/// ���o���
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
/// ���o�ƧǸ��
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
/// �s����
/// </summary>
protected void gv_RowEditing(object sender, GridViewEditEventArgs e)
{
    gv.EditIndex = e.NewEditIndex;
    GVGetData();
}
/// <summary>
/// �����s��
/// </summary>
protected void gv_RowCancelingEdit(object sender, 
    GridViewCancelEditEventArgs e)
{
    gv.EditIndex = -1;
    GVGetData();
}
/// <summary>
/// ��s���
/// </summary>
protected void gv_RowUpdating(object sender, GridViewUpdateEventArgs e)
{
    string strcomputer_name, strcomputer_ip, strcomputer_lastuser, strcomputer_lastdate, strcomputer_lasttime, 
           strcomputer_lastupdate, strcomputer_lastsecure, strcomputer_compliant, strcomputer_appupdate;
    
    strcomputer_name = ((Label)gv.Rows[e.RowIndex].Cells[0].
        FindControl("lblcomputer_nameEdit")).Text;
    strcomputer_ip = ((TextBox)gv.Rows[e.RowIndex].Cells[0].
        FindControl("tbcomputer_ipEdit")).Text;
    strcomputer_lastuser = ((TextBox)gv.Rows[e.RowIndex].Cells[0].
        FindControl("tbcomputer_lastuserEdit")).Text;
    strcomputer_lastdate = ((TextBox)gv.Rows[e.RowIndex].Cells[0].
        FindControl("tbcomputer_lastdateEdit")).Text;
    strcomputer_lasttime = ((TextBox)gv.Rows[e.RowIndex].Cells[0].
        FindControl("tbcomputer_lasttimeEdit")).Text;
    strcomputer_lastupdate = ((TextBox)gv.Rows[e.RowIndex].Cells[0].
        FindControl("tbcomputer_lastupdateEdit")).Text;
    strcomputer_compliant = ((TextBox)gv.Rows[e.RowIndex].Cells[0].
        FindControl("tbcomputer_compliantEdit")).Text;
    strcomputer_appupdate = ((TextBox)gv.Rows[e.RowIndex].Cells[0].
        FindControl("tbcomputer_appupdate")).Text;

    /* ��s��� */
    command.Parameters.Clear();
    command.Parameters.AddWithValue("computer_name", strcomputer_name);
    command.Parameters.AddWithValue("computer_ip", strcomputer_ip);
    command.Parameters.AddWithValue("computer_lastuser", strcomputer_lastuser);
    command.Parameters.AddWithValue("computer_lastdate", strcomputer_lastdate);
    command.Parameters.AddWithValue("computer_lasttime", strcomputer_lasttime);
    command.Parameters.AddWithValue("computer_lastupdate", strcomputer_lastupdate);
    command.Parameters.AddWithValue("computer_compliant", strcomputer_compliant);
    command.Parameters.AddWithValue("computer_appupdate", strcomputer_appupdate);

    command.CommandText = 
        @"UPDATE computer SET computer_ip=@computer_ip, " +
        @"computer_lastuser=@computer_lastuser, computer_lastdate=@computer_lastdate, computer_lasttime=@computer_lasttime, " +
        @"computer_lastupdate=@computer_lastupdate, computer_compliant=@computer_compliant, computer_appupdate=@computer_appupdate " +
        @"WHERE computer_name=@computer_name ";
    connection.Open();
    command.ExecuteNonQuery();
    connection.Close();
    gv.EditIndex = -1;
    GVGetData();
}

/// <summary>
/// �R�����
/// </summary>
protected void gv_RowDeleting(object sender, GridViewDeleteEventArgs e)
{
    string strcomputer_name;
    strcomputer_name = ((Label)gv.Rows[e.RowIndex].Cells[0].
        FindControl("lblcomputer_name")).Text;
    /* �R����� */
    command.Parameters.Clear();
    command.Parameters.AddWithValue("computer_name", strcomputer_name);
    command.CommandText = 
        "DELETE FROM computer WHERE computer_name=@computer_name ";
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
/// �x�s���
/// </summary>
protected void lbSave_Click(object sender, EventArgs e)
{
    string strcomputer_name, strcomputer_ip, strcomputer_lastuser, strcomputer_lastdate, strcomputer_lasttime,
           strcomputer_lastupdate, strcomputer_lastsecure, strcomputer_compliant, strcomputer_appupdate;
    strcomputer_name = ((TextBox)gv.FooterRow.Cells[0].
        FindControl("tbcomputer_nameFooter")).Text;
    strcomputer_ip = ((TextBox)gv.FooterRow.Cells[0].
        FindControl("tbcomputer_ipFooter")).Text;
    strcomputer_lastuser = ((TextBox)gv.FooterRow.Cells[0].
        FindControl("tbcomputer_lastuserFooter")).Text;
    strcomputer_lastdate = ((TextBox)gv.FooterRow.Cells[0].
        FindControl("tbcomputer_lastdateFooter")).Text;
    strcomputer_lasttime = ((TextBox)gv.FooterRow.Cells[0].
        FindControl("tbcomputer_lasttimeFooter")).Text;
    strcomputer_lastupdate = ((TextBox)gv.FooterRow.Cells[0].
        FindControl("tbcomputer_lastupdateFooter")).Text;
    strcomputer_lastsecure = ((TextBox)gv.FooterRow.Cells[0].
        FindControl("tbcomputer_lastsecureFooter")).Text;
    strcomputer_compliant = ((DropDownList)gv.FooterRow.Cells[0].
        FindControl("ddlcomputer_compliantFooter")).SelectedValue;
    strcomputer_appupdate = ((DropDownList)gv.FooterRow.Cells[0].
        FindControl("ddlcomputer_appupdateFooter")).SelectedValue;
    
    /* �s�W��� */
    command.Parameters.Clear();
    command.Parameters.AddWithValue("computer_name", strcomputer_name);
    command.Parameters.AddWithValue("computer_ip", strcomputer_ip);
    command.Parameters.AddWithValue("computer_lastuser", strcomputer_lastuser);
    command.Parameters.AddWithValue("computer_lastdate", strcomputer_lastdate);
    command.Parameters.AddWithValue("computer_lasttime", strcomputer_lasttime);
    command.Parameters.AddWithValue("computer_lastupdate", strcomputer_lastupdate);
    command.Parameters.AddWithValue("computer_lastsecure", strcomputer_lastsecure);
    command.Parameters.AddWithValue("computer_compliant", strcomputer_compliant);
    command.Parameters.AddWithValue("computer_appupdate", strcomputer_appupdate);
    
    command.CommandText = 
        @"INSERT INTO computer (computer_name, computer_ip, computer_lastuser, computer_lastdate, 
          computer_lasttime, computer_lastupdate, computer_lastsecure, computer_compliant, computer_appupdate) 
          VALUES (@computer_name, @computer_ip, @computer_lastuser, @computer_lastdate, 
                  @computer_lasttime, @computer_lastupdate, @computer_lastsecure, @computer_compliant, @computer_appupdate)";
    
    connection.Open();
    command.ExecuteNonQuery();
    connection.Close();
    GVGetData();
}

/// <summary>
/// ����
/// </summary>
protected void gv_PageIndexChanging(object sender, GridViewPageEventArgs e)
{
    gv.PageIndex = e.NewPageIndex;
    GVGetData();
}
/// <summary>
/// �Ƨ�
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
    // �p�G���P���Ӥ��P
    if (se != e.SortExpression)
    {
        // �������ثe�ҫ��w���
        se = e.SortExpression;
        // ���w�ƦC�覡���ɾ�
        sd = SortDirection.Ascending;
    }
    // �p�G���P���ӬۦP
    else
    {
        // �����ɾ��������A�������ɾ�
        if (sd == SortDirection.Ascending)
            sd = SortDirection.Descending;
        else
            sd = SortDirection.Ascending;
    }
    // �������P�ƦC�覡 ( �ɾ��έ��� )
    ViewState["se"] = se;
    ViewState["sd"] = sd;
    GVGetData(sd, se);
}
}