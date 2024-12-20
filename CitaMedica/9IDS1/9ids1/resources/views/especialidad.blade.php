@extends('adminlte::page')

@section('title', 'Agregar especialidad')

@section('content_header')


<link href="http://mx.geocities.com/mipagina/favicon.ico" type="image/x-icon" rel="shortcut icon" />
    @stop

@section('content')

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div style=" background-color:#00866e; color:#fff"  class="bg text-white p-3 mb-3 rounded-top">
                <h2 class="text-center ">Datos de especialidad</h2>
            </div>
            
            <div style=" background-color:#fff;">
           
                <form  style="padding-left: 10%; height: 90%; width: 90%;" class="formulario-aceptar" action="{{ route('especialidad.guardar')}}" method="POST" class="shadow p-3 mb-5 bg-white rounded" style="animation: fadeInUp">
                 @csrf
                <input type="hidden" name="id" value="{{$especialidad->id}}">
                <br>
            
            
                </div>
                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="nombre">Nombre: </label>
                    <div class="col-sm-9">
                    <input type="nombre" class="form-control " id="nombre" name="nombre"  value="{{$especialidad->nombre =='' ?  old('nombre') :$especialidad->nombre}}" >
                  
                </div>
                </div>
                <br>
                <div class="text-center">
                    <button id="saberBtn"  class="btn "  style=" background-color:#00866e; color:#fff" >Aceptar</button>
                </div>
                <br>
                </form>
            </div>
        </div>
    </div>
</div>

@endsection



@section('js')

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
@stop

