<%@ Page Language="C#" Debug="true" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="GridView.aspx.cs" Inherits="TAMKANG_GridView" %>  
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label id="Labeltitle" Text="電腦設備健康狀態查詢" Font-Size="20px" runat="server"/>
    <asp:GridView ID="gv" runat="server" AutoGenerateColumns="false" 
        OnRowEditing="gv_RowEditing" OnRowCancelingEdit="gv_RowCancelingEdit"
        OnRowUpdating="gv_RowUpdating" BackColor="#DDDDDD" BorderStyle="None"
        BorderWidth="1px" CellPadding="5" CellSpacing="1" GridLines="None"
        Style="line-height:22px; width:100%; font-size:16px;" onrowdeleting="gv_RowDeleting" 
        AllowPaging="True" onpageindexchanging="gv_PageIndexChanging" 
        PageSize="15" AllowSorting="True" onsorting="gv_Sorting">
        
        <RowStyle BackColor="#ffffff" ForeColor="Black" />
        <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
        <PagerStyle BackColor="#efefef" HorizontalAlign="Center" Font-Size="20px" />
        <HeaderStyle BackColor="#efefef" Font-Bold="True" />
        <AlternatingRowStyle BackColor="#f7fafe" />
        <EmptyDataTemplate>
            Sorry, No any data.
        </EmptyDataTemplate>
        
        <Columns> 
            <asp:TemplateField HeaderText="電腦名稱" SortExpression="computer_name">
                <ItemTemplate>
                    <asp:Label ID="lblcomputer_name" runat="server" 
                    Text='<%# Eval("computer_name") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:Label ID="lblcomputer_nameEdit" runat="server" 
                    Text='<%# Eval("computer_name") %>'></asp:Label>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="tbcomputer_nameFooter" runat="server" 
                    Text=""></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="電腦位址" SortExpression="computer_ip">
                <ItemTemplate>
                    <asp:Label ID="lblcomputer_ip" runat="server" 
                    Text='<%# Eval("computer_ip") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="tbcomputer_ipEdit" runat="server" 
                    Text='<%# Eval("computer_ip") %>' ></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="tbcomputer_ipFooter" runat="server" 
                    Text=""></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="使用者帳號" SortExpression="computer_lastuser">
                <ItemTemplate>
                    <asp:Label ID="lblcomputer_lastuser" runat="server" 
                    Text='<%# Eval("computer_lastuser") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="tbcomputer_lastuserEdit" runat="server" 
                    Text='<%# Eval("computer_lastuser") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="tbcomputer_lastuserFooter" runat="server" 
                    Text=""></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="最近登入日期" SortExpression="computer_lastdate">
                <ItemTemplate>
                    <asp:Label ID="lblcomputer_lastdate" runat="server" 
                    Text='<%# Eval("computer_lastdate") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="tbcomputer_lastdateEdit" runat="server" 
                    Text='<%# Eval("computer_lastdate") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="tbcomputer_lastdateFooter" runat="server" 
                    Text=""></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="最近登入時間" SortExpression="computer_lasttime">
                <ItemTemplate>
                    <asp:Label ID="lblcomputer_lasttime" runat="server" 
                    Text='<%# Eval("computer_lasttime") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="tbcomputer_lasttimeEdit" runat="server" 
                    Text='<%# Eval("computer_lasttime") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="tbcomputer_lasttimeFooter" runat="server" 
                    Text=""></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="系統更新日期" SortExpression="computer_lastupdate">
                <ItemTemplate>
                    <asp:Label ID="lblcomputer_lastupdate" runat="server" 
                    Text='<%# Eval("computer_lastupdate") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="tbcomputer_lastupdateEdit" runat="server" 
                    Text='<%# Eval("computer_lastupdate") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="tbcomputer_lastupdateFooter" runat="server" 
                    Text=""></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="防毒狀態" SortExpression="computer_lastsecure">
                <ItemTemplate>
                    <asp:Label ID="lblcomputer_lastsecure" runat="server" 
                    Text='<%# Eval("computer_lastsecure") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="tbcomputer_lastsecureEdit" runat="server" 
                    Text='<%# Eval("computer_lastsecure") %>'></asp:TextBox>
                </EditItemTemplate>
                <FooterTemplate>
                    <asp:TextBox ID="tbcomputer_lastsecureFooter" runat="server" 
                    Text=""></asp:TextBox>
                </FooterTemplate>
            </asp:TemplateField>
	        <asp:TemplateField HeaderText="組態合規" SortExpression="computer_compliant">
    	        <ItemTemplate>
           	        <asp:Label ID="lblcomputer_compliant" runat="server" Text='<%# Eval("computer_compliant") %>'></asp:Label>
                </ItemTemplate>
    	        <EditItemTemplate>
                    <asp:DropDownList ID="ddlcomputer_compliantEdit" runat="server">
                        <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                        <asp:ListItem Text="No" Value="N"></asp:ListItem>
                    </asp:DropDownList>
    	        </EditItemTemplate>
    	        <FooterTemplate>
                    <asp:DropDownList ID="ddlcomputer_compliantFooter" runat="server">
                        <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                        <asp:ListItem Text="No" Value="N"></asp:ListItem>
                    </asp:DropDownList>
    	        </FooterTemplate>
	        </asp:TemplateField>
	        <asp:TemplateField HeaderText="軟體更新" SortExpression="computer_appupdate">
    	        <ItemTemplate>
           	        <asp:Label ID="lblcomputer_appupdate" runat="server" Text='<%# Eval("computer_appupdate") %>'></asp:Label>
                </ItemTemplate>
    	        <EditItemTemplate>
                    <asp:DropDownList ID="ddlcomputer_appupdateEdit" runat="server">
                        <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                        <asp:ListItem Text="No" Value="N"></asp:ListItem>
                    </asp:DropDownList>
    	        </EditItemTemplate>
    	        <FooterTemplate>
                    <asp:DropDownList ID="ddlcomputer_appupdateFooter" runat="server">
                        <asp:ListItem Text="Yes" Value="Y"></asp:ListItem>
                        <asp:ListItem Text="No" Value="N"></asp:ListItem>
                    </asp:DropDownList>
    	        </FooterTemplate>
	        </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
