<%@ Page Title="Reportes Gerenciales" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="PetZoneApp.Reportes" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    
    <div style="border: 1px solid #ccc; padding: 20px; background-color: #f9f9f9;">
        <h3>Opciones de Generación de Reporte</h3>

        <p><strong>Tipo de Reporte:</strong></p>
        <asp:DropDownList ID="cboTipoReporte" runat="server" CssClass="form-control" Width="300px">
            <asp:ListItem Value="1">Ventas por Mes</asp:ListItem>
            <asp:ListItem Value="2">Stock Mínimo de Productos</asp:ListItem>
            <asp:ListItem Value="3">Listado de Clientes</asp:ListItem>
        </asp:DropDownList>

        <p style="margin-top: 15px;"><strong>Período (Desde / Hasta):</strong></p>
        <div style="display: flex; gap: 15px;">
            <asp:TextBox ID="txtFechaInicio" runat="server" TextMode="Date" CssClass="form-control" />
            <asp:TextBox ID="txtFechaFin" runat="server" TextMode="Date" CssClass="form-control" />
        </div>
        
        <br />
        <asp:Button ID="btnGenerar" runat="server" Text="📤 Generar Reporte (Excel)" OnClick="btnGenerar_Click" CssClass="btn btn-warning btn-lg" />
        <br />
        <asp:Label ID="lblMensaje" runat="server" ForeColor="Green" Font-Bold="True" Visible="False" />
    </div>

</asp:Content>