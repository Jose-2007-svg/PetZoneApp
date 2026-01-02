using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using PetZoneApp.Models;

namespace PetZoneApp
{
    [Serializable]
    public class ItemCarrito
    {
        public int ProductoId { get; set; }
        public string NombreProducto { get; set; }
        public int Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }

        // CORRECCIÓN ERROR 2: La propiedad debe llamarse 'SubtotalLinea' para coincidir con tu HTML
        public decimal SubtotalLinea => Cantidad * PrecioUnitario;
    }

    public partial class Ordenes : Page
    {
        public List<ItemCarrito> CarritoActual
        {
            get
            {
                if (Session["Carrito"] == null) Session["Carrito"] = new List<ItemCarrito>();
                return (List<ItemCarrito>)Session["Carrito"];
            }
            set { Session["Carrito"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCombos();
                lblFecha.Text = DateTime.Now.ToShortDateString();
            }
            // Recargamos la grilla en cada postback para no perder los datos visuales
            CargarGrillaCarrito();
        }

        private void CargarGrillaCarrito()
        {
            gvDetalle.DataSource = CarritoActual;
            gvDetalle.DataBind();

            // Calculamos totales
            decimal subtotal = CarritoActual.Sum(x => x.SubtotalLinea);
            decimal igv = subtotal * 0.18m;
            decimal total = subtotal + igv;

            // Mostramos en pantalla con formato de Moneda (S/.)
            lblSubtotal.Text = subtotal.ToString("C2");
            lblImpuesto.Text = igv.ToString("C2");
            lblTotal.Text = total.ToString("C2");
        }

        private void CargarCombos()
        {
            using (var db = new PetZoneEntities())
            {
                cboCliente.DataSource = db.Clientes.Select(c => new { c.ClienteId, c.Nombre }).ToList();
                cboCliente.DataTextField = "Nombre";
                cboCliente.DataValueField = "ClienteId";
                cboCliente.DataBind();
                cboCliente.Items.Insert(0, new ListItem("--- Seleccione Cliente ---", "0"));

                cboProducto.DataSource = db.Productos
                                        .Where(p => p.Stock > 0)
                                        .Select(p => new { p.ProductoId, p.Nombre })
                                        .ToList();
                cboProducto.DataTextField = "Nombre";
                cboProducto.DataValueField = "ProductoId";
                cboProducto.DataBind();
                cboProducto.Items.Insert(0, new ListItem("--- Seleccione Producto ---", "0"));
            }
        }

        protected void cboProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            int prodId = int.Parse(cboProducto.SelectedValue);
            if (prodId > 0)
            {
                using (var db = new PetZoneEntities())
                {
                    var p = db.Productos.Find(prodId);
                    if (p != null)
                    {
                        lblPrecioUnitario.Text = p.Precio.ToString("N2");
                        lblStock.Text = p.Stock.ToString();
                    }
                }
            }
            else
            {
                lblPrecioUnitario.Text = "0.00";
                lblStock.Text = "0";
            }
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            if (cboProducto.SelectedValue == "0") return;

            int prodId = int.Parse(cboProducto.SelectedValue);
            int cantidad = int.Parse(txtCantidad.Text);

            // Leemos el precio sin formato para evitar errores
            decimal precio = decimal.Parse(lblPrecioUnitario.Text);
            int stock = int.Parse(lblStock.Text);

            if (cantidad > stock)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('No hay suficiente stock.');", true);
                return;
            }

            var item = CarritoActual.FirstOrDefault(x => x.ProductoId == prodId);
            if (item != null)
            {
                item.Cantidad += cantidad;
            }
            else
            {
                CarritoActual.Add(new ItemCarrito
                {
                    ProductoId = prodId,
                    NombreProducto = cboProducto.SelectedItem.Text,
                    Cantidad = cantidad,
                    PrecioUnitario = precio
                });
            }
            CargarGrillaCarrito();
        }

        protected void btnGuardarOrden_Click(object sender, EventArgs e)
        {
            if (cboCliente.SelectedValue == "0" || !CarritoActual.Any()) return;

           
            // NO leemos lblTotal.Text porque tiene letras "S/." y da error.
            decimal totalCalculado = CarritoActual.Sum(x => x.SubtotalLinea) * 1.18m;

            using (var db = new PetZoneEntities())
            {
                using (var transaction = db.Database.BeginTransaction())
                {
                    try
                    {
                        // 1. Guardar Cabecera
                        var orden = new PetZoneApp.Models.Ordenes
                        {
                            ClienteId = int.Parse(cboCliente.SelectedValue),
                            Fecha = DateTime.Now,
                            Total = totalCalculado, // Usamos el valor limpio, no el Label
                            Estado = "Completada"
                        };
                        db.Ordenes.Add(orden);
                        db.SaveChanges();

                        // 2. Guardar Detalle
                        foreach (var item in CarritoActual)
                        {
                            var detalle = new PetZoneApp.Models.OrdenDetalle
                            {
                                OrdenId = orden.OrdenId,
                                ProductoId = item.ProductoId,
                                Cantidad = item.Cantidad,
                                PrecioUnitario = item.PrecioUnitario
                            };
                            db.OrdenDetalle.Add(detalle);

                            // Descontar Stock
                            var prodDB = db.Productos.Find(item.ProductoId);
                            prodDB.Stock -= item.Cantidad;
                        }

                        db.SaveChanges();
                        transaction.Commit();

                        CarritoActual.Clear();
                        CargarGrillaCarrito();
                        ScriptManager.RegisterStartupScript(this, GetType(), "ok", "alert('Orden registrada con éxito.');", true);
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        ScriptManager.RegisterStartupScript(this, GetType(), "error", $"alert('Error: {ex.Message}');", true);
                    }
                }
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            CarritoActual.Clear();
            CargarGrillaCarrito();
        }

        protected void cboCliente_SelectedIndexChanged(object sender, EventArgs e) { }
    }
}