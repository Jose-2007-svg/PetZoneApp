using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PetZoneApp.Models; // Importante para conectar con la BD

namespace PetZoneApp
{
    public partial class Usuarios : Page
    {
        // Propiedad para recordar qué usuario estamos editando (si es 0, es nuevo)
        private int UsuarioSeleccionadoId
        {
            get { return ViewState["UsuarioId"] == null ? 0 : (int)ViewState["UsuarioId"]; }
            set { ViewState["UsuarioId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarRoles();
                CargarUsuarios();
            }
        }

        private void CargarRoles()
        {
            // Llenamos el combo manualmente con los roles permitidos
            var roles = new List<string> { "Administrador", "Vendedor", "Almacén" };
            cboRol.DataSource = roles;
            cboRol.DataBind();
            cboRol.Items.Insert(0, new ListItem("--- Seleccione Rol ---", "0"));
        }

        private void CargarUsuarios()
        {
            using (var db = new PetZoneEntities())
            {
                // Traemos la lista actualizada desde SQL Server
                gvUsuarios.DataSource = db.Usuarios.ToList();
                gvUsuarios.DataBind();
            }
            // Solo habilitamos el botón eliminar si se seleccionó a alguien
            btnEliminar.Enabled = UsuarioSeleccionadoId > 0;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // 1. Validaciones básicas
            if (!Page.IsValid || cboRol.SelectedValue == "0")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Complete todos los campos y seleccione un rol.');", true);
                return;
            }

            using (var db = new PetZoneEntities())
            {
                // CASO A: CREAR NUEVO USUARIO (INSERT)
                if (UsuarioSeleccionadoId == 0)
                {
                    var nuevoUsuario = new PetZoneApp.Models.Usuarios();

                    nuevoUsuario.Username = txtUsuario.Text;
                    nuevoUsuario.Password = txtContrasena.Text; // Guardamos la contraseña
                    nuevoUsuario.Nombre = txtUsuario.Text; // TRUCO: Repetimos el usuario en el nombre para cumplir con SQL
                    nuevoUsuario.Rol = cboRol.SelectedValue;
                    nuevoUsuario.Activo = chkActivo.Checked;
                    nuevoUsuario.FechaCreacion = DateTime.Now;

                    db.Usuarios.Add(nuevoUsuario); // Agregamos a la tabla
                    ScriptManager.RegisterStartupScript(this, GetType(), "ok", "alert('Usuario registrado exitosamente.');", true);
                }
                // CASO B: EDITAR USUARIO EXISTENTE (UPDATE)
                else
                {
                    var usuarioEditar = db.Usuarios.Find(UsuarioSeleccionadoId);
                    if (usuarioEditar != null)
                    {
                        usuarioEditar.Username = txtUsuario.Text;
                        usuarioEditar.Nombre = txtUsuario.Text;

                        // Solo cambiamos la contraseña si escribió algo nuevo
                        if (!string.IsNullOrEmpty(txtContrasena.Text))
                        {
                            usuarioEditar.Password = txtContrasena.Text;
                        }

                        usuarioEditar.Rol = cboRol.SelectedValue;
                        usuarioEditar.Activo = chkActivo.Checked;
                    }
                    ScriptManager.RegisterStartupScript(this, GetType(), "ok", "alert('Usuario actualizado exitosamente.');", true);
                }

                // 2. GUARDAR CAMBIOS EN LA BASE DE DATOS
                db.SaveChanges();
            }

            // 3. Limpiar y recargar la lista
            btnLimpiar_Click(sender, e);
            CargarUsuarios();
        }

        protected void gvUsuarios_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Cargar los datos de la fila seleccionada a los controles
            int id = Convert.ToInt32(gvUsuarios.SelectedDataKey.Value);
            using (var db = new PetZoneEntities())
            {
                var usuario = db.Usuarios.Find(id);
                if (usuario != null)
                {
                    UsuarioSeleccionadoId = usuario.UsuarioId;
                    txtUsuario.Text = usuario.Username;
                    // No cargamos la contraseña por seguridad
                    txtContrasena.Text = usuario.Password;
                    cboRol.SelectedValue = usuario.Rol;
                    chkActivo.Checked = usuario.Activo;

                    btnEliminar.Enabled = true;
                }
            }
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            if (UsuarioSeleccionadoId > 0)
            {
                using (var db = new PetZoneEntities())
                {
                    var usuario = db.Usuarios.Find(UsuarioSeleccionadoId);
                    if (usuario != null)
                    {
                        db.Usuarios.Remove(usuario);
                        db.SaveChanges();
                        ScriptManager.RegisterStartupScript(this, GetType(), "del", "alert('Usuario eliminado.');", true);
                    }
                }
                btnLimpiar_Click(sender, e);
                CargarUsuarios();
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            UsuarioSeleccionadoId = 0;
            txtUsuario.Text = "";
            txtContrasena.Text = "";
            cboRol.SelectedIndex = 0;
            chkActivo.Checked = true;
            btnEliminar.Enabled = false;
        }
    }
}