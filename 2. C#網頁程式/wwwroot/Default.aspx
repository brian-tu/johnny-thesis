<%@ Page Title="Home Page" Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="WebApplication2_Default" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>登入頁面</title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="jumbotron">
        <center><h1>設備健康管理伺服器網站</h1></center>
    </div>
        <div>
            <h2>使用者登入</h2>
            <asp:Label ID="lblUsername" runat="server" Text="帳號：" AssociatedControlID="txtUsername"></asp:Label>
            <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="lblPassword" runat="server" Text="密碼：" AssociatedControlID="txtPassword"></asp:Label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
            <br />
            <br />
            <asp:Button ID="btnLogin" runat="server" Text="登入" OnClick="btnLogin_Click" />
            <br />
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </form>
</body>
</html>

