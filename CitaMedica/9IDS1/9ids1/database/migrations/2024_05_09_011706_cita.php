<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cita', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_paciente');
            $table->unsignedBigInteger('id_especialidad');
            $table->dateTime('FechaHora');
            $table->unsignedBigInteger('id_doc')->nullable();
            $table->unsignedBigInteger('id_consultorio')->nullable();
            $table->string('estado');

            $table->timestamps();

            $table->foreign('id_paciente')->references('id')->on('paciente');
            $table->foreign('id_especialidad')->references('id')->on('especialidad');
            $table->foreign('id_doc')->references('id')->on('doctor');
            $table->foreign('id_consultorio')->references('id')->on('consultorio');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
