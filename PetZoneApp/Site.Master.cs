using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PetZoneWeb  // <--- Verifica que este nombre sea igual al del error
{
    // Verifica el : System.Web.UI.MasterPage
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // SEGURIDAD: Si no hay usuario en sesión, lo botamos al Login
            // (Excluimos la propia página de Login para evitar bucle infinito, aunque la Master no se usa en Login)
            if (Session["UsuarioLogueado"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            else
            {
                // Si está logueado, mostramos su nombre
                var usuario = (PetZoneApp.Models.Usuarios)Session["UsuarioLogueado"];
                lblUsuario.Text = $"Hola, {usuario.Nombre}";
            }
        }

        protected void btnSalir_Click(object sender, EventArgs e)
        {
            // Cerrar Sesión
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}