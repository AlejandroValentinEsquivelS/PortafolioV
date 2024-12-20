@extends('adminlte::page')

@section('title', 'Agregar doctor')

@section('content_header')

    <link href="http://mx.geocities.com/mipagina/favicon.ico" type="image/x-icon" rel="shortcut icon" />

    @stop

@section('content')

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div style=" background-color:#00866e; color:#fff"  class="bg text-white p-3 mb-3 rounded-top">
                <h2 class="text-center ">Datos de doctor</h2>
            </div>
            
            <div style=" background-color:#fff;">
           
                <form  style="padding-left: 10%; height: 90%; width: 90%;" class="formulario-aceptar" action="{{ route('doctor.guardar')}}" method="POST" class="shadow p-3 mb-5 bg-white rounded" style="animation: fadeInUp">
                 @csrf
                <input type="hidden" name="id" value="{{$doctor->id}}">
                <br>
            
                <div class="form-group row ">
                    <label for="nombre" class="col-sm-3 col-form-label">Nombre: </label>
                    <div class="col-sm-9">
                    <input type="text" class="form-control input-animation" id="" name="nombre"  value="{{$doctor->nombre =='' ?  old('nombre') :$doctor->nombre}}" >
                 
                </div>
                </div>
                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="cedula">Cédula: </label>
                    <div class="col-sm-9">
                    <input type="cedula" class="form-control input-animation" id="cedula" name="cedula"  value="{{$doctor->cedula =='' ?  old('cedula') :$doctor->cedula}}" >
                    
                </div>
                </div>
                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="telefono">Teléfono: </label>
                    <div class="col-sm-9">
                    <input type="telefono" class="form-control input-animation" id="telefono" name="telefono"  value="{{$doctor->telefono =='' ?  old('telefono') :$doctor->telefono}}" >
                    
                </div>
                </div>
                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="correo">Correo: </label>
                    <div class="col-sm-9">
                    <input type="correo" class="form-control input-animation" id="correo" name="correo"  value="{{$doctor->correo =='' ?  old('correo') :$doctor->correo}}" >
                    
                </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-3 col-form-label" for="id_especialidad">Especialidad: </label>
                    <div class="col-sm-9">
                        <select name="id_especialidad" class="form-control input-animation">
                        @foreach ($especialidades as $especialidad)
                        <option value="{{$especialidad->id}}"{{$especialidad->id==$doctor->id_especialidad ? 'selected':''}}>{{$especialidad->nombre}}</option>
                        @endforeach
                    </select>
                    <!--mostrar el error de validacion -->
                        @error('id_especialidad')
                        <small style="color: red" > {{$message}}</small>
                        @enderror
                    </div>
                </div>  
                <div>
                <br>
                <div class="text-center">
                    <button id="saberBtn"  class="btn  "  style=" background-color:#00866e; color:#fff" >Aceptar</button>
                </div>
                <br>
                </form>
            </div>
        </div>
    </div>
</div>

@endsection


@section('js')
