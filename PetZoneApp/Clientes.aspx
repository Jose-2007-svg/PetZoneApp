<%@ Page Title="Gestión de Clientes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Clientes.aspx.cs" Inherits="PetZoneApp.Clientes" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
        <div class="col-12">
            <h2 class="text-primary"><i class="fa-solid fa-users"></i> Gestión de Clientes</h2>
            <hr />
        </div>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="row">
                
                <div class="col-md-8">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-dark text-white">
                            <h5 class="mb-0">Listado de Clientes</h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <asp:GridView ID="gvClientes" runat="server" AutoGenerateColumns="False" 
                                    DataKeyNames="ClienteId" 
                                    CssClass="table table-striped table-hover mb-0" GridLines="None"
                                    OnSelectedIndexChanged="gvClientes_SelectedIndexChanged">
                                    <HeaderStyle CssClass="table-dark" />
                                    <Columns>
                                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                                        <asp:BoundField DataField="Documento" HeaderText="DNI/RUC" />
                                        <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
                                        <asp:BoundField DataField="Email" HeaderText="Email" />
                                        <asp:CommandField ShowSelectButton="True" SelectText="✏️ Editar" ControlStyle-CssClass="btn btn-sm btn-outline-primary" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Datos del Cliente</h5>
                        </div>
                        <div class="card-body">
                            
                            <div class="mb-2">
                                <label>Nombre Completo:</label>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="valNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="* Requerido" ForeColor="Red" Display="Dynamic" />
                            </div>

                            <div class="mb-2">
                                <label>Documento (DNI/RUC):</label>
                                <asp:TextBox ID="txtDocumento" runat="server" CssClass="form-control" />
                            </div>

                            <div class="mb-2">
                                <label>Teléfono:</label>
                                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" />
                            </div>

                            <div class="mb-2">
                                <label>Dirección:</label>
                                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" />
                            </div>

                            <div class="mb-3">
                                <label>Email:</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
                            </div>

                            <div class="d-grid gap-2">
                                <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar" OnClick="btnGuardar_Click" CssClass="btn btn-success" />
                                <div class="btn-group">
                                    <asp:Button ID="btnLimpiar" runat="server" Text="✨ Nuevo" OnClick="btnLimpiar_Click" CssClass="btn btn-secondary" />
                                    <asp:Button ID="btnEliminar" runat="server" Text="🗑️ Eliminar" OnClick="btnEliminar_Click" CssClass="btn btn-danger" Enabled="False" OnClientClick="return confirm('¿Eliminar cliente?');" />
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>