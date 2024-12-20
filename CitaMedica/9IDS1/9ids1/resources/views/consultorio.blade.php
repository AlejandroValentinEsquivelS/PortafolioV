@extends('adminlte::page')

@section('title', 'Agregar consultorio')

@section('content_header')

    <link href="http://mx.geocities.com/mipagina/favicon.ico" type="image/x-icon" rel="shortcut icon" />

    @stop

@section('content')

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div style=" background-color:#00866e; color:#fff"  class="bg text-white p-3 mb-3 rounded-top">
                <h2 class="text-center ">Datos de consultorio</h2>
            </div>
            
            <div style=" background-color:#fff;">
           
                <form  style="padding-left: 10%; height: 90%; width: 90%;" class="formulario-aceptar" action="{{ route('consultorio.guardar')}}" method="POST" class="shadow p-3 mb-5 bg-white rounded" style="animation: fadeInUp">
                 @csrf
                <input type="hidden" name="id" value="{{$consultorio->id}}">
                <br>
            
                <div class="form-group row ">
                    <label for="numero" class="col-sm-3 col-form-label">Número: </label>
                    <div class="col-sm-9">
                    <input type="text" class="form-control input-animation" id="" name="numero"  value="{{$consultorio->numero =='' ?  old('numero') :$consultorio->numero}}" >
                 
                </div>
                </div>
                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="edificio">Edificio: </label>
                    <div class="col-sm-9">
                    <input type="edificio" class="form-control input-animation" id="edificio" name="edificio"  value="{{$consultorio->edificio =='' ?  old('edificio') :$consultorio->edificio}}" >
                    
                </div>
                </div>
                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="nivel">Nivel: </label>
                    <div class="col-sm-9">
                    <input type="nivel" class="form-control input-animation" id="nivel" name="nivel"  value="{{$consultorio->nivel =='' ?  old('nivel') :$consultorio->nivel}}" >
                    
                </div>
                </div>
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
