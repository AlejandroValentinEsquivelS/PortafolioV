<?php
use App\Http\Controllers\CitaController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ConsultorioController;
use App\Http\Controllers\DentistaController;
use App\Http\Controllers\EspecialidadController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\PacienteController;
use App\Models\Paciente;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');



//Especialidades
Route::post('/especialidad', [EspecialidadController::class, 'show']);
Route::post('/especialidad/guardar', [EspecialidadController::class, 'storeAPI']);
Route::post('/especialidad/modificar', [EspecialidadController::class, 'modifyAPI']);
Route::get('especialidades', [EspecialidadController::class, 'listAPI']);
Route::post('/especialidad/delete', [EspecialidadController::class, 'deleteAPI']);
Route::get('especialidad/{idEspecialidad}', [EspecialidadController::class, 'getEspecialidadNombre']);



//Consultorios
Route::get('/consultorio', [ConsultorioController::class, 'indexAPI']);
Route::post('/consultorio/guardar', [ConsultorioController::class, 'storeAPI']);
Route::post('/consultorio/modificar', [ConsultorioController::class, 'modifyAPI']);
Route::get('consultorios', [ConsultorioController::class, 'listAPI']) ;
Route::post('/consultorio/delete', [ConsultorioController::class, 'deleteAPI']) ;
Route::get('consultorios/obtener/{idcon}', [ConsultorioController::class, 'getConsultorioNombre']);



//API LOGIN
Route::post('login', [LoginController::class, 'login']);

//PACIENTE 
Route::post('paciente/guardar', [PacienteController::class, 'storeAPI']); 
Route::post('paciente/registrar', [PacienteController::class, 'storeAPIUseryPaciente']); 
Route::get('pacientes2', [PacienteController::class, 'listAPI']);
Route::get('paciente/{id_paciente}', [PacienteController::class, 'obtenerPaciente']);





//Dentistas
Route::get('/dentista', [DentistaController::class, 'indexAPI']) ;
Route::post('/dentista/guardar', [DentistaController::class, 'storeAPI']);
Route::post('/dentista/modificar', [DentistaController::class, 'modifyAPI']);
Route::get('dentistas', [DentistaController::class, 'listAPI']);
Route::post('/dentista/delete', [DentistaController::class, 'deleteAPI']);
Route::get('dentistas/obtener/{iddoc}', [DentistaController::class, 'getDentistaNombre']);