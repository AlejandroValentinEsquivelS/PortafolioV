@extends('adminlte::page')

@section('title', 'Agregar Servicio')

@section('content_header')
<link href="http://mx.geocities.com/mipagina/favicon.ico" type="image/x-icon" rel="shortcut icon" />
@stop

@section('content')

<div class="container mt-5">
    <center>
        <div class="text-center mb-3">
            <img src="{{ asset('ClinicControlIcono.png') }}" alt="Logo" class="img-fluid" style="max-width: 90px; height: auto;">
        </div>
    </center>

    <div class="row justify-content-center" >
        <div class="col-md-5" >
            <div style="background-color:#1338BE; color:#fff; "  class="bg text-white p-3 mb-3 rounded-top">
                <h2 class="text-center">Agregar Sservicios</h2>
            </div>
            
            <div style="
                    background-color: #fff; /* Color de fondo blanco */
                    border-radius: 10px; /* Bordes redondeados */
                    border: #1338BE; /* Borde de 2px, sólido y negro */
                    padding: 20px; /* Espacio interior de 20px */
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra para profundidad */
                    margin: 10px; /* Margen exterior de 10px */
                    
                ">

                @if(session('success'))
                    <div class="alert alert-success">{{ session('success') }}</div>
                @endif

                @if($errors->any())
                    <div class="alert alert-danger">
                        <ul>
                            @foreach($errors->all() as $error)
                                <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                    </div>
                @endif

                <form action="{{ route('especialidad.store', isset($especialidad['id']) ? $especialidad['id'] : '') }}" method="POST" style="border-radius: 15px;">
    @csrf
    <center>
    <div class="form-group">
        <label for="nombre">Nombre del servicio:</label>
        <input type="text" name="nombre" class="form-control" id="nombre" placeholder="especialidad" style="height:38px; width:350px; border-radius:10px;" value="{{ $especialidad['nombre'] ?? '' }}" required>
    </div>
    </center>

    <!-- Verificar si el ID existe (si estamos en modo edición) -->
    @if(!empty($especialidad['id']))
        <input type="hidden" name="id" value="{{ $especialidad['id'] }}">
    @endif
    <center>

    <!-- Cambiar el texto del botón según si es creación o edición -->
    <button type="submit" class="btn btn-primary" style="background-color:#1338BE; color:#fff; border-radius: 15px">
        {{ isset($especialidad['id']) ? 'Editar Servicio' : 'Crear Servicio' }}
    </button>
    </center>
</form>


            </div>
        </div>
    </div>
</div>

@endsection

@section('js')
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
@stop
