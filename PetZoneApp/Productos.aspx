<%@ Page Title="Gestión de Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="PetZoneApp.Productos" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
        <div class="col-12">
            <h2 class="text-success"><i class="fa-solid fa-box"></i> Inventario de Productos</h2>
            <hr />
        </div>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="row">
                
                <div class="col-md-8">
                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <asp:GridView ID="gvProductos" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="ProductoId" 
                                CssClass="table table-hover align-middle mb-0" GridLines="None"
                                OnSelectedIndexChanged="gvProductos_SelectedIndexChanged">
                                <HeaderStyle CssClass="bg-success text-white" />
                                <Columns>
                                    <asp:BoundField DataField="Nombre" HeaderText="Producto" />
                                    <asp:BoundField DataField="Precio" HeaderText="Precio" DataFormatString="{0:C2}" />
                                    <asp:BoundField DataField="Stock" HeaderText="Stock" ItemStyle-Font-Bold="true" />
                                    <asp:CommandField ShowSelectButton="True" SelectText="✏️" ControlStyle-CssClass="btn btn-sm btn-light text-success fw-bold" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">Editar Producto</h5>
                        </div>
                        <div class="card-body">
                            
                            <div class="mb-2">
                                <label>Nombre del Producto:</label>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="valNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="* Requerido" ForeColor="Red" />
                            </div>

                            <div class="row">
                                <div class="col-6 mb-2">
                                    <label>Precio:</label>
                                    <div class="input-group">
                                        <span class="input-group-text">S/.</span>
                                        <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="valPrecio" runat="server" ControlToValidate="txtPrecio" ErrorMessage="*" ForeColor="Red" />
                                </div>
                                <div class="col-6 mb-2">
                                    <label>Stock:</label>
                                    <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" />
                                    <asp:RequiredFieldValidator ID="valStock" runat="server" ControlToValidate="txtStock" ErrorMessage="*" ForeColor="Red" />
                                </div>
                            </div>

                            <hr />
                            <div class="d-grid gap-2">
                                <asp:Button ID="btnGuardar" runat="server" Text="Guardar Cambios" OnClick="btnGuardar_Click" CssClass="btn btn-success" />
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnLimpiar" runat="server" Text="Cancelar" OnClick="btnLimpiar_Click" CssClass="btn btn-outline-secondary w-50" />
                                    <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" OnClick="btnEliminar_Click" CssClass="btn btn-outline-danger w-50" Enabled="False" />
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>