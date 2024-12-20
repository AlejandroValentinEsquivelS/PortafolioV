<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Doctor;
use App\Models\Especialidad;

class DoctorController extends Controller
{

    public function index(Request $req)
    {
        $especialidades = Especialidad::all();
        if($req->id){
            $doctor = Doctor::find($req->id);
        }else{
            $doctor = new Doctor();
        }

        return view('doctor', compact('doctor','especialidades'));
    }

    public function store(Request $req)
    {
        if($req->id !=0){
            $doctor = Doctor::find($req->id);
        }else{
            $doctor = new Doctor();
        }

        $doctor->nombre = $req->nombre;
        $doctor->cedula = $req->cedula;
        $doctor->telefono = $req->telefono;
        $doctor->correo = $req->correo;
        $doctor->id_especialidad = $req->id_especialidad;


        $doctor->save();//insert
        return redirect()->route('doctores.lista');


    }

    public function list()
    {
        $doctores = Doctor::
        join('especialidad','doctor.id_especialidad','=','especialidad.id')
       
        ->select('doctor.*', 'especialidad.nombre as nombre_especialidad') 
        ->get();
        return view('doctores', compact('doctores'));


    }

    public function delete($id){
        $doctor = Doctor::find($id);
        $doctor->delete();
 
        return redirect()->route('doctores.lista');
    }

    ///////////////////API

    public function modifyAPI(Request $req){

       
       
        $doctor = Doctor::find($req->id);
      
        $doctor->nombre = $req->nombre;
        $doctor->cedula = $req->cedula;
        $doctor->telefono = $req->telefono;
        $doctor->correo = $req->correo;

        $doctor->save();//insert

        return "Ok";

    }

    public function indexAPI(Request $req)
    {
        if($req->id){
            $doctor = Doctor::find($req->id);
        }else{
            $doctor = new Doctor();
        }

        return "Ok";
        return view('doctor', compact('doctor'));
    }

    public function storeAPI(Request $req)
    {
        if($req->id !=0){
            $doctor = Doctor::find($req->id);
        }else{
            $doctor = new Doctor();
        }

        $doctor->nombre = $req->nombre;
        $doctor->cedula = $req->cedula;
        $doctor->telefono = $req->telefono;
        $doctor->correo = $req->correo;

        $doctor->save();//insert

        return "Ok";
        //return redirect()->to('/divisiones');
        return redirect()->route('doctores.lista');
    }

    public function listAPI()
    {
        $doctores = Doctor::all();

        return $doctores;
        return view('doctores', compact('doctores'));
    }

    public function deleteAPI(Request $id){
        $doctor = Doctor::find($id->id);
        $doctor->delete();
        
        return "Ok";
        return redirect()->route('doctores.lista');
    }
}
