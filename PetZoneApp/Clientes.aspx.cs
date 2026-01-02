using PetZoneApp.Models;
using PetZoneWeb;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PetZoneApp
{
    public partial class Clientes : Page
    {
        private int ClienteSeleccionadoId
        {
            get { return ViewState["ClienteId"] == null ? 0 : (int)ViewState["ClienteId"]; }
            set { ViewState["ClienteId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) CargarClientes();
        }

        private void CargarClientes()
        {
            using (var db = new PetZoneEntities())
            {
                gvClientes.DataSource = db.Clientes.ToList();
                gvClientes.DataBind();
            }
            btnEliminar.Enabled = ClienteSeleccionadoId > 0;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            using (var db = new PetZoneApp.Models.PetZoneEntities())
            {
                if (ClienteSeleccionadoId == 0)
                {
                    var nuevo = new PetZoneApp.Models.Clientes
                    {
                        Nombre = txtNombre.Text,
                        Documento = txtDocumento.Text,
                        Email = txtEmail.Text,
                        Telefono = txtTelefono.Text,
                        Direccion = txtDireccion.Text,
                        FechaRegistro = DateTime.Now
                    };
                    db.Clientes.Add(nuevo);
                }
                else
                {
                    var cliente = db.Clientes.Find(ClienteSeleccionadoId);
                    if (cliente != null)
                    {
                        cliente.Nombre = txtNombre.Text;
                        cliente.Documento = txtDocumento.Text;
                        cliente.Email = txtEmail.Text;
                        cliente.Telefono = txtTelefono.Text;
                        cliente.Direccion = txtDireccion.Text;
                    }
                }
                db.SaveChanges();
            }
            btnLimpiar_Click(sender, e);
            CargarClientes();
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            if (ClienteSeleccionadoId > 0)
            {
                using (var db = new PetZoneEntities())
                {
                    var cliente = db.Clientes.Find(ClienteSeleccionadoId);
                    if (cliente != null)
                    {
                        db.Clientes.Remove(cliente);
                        db.SaveChanges();
                    }
                }
                btnLimpiar_Click(sender, e);
                CargarClientes();
            }
        }

        protected void gvClientes_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(gvClientes.SelectedDataKey.Value);
            using (var db = new PetZoneApp.Models.PetZoneEntities())
            {
                var cliente = db.Clientes.Find(id);
                if (cliente != null)
                {
                    ClienteSeleccionadoId = cliente.ClienteId;
                    txtNombre.Text = cliente.Nombre;
                    txtDocumento.Text = cliente.Documento;
                    txtEmail.Text = cliente.Email;

                    txtTelefono.Text = cliente.Telefono;
                    txtDireccion.Text = cliente.Direccion;

                    btnEliminar.Enabled = true;
                }
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            ClienteSeleccionadoId = 0;
            txtNombre.Text = "";
            txtDocumento.Text = "";
            txtEmail.Text = "";
            txtTelefono.Text = "";
            txtDireccion.Text = "";
            btnEliminar.Enabled = false;
        }

        protected void gvClientes_RowCommand(object sender, GridViewCommandEventArgs e) { }
    }
}