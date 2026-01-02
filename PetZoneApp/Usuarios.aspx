<%@ Page Title="Gestión de Usuarios y Roles" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="PetZoneApp.Usuarios" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row">
        <div class="col-12">
            <h2 class="text-danger"><i class="fa-solid fa-user-shield"></i> Seguridad y Usuarios</h2>
            <hr />
        </div>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="row">
                
                <div class="col-md-7">
                    <div class="card shadow-sm border-0">
                        <div class="card-body p-0">
                            <asp:GridView ID="gvUsuarios" runat="server" AutoGenerateColumns="False" 
                                DataKeyNames="UsuarioId" 
                                CssClass="table table-hover mb-0" GridLines="None"
                                OnSelectedIndexChanged="gvUsuarios_SelectedIndexChanged">
                                <HeaderStyle CssClass="bg-danger text-white" />
                                <Columns>
                                    <asp:BoundField DataField="Username" HeaderText="Usuario / Login" />
                                    <asp:BoundField DataField="Rol" HeaderText="Rol Asignado" />
                                    <asp:CheckBoxField DataField="Activo" HeaderText="¿Activo?" ItemStyle-HorizontalAlign="Center" />
                                    <asp:CommandField ShowSelectButton="True" SelectText="Gestionar" ControlStyle-CssClass="btn btn-sm btn-danger rounded-pill px-3" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="card shadow border-0">
                        <div class="card-header bg-danger text-white">
                            <h5 class="mb-0"><i class="fa-solid fa-user-pen"></i> Datos de Acceso</h5>
                        </div>
                        <div class="card-body">
                            
                            <div class="mb-3">
                                <label>Usuario (Login):</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                    <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control" />
                                </div>
                                <asp:RequiredFieldValidator ID="valUser" runat="server" ControlToValidate="txtUsuario" ErrorMessage="Requerido" ForeColor="Red" Display="Dynamic" />
                            </div>

                            <div class="mb-3">
                                <label>Contraseña:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-key"></i></span>
                                    <asp:TextBox ID="txtContrasena" runat="server" CssClass="form-control" TextMode="Password" />
                                </div>
                                <small class="text-muted">Dejar vacío para no cambiar la contraseña al editar.</small>
                            </div>

                            <div class="mb-3">
                                <label>Rol:</label>
                                <asp:DropDownList ID="cboRol" runat="server" CssClass="form-select" />
                                <asp:RequiredFieldValidator ID="valRol" runat="server" ControlToValidate="cboRol" InitialValue="0" ErrorMessage="Seleccione rol" ForeColor="Red" />
                            </div>

                            <div class="form-check mb-3">
                                <asp:CheckBox ID="chkActivo" runat="server" CssClass="form-check-input" Checked="True" />
                                <label class="form-check-label">Usuario Habilitado</label>
                            </div>

                            <div class="d-grid gap-2">
                                <asp:Button ID="btnGuardar" runat="server" Text="💾 Registrar Usuario" OnClick="btnGuardar_Click" CssClass="btn btn-dark" />
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnLimpiar" runat="server" Text="Nuevo" OnClick="btnLimpiar_Click" CssClass="btn btn-outline-secondary w-50" />
                                    <asp:Button ID="btnEliminar" runat="server" Text="Borrar" OnClick="btnEliminar_Click" CssClass="btn btn-outline-danger w-50" Enabled="False" />
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>