<%@ Page Title="Registro de Órdenes de Venta" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ordenes.aspx.cs" Inherits="PetZoneApp.Ordenes" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row g-4">
        <div class="col-12">
            <h2 class="text-primary"><i class="fa-solid fa-cart-shopping"></i> Nueva Venta</h2>
            <hr />
        </div>

        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" class="w-100">
            <ContentTemplate>

                <div class="card shadow-sm mb-4 border-0">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fa-solid fa-user"></i> Datos del Cliente</h5>
                    </div>
                    <div class="card-body">
                        <div class="row align-items-end">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Seleccionar Cliente:</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-search"></i></span>
                                    <asp:DropDownList ID="cboCliente" runat="server" CssClass="form-select" AutoPostBack="True" OnSelectedIndexChanged="cboCliente_SelectedIndexChanged" />
                                </div>
                                <asp:RequiredFieldValidator ID="valCliente" runat="server" ControlToValidate="cboCliente" InitialValue="0" ErrorMessage="Seleccione cliente" ForeColor="Red" ValidationGroup="Orden" Display="Dynamic" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label text-muted">Fecha:</label>
                                <asp:Label ID="lblFecha" runat="server" CssClass="form-control bg-light fw-bold" Text="--/--/----" />
                            </div>
                            <div class="col-md-3 text-end">
                                <label class="form-label text-muted">Vendedor:</label>
                                <br />
                                <span class="badge bg-info text-dark p-2"><asp:Label ID="lblVendedor" runat="server" Text="Admin" /></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-5">
                        <div class="card shadow-sm border-0 h-100">
                            <div class="card-header bg-secondary text-white">
                                <h5 class="mb-0"><i class="fa-solid fa-box-open"></i> Agregar Producto</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label">Producto:</label>
                                    <asp:DropDownList ID="cboProducto" runat="server" CssClass="form-select" AutoPostBack="True" OnSelectedIndexChanged="cboProducto_SelectedIndexChanged" />
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-6">
                                        <label class="form-label">Precio:</label>
                                        <div class="input-group">
                                            <span class="input-group-text">S/.</span>
                                            <asp:Label ID="lblPrecioUnitario" runat="server" CssClass="form-control bg-white" Text="0.00" />
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label">Stock:</label>
                                        <asp:Label ID="lblStock" runat="server" CssClass="form-control bg-light" Text="0" />
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Cantidad:</label>
                                    <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" TextMode="Number" Text="1" min="1" />
                                    <asp:RangeValidator ID="valCantidad" runat="server" ControlToValidate="txtCantidad" Type="Integer" MinimumValue="1" MaximumValue="999" ErrorMessage="Cantidad inválida" ForeColor="Red" Display="Dynamic" />
                                </div>

                                <div class="d-grid">
                                    <asp:Button ID="btnAgregar" runat="server" Text="➕ Agregar al Carrito" OnClick="btnAgregar_Click" CssClass="btn btn-success btn-lg" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-7">
                        <div class="card shadow-sm border-0 h-100">
                            <div class="card-header bg-dark text-white d-flex justify-content-between">
                                <h5 class="mb-0"><i class="fa-solid fa-basket-shopping"></i> Carrito de Compras</h5>
                                <span class="badge bg-warning text-dark">En proceso</span>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvDetalle" runat="server" AutoGenerateColumns="False" 
                                        CssClass="table table-striped table-hover mb-0 align-middle" GridLines="None" 
                                        EmptyDataText="El carrito está vacío.">
                                        <HeaderStyle CssClass="table-light fw-bold" />
                                        <Columns>
                                            <asp:BoundField DataField="NombreProducto" HeaderText="Producto" />
                                            <asp:BoundField DataField="Cantidad" HeaderText="Cant" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                                            <asp:BoundField DataField="PrecioUnitario" HeaderText="P. Unit" DataFormatString="{0:C2}" ItemStyle-CssClass="text-end" HeaderStyle-CssClass="text-end" />
                                            <asp:BoundField DataField="SubtotalLinea" HeaderText="Subtotal" DataFormatString="{0:C2}" ItemStyle-CssClass="text-end fw-bold" HeaderStyle-CssClass="text-end" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                            
                            <div class="card-footer bg-white">
                                <div class="row text-end">
                                    <div class="col-12">
                                        <p class="mb-1">Subtotal: <strong><asp:Label ID="lblSubtotal" runat="server" Text="S/. 0.00" /></strong></p>
                                        <p class="mb-1">IGV (18%): <strong><asp:Label ID="lblImpuesto" runat="server" Text="S/. 0.00" /></strong></p>
                                        <h3 class="text-success fw-bold">Total: <asp:Label ID="lblTotal" runat="server" Text="S/. 0.00" /></h3>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end gap-2 mt-3">
                                    <asp:Button ID="btnCancelar" runat="server" Text="Limpiar" OnClick="btnCancelar_Click" CssClass="btn btn-outline-secondary" />
                                    <asp:Button ID="btnGuardarOrden" runat="server" Text="✅ Finalizar Compra" OnClick="btnGuardarOrden_Click" CssClass="btn btn-primary btn-lg px-4" ValidationGroup="Orden" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>