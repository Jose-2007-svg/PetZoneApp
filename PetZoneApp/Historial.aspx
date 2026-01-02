<%@ Page Title="Historial de Ventas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Historial.aspx.cs" Inherits="PetZoneApp.Historial" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %></h2>
    <hr />

    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="upHistorial" runat="server">
        <ContentTemplate>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h4>📋 Listado de Órdenes</h4>
                        </div>
                        <div class="card-body">
                            <asp:GridView ID="gvOrdenes" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="OrdenId" CssClass="table table-hover" 
                                OnSelectedIndexChanged="gvOrdenes_SelectedIndexChanged" AllowPaging="True" PageSize="5" OnPageIndexChanging="gvOrdenes_PageIndexChanging">
                                <Columns>
                                    <asp:BoundField DataField="OrdenId" HeaderText="N° Orden" />
                                    <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                                    <asp:BoundField DataField="Cliente" HeaderText="Cliente" />
                                    <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:C2}" />
                                    <asp:CommandField ShowSelectButton="True" SelectText="🔍 Ver Detalle" ButtonType="Button" ControlStyle-CssClass="btn btn-sm btn-info" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            <h4>📦 Productos en la Orden #<asp:Label ID="lblOrdenSeleccionada" runat="server" Text="---" /></h4>
                        </div>
                        <div class="card-body">
                            <asp:Label ID="lblMensajeDetalle" runat="server" Text="Seleccione una orden para ver sus productos." ForeColor="Gray" Font-Italic="True"></asp:Label>
                            
                            <asp:GridView ID="gvDetalle" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered" Visible="False">
                                <Columns>
                                    <asp:BoundField DataField="Producto" HeaderText="Producto" />
                                    <asp:BoundField DataField="Cantidad" HeaderText="Cantidad" />
                                    <asp:BoundField DataField="PrecioUnitario" HeaderText="P. Unitario" DataFormatString="{0:C2}" />
                                    <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" DataFormatString="{0:C2}" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>