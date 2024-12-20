<?php

namespace App\Http\Controllers;

use App\Models\Cita;
use App\Models\Consultorio;
use App\Models\Dentista;
use App\Models\Especialidad;
use App\Models\Paciente;
use Illuminate\Http\Request;

class CitaController extends Controller
{
    
    public function index(Request $req)
    {
      
        $dentista = Dentista::all();
        $paciente = Paciente::all();
        $especialidad = Especialidad::all();
        $consultorio = Consultorio::all();
    
        if($req->id){
            $cita = Cita::find($req->id);
        }else{
            $cita = new Cita();
        }

        return view('cita', compact('dentista','paciente','especialidades','consultorio'));
    }

    public function store(Request $req)
    {
        if($req->id !=0){
            $cita = Cita::find($req->id);
        }else{
            $cita = new Cita();
        }

        $cita->id_paciente = $req->id_paciente;
        $cita->id_especialidad = $req->id_especialidad;
        $cita->FechaHora = $req->FechaHora;
        $cita->id_doc = $req->id_doc;
        $cita->id_consultorio = $req->id_consultorio;
        $cita->estado = $req->estado;

        $cita->save();//insert
     
        return redirect()->route('citas.lista');
    }

    public function list()
    {
        $citas = Cita::
            join('paciente','cita.id_paciente','=','paciente.id')
            ->join('especialidad','cita.id_especialidad','=','especialidad.id')       
            ->join('dentista','cita.id_doc','=','dentista.id')
            ->join('consultorio','cita.id_consultorio','=','consultorio.id')
            ->select('cita.*', 'paciente.nombre as nombre_paciente',
                            'especialidad.nombre as nombre_especialidad',
                            'dentista.nombre as nombre_dentista',
                            'consultorio.nombre as nombre_consultorio')
            ->get();
            return view('citas', compact('citas'));

    }

    public function delete($id){
        $cita = Cita::find($id);
        $cita->delete();

        return redirect()->route('citas.lista');
    }


    ////////////////////API

    public function modifyAPI(Request $req){

       
        $cita = Cita::find($req->id);

        $cita->id_paciente = $req->id_paciente;
        $cita->id_especialidad = $req->id_especialidad;
        $cita->FechaHora = $req->FechaHora;
        $cita->id_doc = $req->id_doc;
        $cita->id_consultorio = $req->id_consultorio;
        $cita->estado = $req->estado;


        $cita->save();//insert
        return "Ok";

    }

    public function indexAPI(Request $req)
    {
        $dentista = Dentista::all();
        $pacientee = Paciente::all();
        $especialidad = Especialidad::all();
        $consultorio = Consultorio::all();
    
        if($req->id){
            $cita = Cita::find($req->id);
        }else{
            $cita = new Cita();
        }

        return view('cita', compact('dentista','paciente','especialidades','consultorio'));
        return "Ok";
        
    }

    public function storeAPI(Request $req)
    {
        if($req->id !=0){
            $cita = Cita::find($req->id);
        }else{
            $cita = new Cita();
        }

        $cita->id_paciente = $req->id_paciente;
        $cita->id_especialidad = $req->id_especialidad;
        $cita->FechaHora = $req->FechaHora;
        $cita->id_doc = $req->id_doc;
        $cita->id_consultorio = $req->id_consultorio;
        $cita->estado = $req->estado;

        $cita->save();//insert
        return "Ok";
        //return redirect()->to('/divisiones');
        return redirect()->route('citas.lista');
    }

    public function listAPI()
    {
        $citas = Cita::
             join('paciente','cita.id_paciente','=','paciente.id')
                ->join('especialidad','cita.id_especialidad','=','especialidad.id')       
                ->join('dentista','cita.id_doc','=','dentista.id')
                ->join('consultorio','cita.id_consultorio','=','consultorio.id')
                    ->select('cita.*','especialidad.nombre as nombre_especialidad',
                            'paciente.nombre as nombre_paciente',
                            'dentista.nombre as nombre_dentista',
                            'consultorio.nombre as nombre_consultorio')
            ->get();
            return view('citas', compact('citas'));
    }

    public function deleteAPI(Request $id){
        $cita = Cita::find($id->id);
        $cita->delete();
        return "Ok";
        return redirect()->route('citas.lista');
    }




    public function getCitasPorPaciente($idUsuario)
    {
        // Obtener todas las citas asociadas con el ID del paciente
        $citas = Cita::where('id_paciente', $idUsuario)->get();

        // Verificar si se encontraron citas
        if ($citas->isEmpty()) {
            return response()->json(['message' => 'No se encontraron citas para este paciente'], 404);
        }

        return response()->json($citas);

    }


    public function obtenerCita($idcita)
{
    try {
        $cita = Cita::findOrFail($idcita);
        return response()->json($cita);
    } catch (\Exception $e) {
        return response()->json(['error' => 'Error al obtener los datos de la cita'], 404);
    }
}
}