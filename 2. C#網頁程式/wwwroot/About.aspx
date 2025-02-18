<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WebApplication2.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:Label id="Labeltitle" Text="關於操作說明" Font-Size="20px" runat="server"/>
<h3><電腦設備健康狀態查詢></h3>
<h4>1.點選[最近登入日期]欄位標題以排序查找異常登入日期，例如休假日登入。</h4>
<h4>2.點選[最近登入時間]欄位標題以排序查找異常登入時間，例如夜間登入。</h4>
<h4>3.點選[最近更新時間]欄位標題以排序查找許久未做系統安全性更新，例如超過1個月。</h4>
<h4>4.點選[防毒狀態]欄位標題以排序查找防毒狀態異常，例如顯示abnormal。</h4>
<h3><使用者情境資訊查詢></h3>
<h4>1.選取欲查詢期間，從多久之前至今日為止的期間。</h4>
<h4>2.點選[使用者帳號]欄位標題以排序查找最高權限administrator帳號登入是否異常，例如次數、日期或時間。</h4>
<h4>3.點選[所有登入時間]欄位標題以排序查找所有異常登入時間，例如夜間登入。</h4>
<h4>4.點選[週休登入]欄位標題以排序查找所有異常登入日期，例如休假日登入。</h4>
</asp:Content>

