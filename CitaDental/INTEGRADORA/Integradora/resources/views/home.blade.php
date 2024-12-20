@extends('adminlte::page')

@section('title')
    {{ config('adminlte.title') }}
    @hasSection('subtitle') | @yield('subtitle') @endif
@stop

@section('content_header')
    @hasSection('content_header_title')
        <h1 class="text-muted">
            @yield('content_header_title')

            @hasSection('content_header_subtitle')
                <small class="text-dark">
                    <i class="fas fa-xs fa-angle-right text-muted"></i>
                    @yield('content_header_subtitle')
                </small>
            @endif
        </h1>
        <div class="text-center mb-3">
            <img src="{{ asset('ClinicControlIcono.png') }}" alt="Logo" class="img-fluid" style="max-width: 90px; height: auto;">
        </div>
    @endif
@stop

@section('content')
    <div class="text-center mb-4">
        <h2 style="color: #1338BE;">Bienvenido a Clinic Control</h2>
        <p class="lead">Su salud dental es nuestra prioridad.</p>
        <!-- <a href="{{ url('appointments') }}" class="btn btn-primary btn-lg">Agendar Cita</a> -->
    </div>
    
    <div class="row">
        <div class="col-md-4">
            <div class="card" style="
                    background-color: #fff; /* Color de fondo blanco */
                    border-radius: 10px; /* Bordes redondeados */
                    border: #1338BE; /* Borde de 2px, sólido y negro */
                    padding: 20px; /* Espacio interior de 20px */
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra para profundidad */
                    margin: 10px; /* Margen exterior de 10px */
                     ">
                <div class="card-header" style="
                    background-color: #1338BE; /* Color de fondo blanco */
                    border-radius: 10px; /* Bordes redondeados */
                    border: #1338BE; /* Borde de 2px, sólido y negro */
                    padding: 20px; /* Espacio interior de 20px */
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra para profundidad */
                    margin: 10px; /* Margen exterior de 10px */
                     ">
                    <h3 class="card-title" style="color: white;">Nuestros Servicios</h3>
                    
                </div>
                <div class="card-body" >
                    <ul>
                    @foreach($especialidades as $especialidad)
                        <li>{{ $especialidad['data']['nombre'] }}</li>
                    @endforeach
                       
                    </ul>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card" style="
                    background-color: #fff; /* Color de fondo blanco */
                    border-radius: 10px; /* Bordes redondeados */
                    border: #1338BE; /* Borde de 2px, sólido y negro */
                    padding: 20px; /* Espacio interior de 20px */
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra para profundidad */
                    margin: 10px; /* Margen exterior de 10px */
                     ">
                <div class="card-header"
                style="
                    background-color: #1338BE; /* Color de fondo blanco */
                    border-radius: 10px; /* Bordes redondeados */
                    border: #1338BE; /* Borde de 2px, sólido y negro */
                    padding: 20px; /* Espacio interior de 20px */
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra para profundidad */
                    margin: 10px; /* Margen exterior de 10px */
                     ">
                    <h3 class="card-title" style="color: #fff;">Consejos de Salud Dental</h3>
                </div>
                <div class="card-body">
                    <p>Mantenga una buena higiene dental cepillándose los dientes al menos dos veces al día.</p>
                    <p>Visite a su dentista regularmente para chequeos.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card" style="
                    background-color: #fff; /* Color de fondo blanco */
                    border-radius: 10px; /* Bordes redondeados */
                    border: #1338BE; /* Borde de 2px, sólido y negro */
                    padding: 20px; /* Espacio interior de 20px */
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra para profundidad */
                    margin: 10px; /* Margen exterior de 10px */
                     ">
                <div class="card-header" style="
                    background-color: #1338BE; /* Color de fondo blanco */
                    border-radius: 10px; /* Bordes redondeados */
                    border: #1338BE; /* Borde de 2px, sólido y negro */
                    padding: 20px; /* Espacio interior de 20px */
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra para profundidad */
                    margin: 10px; /* Margen exterior de 10px */
                     ">
                    <h3 class="card-title" style="color: white;">Contáctenos</h3>
                </div>
                <div class="card-body">
                    <p>Teléfono: (123) 456-7890</p>
                    <p>Email: cliniccontrol@consultorioclinic.com</p>
                    <p>Dirección: UTTEC , Estado de Mexico</p>
                </div>
            </div>
        </div>
    </div>
@stop

@section('footer')
    <div class="float-right">
        Versión: {{ config('app.version', '1.0.0') }}
    </div>

    <strong>
        <a href="{{ config('app.company_url', '#') }}">
            {{ config('app.company_name', 'Consultorio Dental') }}
        </a>
    </strong>
@stop

@push('js')
<script>
    $(document).ready(function() {
        // Agrega tu lógica de script común aquí...
    });
</script>
@endpush

@push('css')
<style type="text/css">
    /* Personalizaciones CSS */
    body {
        background-color: #f8f9fa; /* Fondo suave */
    }

    .content-header {
        border-bottom: 1px solid #dee2e6; /* Línea separadora */
        padding-bottom: 20px;
    }

    h1.text-muted {
        font-size: 2rem; /* Tamaño de fuente más grande */
        margin-bottom: 10px;
    }

    small.text-dark {
        font-size: 1rem; /* Tamaño de fuente para subtítulo */
    }

    .float-right {
        font-size: 0.9rem; /* Tamaño de fuente para la versión */
    }

    a {
        color: #007bff; /* Color del enlace */
    }

    a:hover {
        text-decoration: underline; /* Subrayado en hover */
    }

    /* Estilos adicionales */
    .card {
        border: none; /* Sin bordes en tarjetas */
    }

    .card-header {
        background-color: #e9ecef; /* Fondo del encabezado de la tarjeta */
    }

    .card-title {
        font-weight: 600;
    }

    .btn-primary {
        background-color: #0056b3; /* Color del botón */
        border-color: #0056b3; /* Color del borde del botón */
    }

    .btn-primary:hover {
        background-color: #004085; /* Color del botón en hover */
        border-color: #004085; /* Color del borde en hover */
    }
</style>
@endpush
