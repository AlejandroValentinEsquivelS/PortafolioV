<!DOCTYPE html> 
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Consultorio Dental Clinic Control</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('https://www.dentaldelaware.com/wp-content/uploads/2022/08/often-dentist.png'); /* Imagen de fondo */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: #333; /* Color de texto */
        }

        h1, h2, h3 {
            color: #2c3e50; /* Color de encabezados */
        }

        .overlay {
            background-color: rgba(255, 255, 255, 0.9); /* Fondo semitransparente */
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .container {
            max-width: 1000px; /* Ancho máximo del contenido */
            margin: 50px auto; /* Espaciado superior e inferior */
            padding: 20px;
            background: rgba(255, 255, 255, 0.85); /* Fondo semitransparente */
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Sombra suave */
            text-align: center;
        }

        a {
            color: #17a2b8; /* Color de los enlaces */
            text-decoration: none; /* Sin subrayado */
        }

        a:hover {
            text-decoration: underline; /* Subrayado al pasar el ratón */
        }

        .button {
            display: inline-block;
            padding: 12px 24px;
            color: white;
            background-color: #17a2b8; /* Color del botón verde */
            border: none;
            border-radius: 5px; /* Bordes redondeados */
            cursor: pointer;
            transition: background-color 0.3s;
            margin: 5px;
        }

        .button:hover {
            background-color: #138496; /* Color del botón al pasar el ratón */
        }

        .offer {
            background-color: #17a2b8;
            color: white;
            padding: 10px;
            text-align: center;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        footer {
            text-align: center;
            margin-top: 20px;
            font-size: 0.875rem; /* Tamaño de fuente más pequeño */
            color: #777;
        }

        .header {
            background-color: #17a2b8; /* Color del fondo del header */
            color: white;
            padding: 20px;
        }

        .contact-info {
            text-align: center;
            margin: 20px 0;
        }

        .contact-info a {
            color: #17a2b8;
            font-size: 1.2rem;
            display: inline-block;
            margin: 0 10px;
        }

        /* Añadimos estilo a la cabecera */
        .header h1 {
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Consultorio Dental Clinic Control</h1>
        <p>La mejor atención para tu salud dental</p>
    </div>

    <div class="container overlay">
        <div class="offer">
            <strong>Oferta:</strong> 10% de descuento en tu primera visita
        </div>

        <h2>Bienvenido a Clinic Control</h2>
        
        <div class="actions">
            <a href="/login" class="button">Iniciar Sesión</a>
            <a href="/register" class="button">Registrarse</a>
        </div>

        <div class="contact-info">
            <p>Contáctanos: <a href="tel:+5555320364">55 2020 0364</a> o <a href="mailto:cliniccontrol@gmail.com">cliniccontrol@gmail.com</a></p>
        </div>
    </div>
    
    <footer>
        &copy; 2024 Consultorio Dental Clinic Control. Todos los derechos reservados.
    </footer>
</body>
</html>
