<%@ Page Title="GridView2" Language="C#" Debug="true" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="GridView2.aspx.cs" Inherits="TAMKANG_GridView2" %>  
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:Label id="Labeltitle" Text="�ϥΪ̱��Ҹ�T�d��" Font-Size="20px" runat="server"/>
<asp:RadioButton id="Radio1" Text="����" Checked="True" GroupName="RadioGroup1" runat="server"/>
<asp:RadioButton id="Radio2" Text="�@�g" GroupName="RadioGroup1" runat="server"/>
<asp:RadioButton id="Radio3" Text="�@��" GroupName="RadioGroup1" runat="server"/>
<asp:RadioButton id="Radio4" Text="�@�u" GroupName="RadioGroup1" runat="server"/>
<asp:RadioButton id="Radio5" Text="�@�~" GroupName="RadioGroup1" runat="server"/>
<asp:button text="���������T�{����(�_�l��)" OnClick="SubmitBtn_Click" runat="server"/>
<asp:Label id="Label1" font-bold="true" runat="server"/>
<asp:GridView ID="gv" runat="server" AutoGenerateColumns="false" 
    OnRowEditing="gv_RowEditing" OnRowCancelingEdit="gv_RowCancelingEdit"
    OnRowUpdating="gv_RowUpdating" BackColor="#DDDDDD" BorderStyle="None"
    BorderWidth="1px" CellPadding="5" CellSpacing="1" GridLines="None"
    Style="line-height:22px; width:100%; font-size:16px;" onrowdeleting="gv_RowDeleting" 
    AllowPaging="True" onpageindexchanging="gv_PageIndexChanging" 
    PageSize="15" AllowSorting="True" onsorting="gv_Sorting" Runat="server">
    <RowStyle BackColor="#ffffff" ForeColor="Black" />
    <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
    <PagerStyle BackColor="#efefef" HorizontalAlign="Center" Font-Size="20px" />
    <HeaderStyle BackColor="#efefef" Font-Bold="True" />
    <AlternatingRowStyle BackColor="#f7fafe" />
    <EmptyDataTemplate>
        Sorry, No any data.
    </EmptyDataTemplate>
    <Columns>
    <%--<asp:TemplateField>
            <HeaderTemplate>
                '<asp:LinkButton ID="lbInsert" runat="server" style="display:block;text-align:left;width:70px" onclick="lbInsert_Click">�s�W</asp:LinkButton> 
                <asp:Label ID="lbInsert" runat="server" style="display:block;text-align:left;width:85px">��Ƣ@���</asp:Label>
            </HeaderTemplate>
            <ItemTemplate>
                <asp:LinkButton ID="lbEdit" runat="server" 
                CommandName="Edit">�s��</asp:LinkButton> 
                |
                <asp:LinkButton ID="lbDelete" runat="server" 
                OnClientClick="javascript:return confirm('�T�w�R��?')" 
                CommandName="Delete">�R��</asp:LinkButton>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:LinkButton ID="lbUpdate" runat="server" 
                CommandName="Update">��s</asp:LinkButton>
                |
                <asp:LinkButton ID="lbCancelUpdate" runat="server" 
                CommandName="Cancel">����</asp:LinkButton>
            </EditItemTemplate>
            <FooterTemplate>
                <asp:LinkButton ID="lbSave" runat="server" 
                onclick="lbSave_Click">�x�s</asp:LinkButton>
                |
                <asp:LinkButton ID="lbCancelSave" runat="server" 
                onclick="lbCancelSave_Click">����</asp:LinkButton>
            
            </FooterTemplate>
        </asp:TemplateField>--%> 
        <asp:TemplateField HeaderText="�ϥΪ̱b��" SortExpression="computer_user">
            <ItemTemplate>
                <asp:Label ID="lblcomputer_user" runat="server" 
                Text='<%# Eval("computer_user") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="tbcomputer_userEdit" runat="server" 
                Text='<%# Eval("computer_user") %>'></asp:TextBox>
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="tbcomputer_userFooter" runat="server" 
                Text=""></asp:TextBox>
            </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="�Ҧ��n�J���" SortExpression="computer_date">
            <ItemTemplate>
                <asp:Label ID="lblcomputer_date" runat="server" 
                Text='<%# Eval("computer_date") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:Label ID="tbcomputer_dateEdit" runat="server" 
                Text='<%# Eval("computer_date") %>'></asp:Label>
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="tbcomputer_dateFooter" runat="server" 
                Text=""></asp:TextBox>
            </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="�Ҧ��n�J�ɶ�" SortExpression="computer_time">
            <ItemTemplate>
                <asp:Label ID="lblcomputer_time" runat="server" 
                Text='<%# Eval("computer_time") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:Label ID="tbcomputer_timeEdit" runat="server" 
                Text='<%# Eval("computer_time") %>'></asp:Label>
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="tbcomputer_timeFooter" runat="server" 
                Text=""></asp:TextBox>
            </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="�g��n�J" SortExpression="computer_daysoff">
            <ItemTemplate>
                <asp:Label ID="lblcomputer_daysoff" runat="server" 
                Text='<%# Eval("computer_daysoff") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="tbcomputer_daysoffEdit" runat="server" 
                Text='<%# Eval("computer_daysoff") %>'></asp:TextBox>
            </EditItemTemplate>
            <FooterTemplate>
                <asp:TextBox ID="tbcomputer_daysoffFooter" runat="server" 
                Text=""></asp:TextBox>
            </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="�q���W��" SortExpression="computer_name">
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
        <asp:TemplateField HeaderText="�q����}" SortExpression="computer_ip">
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
	<asp:TemplateField HeaderText="�����j�w���A" SortExpression="computer_auth">
     	    <ItemTemplate>
        	<asp:Label ID="lblcomputer_auth" runat="server" 
        	Text='<%# Eval("computer_auth") %>'></asp:Label>
    	    </ItemTemplate>
    	    <EditItemTemplate>
        	<asp:TextBox ID="tbcomputer_authEdit" runat="server" 
        	Text='<%# Eval("computer_auth") %>'></asp:TextBox>
    	    </EditItemTemplate>
    	    <FooterTemplate>
        <asp:TextBox ID="tbcomputer_authFooter" runat="server" 
        Text=""></asp:TextBox>
    </FooterTemplate>
</asp:TemplateField>
		
    </Columns>
</asp:GridView>
</asp:Content>
