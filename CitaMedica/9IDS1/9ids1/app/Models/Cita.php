<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cita extends Model
{
    use HasFactory;
    protected $table = "cita";

    public function paciente()
    {
        return $this->belongsTo(Paciente::class, 'id_paciente');
    }

    public function especialidad()
    {
        return $this->belongsTo(Especialidad::class, 'id_especialidad');
    }
    public function doctor()
    {
        return $this->belongsTo(Doctor::class, 'id_doc');
    }
    public function consultorio()
    {
        return $this->belongsTo(Consultorio::class, 'id_consultorio');
    }



    
}
