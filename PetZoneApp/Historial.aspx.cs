using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using PetZoneApp.Models;

namespace PetZoneApp
{
    public partial class Historial : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarOrdenes();
            }
        }

        private void CargarOrdenes()
        {
            using (var db = new PetZoneEntities())
            {
                // Traemos las órdenes incluyendo el nombre del cliente
                var lista = db.Ordenes
                              .OrderByDescending(o => o.Fecha)
                              .Select(o => new
                              {
                                  o.OrdenId,
                                  o.Fecha,
                                  Cliente = o.Clientes.Nombre,
                                  o.Total
                              }).ToList();

                gvOrdenes.DataSource = lista;
                gvOrdenes.DataBind();
            }
        }

        protected void gvOrdenes_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Obtener el ID de la orden seleccionada
            int ordenId = Convert.ToInt32(gvOrdenes.SelectedDataKey.Value);
            lblOrdenSeleccionada.Text = ordenId.ToString();

            using (var db = new PetZoneEntities())
            {
                // Buscar los productos de esa orden específica
                var detalles = db.OrdenDetalle // Asegúrate que sea singular o plural según tu BD (OrdenDetalle o OrdenDetalles)
                                 .Where(d => d.OrdenId == ordenId)
                                 .Select(d => new
                                 {
                                     Producto = d.Productos.Nombre,
                                     d.Cantidad,
                                     d.PrecioUnitario,
                                     Subtotal = d.Cantidad * d.PrecioUnitario
                                 }).ToList();

                gvDetalle.DataSource = detalles;
                gvDetalle.DataBind();

                // Mostrar la tabla y ocultar el mensaje de "Seleccione..."
                gvDetalle.Visible = true;
                lblMensajeDetalle.Visible = false;
            }
        }

        protected void gvOrdenes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrdenes.PageIndex = e.NewPageIndex;
            CargarOrdenes();
        }
    }
}