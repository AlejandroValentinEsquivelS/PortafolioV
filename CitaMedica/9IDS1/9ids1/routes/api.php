<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ConsultorioController;
use App\Http\Controllers\DoctorController;
use App\Http\Controllers\EspecialidadController;
use App\Http\Controllers\MedicamentoController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\PacienteController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');



//Especialidades
Route::post('/especialidad', [EspecialidadController::class, 'show']);
Route::post('/especialidad/guardar', [EspecialidadController::class, 'storeAPI']);
Route::post('/especialidad/modificar', [EspecialidadController::class, 'modifyAPI']);
Route::get('especialidades', [EspecialidadController::class, 'listAPI']);
Route::post('/especialidad/delete', [EspecialidadController::class, 'deleteAPI']);

//Doctores
Route::get('/doctor', [DoctorController::class, 'indexAPI']) ;
Route::post('/doctor/guardar', [DoctorController::class, 'storeAPI']);
Route::post('/doctor/modificar', [DoctorController::class, 'modifyAPI']);
Route::get('doctores', [DoctorController::class, 'listAPI']);
Route::post('/doctor/delete', [DoctorController::class, 'deleteAPI']);

//Consultorios
Route::get('/consultorio', [ConsultorioController::class, 'indexAPI']);
Route::post('/consultorio/guardar', [ConsultorioController::class, 'storeAPI']);
Route::post('/consultorio/modificar', [ConsultorioController::class, 'modifyAPI']);
Route::get('consultorios', [ConsultorioController::class, 'listAPI']) ;
Route::post('/consultorio/delete', [ConsultorioController::class, 'deleteAPI']) ;

//Medicamentos
Route::get('/medicamento', [MedicamentoController::class, 'indexAPI']) ;
Route::post('/medicamento/guardar', [MedicamentoController::class, 'storeAPI']) ;
Route::post('/medicamento/modificar', [MedicamentoController::class, 'modifyAPI']);
Route::get('medicamentos', [MedicamentoController::class, 'listAPI']);
Route::post('/medicamento/delete', [MedicamentoController::class, 'deleteAPI']);


//API LOGIN
Route::post('login', [LoginController::class, 'login']);

//PACIENTE 

Route::post('paciente/guardar', [PacienteController::class, 'storeAPI']); 
Route::post('paciente/registrar', [PacienteController::class, 'storeAPIUseryPaciente']); 
