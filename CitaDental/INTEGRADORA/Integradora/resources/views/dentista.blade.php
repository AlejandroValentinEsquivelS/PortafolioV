@extends('adminlte::page')

@section('title', 'Agregar dentista')

@section('content_header')
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <link href="http://mx.geocities.com/mipagina/favicon.ico" type="image/x-icon" rel="shortcut icon" />
@stop

@section('content')
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div style="background-color:#1338BE; color:#fff" class="bg text-white p-3 mb-3 rounded-top">
                <h2 class="text-center">Datos del Dentista</h2>
            </div>
            
            <div style="background-color: #fff; border-radius: 10px; border: #1338BE; padding: 20px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); margin: 10px; height: 640px;">
                <form style="padding-left: 10%; height: 90%; width: 90%;" action="{{ route('dentista.guardar') }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    <input type="hidden" name="id" value="{{ $dentista['id'] ?? '' }}">
            
                    <center>
                        <!-- Vista previa de la imagen -->
                    <div class="mt-3">
                        <label>Vista previa:</label><br>
                        <img id="imagePreview" 
                             src="{{ isset($dentista['imagen_url']) && $dentista['imagen_url'] ? $dentista['imagen_url'] : 'https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_1280.png' }}" 
                             alt="Imagen del dentista" 
                             style="width: 150px; height: 150px; border-radius: 150px; display: {{ isset($dentista['imagen_url']) && $dentista['imagen_url'] ? 'block' : 'block' }};">
                    </div>
                    </center>
                    
                    <br>
                    <div class="form-group row">
                        <label for="nombre" class="col-sm-3 col-form-label">Nombre:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" style="height:38px; width:280px; border-radius:10px;" name="nombre" value="{{ old('nombre', $dentista['nombre']) }}">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="cedula" class="col-sm-3 col-form-label">Cédula:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" style="height:38px; width:280px; border-radius:10px;" name="cedula" value="{{ old('cedula', $dentista['cedula']) }}">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="telefono" class="col-sm-3 col-form-label">Teléfono:</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" style="height:38px; width:280px; border-radius:10px;" name="telefono" value="{{ old('telefono', $dentista['telefono']) }}">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="correo" class="col-sm-3 col-form-label">Correo:</label>
                        <div class="col-sm-9">
                            <input type="email" class="form-control" style="height:38px; width:280px; border-radius:10px;" name="correo" value="{{ old('correo', $dentista['correo']) }}">
                        </div>
                    </div>
                    
                    <div class="form-group row">
                        <label for="password" class="col-sm-3 col-form-label">Contraseña:</label>
                        <div class="col-sm-9">
                            <div class="input-group" style="width:280px;">
                                <input type="password" class="form-control" id="password" style="height:38px; border-radius:10px;" name="password" value="{{ old('password', $dentista['password']) }}">
                                <div class="input-group-append">
                                    <button type="button" class="btn btn-outline-secondary" onclick="togglePasswordVisibility()" style="height:38px; padding:0 10px; border-radius:0 10px 10px 0;">
                                        <i id="toggleIcon" class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <label for="imagen">Selecciona una imagen:</label>
                    <input type="file" name="imagen" id="imagen" onchange="previewImage(event)">
                    <br><br>

                    

                    <div class="text-center">
                        <button class="btn" style="background-color:#1338BE; color:#fff; border-radius: 15px">Aceptar</button>
                    </div>
                    <br>
                </form>
            </div>
        </div>
    </div>
</div>







@endsection

<script>
    function togglePasswordVisibility() {
        var passwordInput = document.getElementById('password');
        var toggleIcon = document.getElementById('toggleIcon');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }
</script>
<script>
    // Función para mostrar la vista previa de la imagen seleccionada
    function previewImage(event) {
        var reader = new FileReader();
        reader.onload = function() {
            var output = document.getElementById('imagePreview');
            output.src = reader.result;
            output.style.display = 'block'; // Mostrar la imagen
        }
        reader.readAsDataURL(event.target.files[0]);
    }
</script>


