@extends('adminlte::page')

@section('title', 'Políticas de Privacidad')

@section('content_header')

<h1 style="text-align: center;">Políticas de Privacidad</h1>
    

@stop

@section('content')


<div class="card" style="overflow-y: auto; max-height: 585px;"> <!-- Ajusta max-height según sea necesario -->
    <div class="card-body">
    
        <h2>Introducción</h2>
        <p>En esta página se describen nuestras políticas sobre la recopilación, uso y divulgación de información cuando utilizas nuestro servicio.</p>

        <h2>Recopilación de Información</h2>
        <p>Recopilamos varios tipos de información para diversos fines, con el fin de ofrecer nuestro servicio.</p>

        <h2>Uso de la Información</h2>
        <p>Utilizamos la información que recopilamos para diversos fines, incluyendo:</p>
        <ul>
            <li>Proveer y mantener nuestro servicio</li>
            <li>Notificarte sobre cambios en nuestro servicio</li>
            <li>Permitir la participación en características interactivas de nuestro servicio</li>
            <li>Proveer soporte al cliente</li>
            <li>Recopilar análisis o información valiosa para mejorar nuestro servicio</li>
            <li>Monitorear el uso de nuestro servicio</li>
            <li>Detectar, prevenir y abordar problemas técnicos</li>
        </ul>

        <h2>Divulgación de la Información</h2>
        <p>Podemos divulgar información personal que recopilamos, o que proporcionas:</p>
        <ul>
            <li>Para cumplir con una obligación legal</li>
            <li>Para proteger y defender nuestros derechos o propiedad</li>
            <li>Para prevenir o investigar posibles irregularidades en relación con el servicio</li>
            <li>Para proteger la seguridad personal de los usuarios del servicio o del público</li>
            <li>Para protegerse contra la responsabilidad legal</li>
        </ul>

        <h2>Seguridad de la Información</h2>
        <p>La seguridad de tu información es importante para nosotros, pero recuerda que ningún método de transmisión a través de Internet, o método de almacenamiento electrónico, es 100% seguro. Si bien nos esforzamos por utilizar medios comercialmente aceptables para proteger tu información personal, no podemos garantizar su seguridad absoluta.</p>

        <h2>Cambios a esta Política de Privacidad</h2>
        <p>Podemos actualizar nuestra Política de Privacidad de vez en cuando. Te notificaremos sobre cualquier cambio publicando la nueva Política de Privacidad en esta página. Te aconsejamos que revises esta Política de Privacidad periódicamente para cualquier cambio. Los cambios a esta Política de Privacidad son efectivos cuando se publican en esta página.</p>

        <h2>Contacto</h2>
        <p>Si tienes alguna pregunta sobre esta Política de Privacidad, contáctanos:</p>
        <ul class="contact-info">
            <li>Por correo electrónico: cliniccontrol@gmail.com</li>
            <li>Por teléfono: +123 456 7890</li>
        </ul>
    </div>
</div>

@stop

@section('css')
<style>
    body {
        background-color: #f9f9f9; /* Fondo suave */
        font-family: 'Arial', sans-serif; /* Tipografía legible */
        color: #333; /* Color del texto */
    }

    .card {
        border-radius: 12px; /* Esquinas redondeadas */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Sombra suave */
        margin: 20px auto; /* Margen superior e inferior */
        max-width: 800px; /* Ancho máximo */
    }

    .card-body {
        padding: 20px; /* Espaciado interno */
        background-color: #ffffff; /* Fondo blanco para el contenido */
    }

    h1, h2 {
        color: #1338BE; /* Color verde para los encabezados */
        margin-bottom: 15px; /* Espacio inferior */
    }

    p {
        line-height: 1.6; /* Espaciado entre líneas */
        margin-bottom: 10px; /* Espacio inferior */
    }

    ul {
        margin-left: 20px; /* Margen a la izquierda para listas */
        margin-bottom: 10px; /* Espacio inferior */
    }

    ul li {
        margin-bottom: 5px; /* Espacio entre elementos de la lista */
        position: relative; /* Para poder agregar un icono antes */
    }

    /* ul li::before {
        content: '•'; /* Punto antes de cada elemento de la lista */
        color: #1338BE; /* Color verde */
        position: absolute; /* Posicionamiento absoluto */
        left: -15px; /* Espacio a la izquierda */
    } */

    .contact-info {
        margin-top: 20px; /* Margen superior para la sección de contacto */
    }

    .contact-info li {
        margin-bottom: 5px; /* Espacio entre los elementos de contacto */
    }

</style>
@stop

