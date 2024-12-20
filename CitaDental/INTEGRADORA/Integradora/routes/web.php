<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\FirebaseTestController;
use App\Http\Controllers\EspecialidadController;
use App\Http\Controllers\ConsultorioController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MedicamentoController;

Route::get('/dashboard', function () {
    return view('welcome');
});

Auth::routes();
Route::get('/home', [App\Http\Controllers\HomeController::class, 'index','list'])->name('home');

//ESPECIALIDADES
Route::get('/especialidad', [EspecialidadController::class, 'index'])->name('especialidad.nuevo');
Route::get('/especialidades/editar/{id}', [EspecialidadController::class, 'index'])->name('especialidad.editar');
Route::post('/especialidades/store/{id?}', [EspecialidadController::class, 'store'])->name('especialidad.store');
Route::post('/especialidad/guardar', [EspecialidadController::class, 'store'])->name('especialidad.guardar');
Route::get('/especialidades', [EspecialidadController::class, 'list'])->name('especialidades.lista');
Route::delete('/especialidad/delete/{id}', [EspecialidadController::class, 'delete'])->name('especialidad.borrar');


//Doctores
Route::get('/doctor', [App\Http\Controllers\DoctorController::class, 'index']) ->name('doctor.nuevo');
Route::post('/doctor/guardar', [App\Http\Controllers\DoctorController::class, 'store']) ->name('doctor.guardar');
Route::get('doctores', [App\Http\Controllers\DoctorController::class, 'list'])->name('doctores.lista');
Route::delete('/doctor/delete/{id}', [App\Http\Controllers\DoctorController::class, 'delete']) ->name('doctor.borrar');

//CONSULTORIOS
Route::get('/consultorios', [ConsultorioController::class, 'list'])->name('consultorios.lista');
Route::get('/consultorios/{id?}', [ConsultorioController::class, 'index'])->name('consultorio.mostrar');
Route::post('/consultorios/store', [ConsultorioController::class, 'store'])->name('consultorio.guardar'); // Guardar o editar consultorio
Route::get('/consultorio', [ConsultorioController::class, 'index'])->name('consultorio.nuevo');
Route::delete('/consultorio/delete/{id}', [ConsultorioController::class, 'delete'])->name('consultorio.borrar');




Route::get('/medicamentos', [MedicamentoController::class, 'list'])->name('medicamentos.lista');
Route::get('/medicamento/{id?}', [MedicamentoController::class, 'index'])->name('medicamento.guardar');
Route::post('/medicamento', [MedicamentoController::class, 'store'])->name('medicamento.nuevo');
Route::delete('/medicamento/{id}', [MedicamentoController::class, 'delete'])->name('medicamento.borrar');
Route::get('/medicamentos/crear', [MedicamentoController::class, 'index'])->name('medicamento.crear');
Route::get('/medicamentos/{id}/editar', [MedicamentoController::class, 'index'])->name('medicamento.editar');



//dentistaes
use App\Http\Controllers\DentistaController;
Route::get('/dentista', [DentistaController::class, 'index'])->name('dentista.nuevo');
Route::post('/dentista/guardar', [DentistaController::class, 'store'])->name('dentista.guardar');
Route::get('dentistas', [DentistaController::class, 'list'])->name('dentistas.lista');
Route::delete('/dentista/delete/{id}', [DentistaController::class, 'delete'])->name('dentista.borrar');



Route::get('/firebase-test', [FirebaseTestController::class, 'index']);
Route::post('/firebase-store', [FirebaseTestController::class, 'store']);


Route::get('/politicas-privacidad', function () {return view('politicas_privacidad');})->name('politicas.privacidad');