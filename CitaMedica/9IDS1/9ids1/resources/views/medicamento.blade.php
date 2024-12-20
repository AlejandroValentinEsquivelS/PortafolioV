@extends('adminlte::page')

@section('title', 'Agregar medicamento')

@section('content_header')

    <link href="http://mx.geocities.com/mipagina/favicon.ico" type="image/x-icon" rel="shortcut icon" />

    @stop

@section('content')

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div style=" background-color:#00866e; color:#fff"  class="bg text-white p-3 mb-3 rounded-top">
                <h2 class="text-center ">Datos de medicamento</h2>
            </div>
            
            <div style=" background-color:#fff;">
           
                <form  style="padding-left: 10%; height: 90%; width: 90%;" class="formulario-aceptar" action="{{ route('medicamento.guardar')}}" method="POST" class="shadow p-3 mb-5 bg-white rounded" style="animation: fadeInUp">
                 @csrf
                <input type="hidden" name="id" value="{{$medicamento->id}}">
                <br>
            
                <div class="form-group row ">
                    <label for="nombre" class="col-sm-3 col-form-label">Nombre: </label>
                    <div class="col-sm-9">
                    <input type="text" class="form-control input-animation" id="" name="nombre"  value="{{$medicamento->nombre =='' ?  old('nombre') :$medicamento->nombre}}" >
                 
                </div>
                </div>
                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="marca">Marca: </label>
                    <div class="col-sm-9">
                    <input type="marca" class="form-control input-animation" id="marca" name="marca"  value="{{$medicamento->marca =='' ?  old('marca') :$medicamento->marca}}" >
                    
                </div>
                </div>
                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="tipo">Tipo: </label>
                    <div class="col-sm-9">
                    <input type="tipo" class="form-control input-animation" id="tipo" name="tipo"  value="{{$medicamento->tipo =='' ?  old('tipo') :$medicamento->tipo}}" >
                    
                </div>
                </div>

                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="presentacion">Presentación: </label>
                    <div class="col-sm-9">
                    <input type="presentacion" class="form-control input-animation" id="presentacion" name="presentacion"  value="{{$medicamento->presentacion =='' ?  old('presentacion') :$medicamento->presentacion}}" >
                    
                </div>
                </div>

                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="fechaCaducidad">Caducidad: </label>
                    <div class="col-sm-9">
                    <input type="date" class="form-control input-animation" id="fechaCaducidad" name="fechaCaducidad"  value="{{$medicamento->fechaCaducidad =='' ?  old('fechaCaducidad') :$medicamento->fechaCaducidad}}" >
                    
                </div>
                </div>

                <div class="form-group row ">
                    <label class="col-sm-3 col-form-label" for="lote">Lote: </label>
                    <div class="col-sm-9">
                    <input type="lote" class="form-control input-animation" id="lote" name="lote"  value="{{$medicamento->lote =='' ?  old('lote') :$medicamento->lote}}" >
                    
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
