@extends('adminlte::page')

@section('title', 'Consultorios')

@section('content')
<header>
</header>

<br>
<center>
    <div class="text-center mb-3">
        <img src="{{ asset('ClinicControlIcono.png') }}" alt="Logo" class="img-fluid" style="max-width: 90px; height: auto;">
    </div>
    <div>
        <h3 class="text-center">Consultorios</h3>
    </div>
</center>
<div class="box-body">
    <table id="table-data" style="width: 90%;" class="table table-bordered custom-table">
        <thead style="background-color:#1338BE; color:#fff">
            <tr>
                <th style="background-color: #1338BE;">Número</th>
                <th style="background-color: #1338BE;">Edificio</th>
                <th style="background-color: #1338BE;">Nivel</th>
                <th style="width:12%; height:22%; background-color: #1338BE;" colspan="2">Opciones</th>
            </tr>
        </thead>
        <tbody style="background-color: rgb(255,255,255)">
            @foreach($consultorios as $consultorio)
            <tr>
                <td class="animate__delay-1s">{{ $consultorio['data']['numero'] }}</td>
                <td class="animate__delay-1s">{{ $consultorio['data']['edificio'] }}</td>
                <td class="animate__delay-1s">{{ $consultorio['data']['nivel'] }}</td>
                <td>
                    <a href="{{ route('consultorio.nuevo', ['id' => $consultorio['id']]) }}" style="border-radius:10px;" class="btn btn-success btn-sm rounded-8 animate__delay-1s">
                        <span><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAPdJREFUSEvVldERgkAMRLOdYCfSiVaiVqKdSClnJdFlgImR4wLCB/fDMBz7ktzOHmTjhY31ZTWAqt5F5AXgaov+AqjqUUS4sSp0VgNo+j2d+Kl7v1mIBzxFhJCp5cVZDP+zRQ0QD1Aq41NC5GxUtQKQ+HSQM4BHq2WFVDUM6MbCbtmRhbD6VnwxwM089ZCxrmd34MR7zQTg8DcgI07dYeYeEu4gKk6rWwuHAHPE6SbrwiIgKs7RjLkwAmit69bozNcCZA90DUBWfPGIIpFhQu8nCYpnsDtAJK5LTTUA6lzYMR0vgTshB2Hw0QjDZRTK/VLJU9/3D3gDazjBGbL5ohcAAAAASUVORK5CYII="/></span>
                       
                    </a>
                </td>
                <td>
                    <form action="{{ route('consultorio.borrar', ['id' => $consultorio['id']]) }}" method="POST" class="formulario-eliminar">
                        @csrf
                        @method('DELETE')
                        <button type="submit" style="border-radius: 10px;" class="btn btn-danger btn-sm rounded-8 animate__delay-1s">
                        <span><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAJRJREFUSEvtlcENgCAMRfs301GcRJ1MRnGTag8kSoBaAh6UHhvyX/uBFtQ40FifVAAzD0S0JQpZASy5IrMARVx0dyKaALgU5AZgZq5hGc62vM67gBrVhxrROyi16mpN1CKf/BbAtx12FcsXWdQB6jPtFv3AIssAtHw02WCyySzhAIxPp6mIzwZIcrOpO9nSQuxsc8ABQHeaGbkbfj0AAAAASUVORK5CYII="/></span>
                    </button>
                    </form>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection

@section('js')
<script>
    $('#table-data').DataTable({
        "scrollX": true
    });
</script>
<script>
    $('.formulario-eliminar').submit(function(e) {
        e.preventDefault(); // Previene el envío normal del formulario
        Swal.fire({
            title: "Estas seguro?",
            text: "No podras recuperar el dato eliminado",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: "Confirmar"
        }).then((result) => {
            if (result.isConfirmed) {
                this.submit(); // Envía el formulario después de la confirmación
            
                Swal.fire({
                    title: "Eliminado",
                    text: "Se elimino de forma correcta",
                    icon: "success"
                });
               }
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
@endsection

@section('css')
<style>
body {
    background-color: #c1e8ff;
}

.btn:hover {
    transform: scale(1.1);
}

table {
    background: white;
    width: 50%;
    margin: 0 auto;
    margin-top: 2%;
    border-collapse: collapse;
    text-align: center;
}

.custom-table {
    border-collapse: collapse; /* Para fusionar los bordes de las celdas */
    border: 1px solid #ddd; /* Establece el borde de la tabla */
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Sombra */
    border-radius: .4em;
    overflow: hidden;
}

.custom-table th,
.custom-table td {
    border: none; /* Elimina el borde de las celdas */
    padding: 8px; /* Añade relleno a las celdas */
    padding: 10px;
}

.custom-table tr {
    border-bottom: 1px solid #ddd; /* Establece el borde solo en la parte inferior de cada fila */
}

th, td:before {
    background-color: #1338BE;
}

tr:hover {
    background-color: #d2ede3;
}
</style>
@endsection
