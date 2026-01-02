using PetZoneApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PetZoneApp
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UsuarioLogueado"] != null)
            {
                Response.Redirect("Default.aspx");
            }
        }

        protected void btnIngresar_Click(object sender, EventArgs e)
        {
            //Capturamos lo que escribió el usuario en las cajas de texto
            string user = txtUsuario.Text.Trim();
            string pass = txtPassword.Text.Trim();

            using (var db = new PetZoneEntities())
            {
                //Consultamos si existe el usuario y contraseña
                var usuario = db.Usuarios
                    .FirstOrDefault(u => u.Username == user && u.Password == pass && u.Activo == true);

                if (usuario != null)
                {

                    // Guardamos al usuario en la memoria
                    Session["UsuarioLogueado"] = usuario;

                    Response.Redirect("Clientes.aspx");
                }
                else
                {
                    lblMensaje.Text = "Usuario o contraseña incorrectos.";
                    lblMensaje.Visible = true;
                }
            }
        }
    }
}