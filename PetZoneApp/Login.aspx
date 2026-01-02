<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PetZoneApp.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Iniciar Sesión - PetZone</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            height: 100vh;
            overflow: hidden; /* Evita scroll innecesario */
        }

        /* Lado Izquierdo: Imagen */
        .login-image {
            /* Imagen de un perrito/gatito de alta calidad */
            background-image: url('https://images.unsplash.com/photo-1450778869180-41d0601e046e?q=80&w=1972&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            height: 100vh;
            position: relative;
        }
        
        /* Capa oscura sobre la imagen para que el texto resalte si quisieras poner algo encima */
        .overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, rgba(0,0,0,0.3), rgba(0,0,0,0.1));
        }

        /* Lado Derecho: Formulario */
        .login-section {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-color: #ffffff;
        }

        .login-card {
            width: 100%;
            max-width: 450px;
            padding: 40px;
        }

        .brand-logo {
            color: #0d6efd; /* Azul Bootstrap */
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .btn-login {
            background-color: #0d6efd;
            border: none;
            padding: 12px;
            font-size: 1.1rem;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-login:hover {
            background-color: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
        }

        /* Estilo para los inputs flotantes */
        .form-floating > .form-control:focus {
            box-shadow: none;
            border-color: #0d6efd;
        }
        
        .footer-text {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 30px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container-fluid g-0">
        <div class="row g-0">
            
            <div class="col-lg-7 d-none d-lg-block position-relative login-image">
                <div class="overlay"></div>
                <div class="position-absolute bottom-0 start-0 p-5 text-white">
                    <h2 class="fw-bold">Todo lo que tu mascota necesita.</h2>
                    <p class="lead">Administra tu tienda con eficiencia y amor.</p>
                </div>
            </div>

            <div class="col-lg-5 login-section">
                <form id="form1" runat="server" class="login-card">
                    
                    <div class="text-center mb-5">
                        <div class="brand-logo"><i class="fa-solid fa-paw"></i> PetZone</div>
                        <h4 class="text-secondary">Bienvenido de nuevo</h4>
                        <p class="text-muted">Ingresa tus credenciales para acceder</p>
                    </div>

                    <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-danger d-block text-center border-0 mb-4" Visible="false" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i> Datos incorrectos
                    </asp:Label>

                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control" placeholder="Nombre de usuario" required></asp:TextBox>
                        <label for="txtUsuario"><i class="fa-solid fa-user me-2"></i>Usuario</label>
                    </div>

                    <div class="form-floating mb-4">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Contraseña" required></asp:TextBox>
                        <label for="txtPassword"><i class="fa-solid fa-lock me-2"></i>Contraseña</label>
                    </div>

                    <div class="d-grid mb-4">
                        <asp:Button ID="btnIngresar" runat="server" Text="Iniciar Sesión" OnClick="btnIngresar_Click" CssClass="btn btn-primary btn-login rounded-pill text-white" />
                    </div>

                    <div class="footer-text">
                        <p>© 2025 PetZone S.A.C.<br />Sistema de Gestión Interna</p>
                    </div>

                </form>
            </div>

        </div>
    </div>
</body>
</html>