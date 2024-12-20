@extends('adminlte::page')

@section('title', isset($consultorio['id']) ? 'Editar Consultorio' : 'Agregar Consultorio')

@section('content_header')
    <link href="{{ asset('ClinicControlIcono.png') }}" type="image/x-icon" rel="shortcut icon" />
@stop

@section('content')

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="text-center mb-3">
                <img src="{{ asset('ClinicControlIcono.png') }}" alt="Logo" class="img-fluid" style="max-width: 90px; height: auto;">
            </div>

            <div style="background-color:#1338BE; color:#fff" class="bg text-white p-3 mb-3 rounded-top">
                <h2 class="text-center">{{ isset($consultorio['id']) ? 'Editar Consultorio' : 'Agregar Consultorio' }}</h2>
            </div>

            <div style="
                    background-color: #fff; /* Color de fondo blanco */
                    border-radius: 10px; /* Bordes redondeados */
                    border: #1338BE; /* Borde de 2px, sólido y negro */
                    padding: 20px; /* Espacio interior de 20px */
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Sombra para profundidad */
                    margin: 10px; /* Margen exterior de 10px */
                  
                ">
                <form style="padding-left: 10%; height: 90%; width: 90%; border-radius:15px;" class="formulario-aceptar" action="{{ route('consultorio.guardar') }}" method="POST">
                    @csrf
                    <input type="hidden" name="id" value="{{ isset($consultorio['id']) ? $consultorio['id'] : 0 }}">

                    <div class="form-group row">
                        <label for="numero" class="col-sm-3 col-form-label">Número:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control input-animation" name="numero" style="height:38px; width:280px; border-radius:10px;" value="{{ $consultorio['numero'] ?? old('numero') }}" required>
                        </div>
                    </div>
                    
                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="edificio">Edificio:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control input-animation" style="height:38px; width:280px; border-radius:10px;" name="edificio" value="{{ $consultorio['edificio'] ?? old('edificio') }}" required>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-sm-3 col-form-label" for="nivel">Nivel:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control input-animation" name="nivel" style="height:38px; width:280px; border-radius:10px;" value="{{ $consultorio['nivel'] ?? old('nivel') }}" required>
                        </div>
                    </div>
                    
                    <div>
                        <br>
                        <div class="text-center">
                            <button id="saberBtn" class="btn" style="background-color:#1338BE; color:#fff; border-radius: 15px">
                                {{ isset($consultorio['id']) ? 'Actualizar' : 'Aceptar' }}
                            </button>
                        </div>
                        <br>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

@endsection

@section('js')
<script>
    // Puedes agregar aquí lógica adicional con JavaScript si lo necesitas.
</script>
@endsection

