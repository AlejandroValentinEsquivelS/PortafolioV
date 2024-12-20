<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

//Especialidades
Route::get('/especialidad', [App\Http\Controllers\EspecialidadController::class, 'index']) ->name('especialidad.nuevo');
Route::post('/especialidad/guardar', [App\Http\Controllers\EspecialidadController::class, 'store']) ->name('especialidad.guardar');
Route::get('especialidades', [App\Http\Controllers\EspecialidadController::class, 'list'])->name('especialidades.lista');
Route::delete('/especialidad/delete/{id}', [App\Http\Controllers\EspecialidadController::class, 'delete']) ->name('especialidad.borrar');

//Doctores
Route::get('/doctor', [App\Http\Controllers\DoctorController::class, 'index']) ->name('doctor.nuevo');
Route::post('/doctor/guardar', [App\Http\Controllers\DoctorController::class, 'store']) ->name('doctor.guardar');
Route::get('doctores', [App\Http\Controllers\DoctorController::class, 'list'])->name('doctores.lista');
Route::delete('/doctor/delete/{id}', [App\Http\Controllers\DoctorController::class, 'delete']) ->name('doctor.borrar');

//Consultorios
Route::get('/consultorio', [App\Http\Controllers\ConsultorioController::class, 'index']) ->name('consultorio.nuevo');
Route::post('/consultorio/guardar', [App\Http\Controllers\ConsultorioController::class, 'store']) ->name('consultorio.guardar');
Route::get('consultorios', [App\Http\Controllers\ConsultorioController::class, 'list']) ->name('consultorios.lista');
Route::delete('/consultorio/delete/{id}', [App\Http\Controllers\ConsultorioController::class, 'delete']) ->name('consultorio.borrar');

//Medicamentos
Route::get('/medicamento', [App\Http\Controllers\MedicamentoController::class, 'index']) ->name('medicamento.nuevo');
Route::post('/medicamento/guardar', [App\Http\Controllers\MedicamentoController::class, 'store']) ->name('medicamento.guardar');
Route::get('medicamentos', [App\Http\Controllers\MedicamentoController::class, 'list'])->name('medicamentos.lista');
Route::delete('/medicamento/delete/{id}', [App\Http\Controllers\MedicamentoController::class, 'delete']) ->name('medicamento.borrar');