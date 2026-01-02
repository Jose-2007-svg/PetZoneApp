using PetZoneApp.Models;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PetZoneApp
{
    public partial class Productos : Page
    {
        private int ProductoSeleccionadoId
        {
            get { return ViewState["ProductoId"] == null ? 0 : (int)ViewState["ProductoId"]; }
            set { ViewState["ProductoId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) CargarProductos();
        }

        private void CargarProductos()
        {
            using (var db = new PetZoneEntities())
            {
                gvProductos.DataSource = db.Productos.ToList();
                gvProductos.DataBind();
            }
            btnEliminar.Enabled = ProductoSeleccionadoId > 0;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            decimal precio = Convert.ToDecimal(txtPrecio.Text);
            int stock = Convert.ToInt32(txtStock.Text);

            using (var db = new PetZoneEntities())
            {
                if (ProductoSeleccionadoId == 0)
                {
                    var nuevo = new PetZoneApp.Models.Productos
                    {
                        Nombre = txtNombre.Text,
                        CategoriaId = 1,
                        Precio = precio,
                        Stock = stock,
                        Activo = true,
                        FechaCreacion = DateTime.Now
                    };
                    db.Productos.Add(nuevo);
                }
                else
                {
                    var prod = db.Productos.Find(ProductoSeleccionadoId);
                    if (prod != null)
                    {
                        prod.Nombre = txtNombre.Text;
                        prod.Precio = precio;
                        prod.Stock = stock;
                    }
                }
                db.SaveChanges();
            }
            btnLimpiar_Click(sender, e);
            CargarProductos();
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            if (ProductoSeleccionadoId > 0)
            {
                using (var db = new PetZoneEntities())
                {
                    var prod = db.Productos.Find(ProductoSeleccionadoId);
                    if (prod != null)
                    {
                        db.Productos.Remove(prod);
                        db.SaveChanges();
                    }
                }
                btnLimpiar_Click(sender, e);
                CargarProductos();
            }
        }

        protected void gvProductos_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(gvProductos.SelectedDataKey.Value);
            using (var db = new PetZoneEntities())
            {
                var prod = db.Productos.Find(id);
                if (prod != null)
                {
                    ProductoSeleccionadoId = prod.ProductoId;
                    txtNombre.Text = prod.Nombre;
                    txtPrecio.Text = prod.Precio.ToString("N2");
                    txtStock.Text = prod.Stock.ToString();
                    btnEliminar.Enabled = true;
                }
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            ProductoSeleccionadoId = 0;
            txtNombre.Text = "";
            txtPrecio.Text = "";
            txtStock.Text = "";
            btnEliminar.Enabled = false;
        }
    }
}