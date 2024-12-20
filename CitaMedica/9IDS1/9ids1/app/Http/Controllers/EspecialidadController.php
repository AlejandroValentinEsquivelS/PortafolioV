<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Especialidad;
class EspecialidadController extends Controller
{

    public function index(Request $req)
    {
        if($req->id){
            $especialidad = Especialidad::find($req->id);
        }else{
            $especialidad = new Especialidad();
        }

        return view('especialidad', compact('especialidad'));

    }

    public function store(Request $req)
    {
        if($req->id !=0){
            $especialidad = Especialidad::find($req->id);
        }else{
            $especialidad = new Especialidad();
        }

        
        $especialidad->nombre = $req->nombre;
        

        $especialidad->save();//insert

        return redirect()->route('especialidades.lista');

    }

    public function list()
    {
        $especialidades = Especialidad::all();
        
        return view('especialidades', compact('especialidades'));

    }

    public function delete( $id){
        $especialidad = Especialidad::find($id);
        $especialidad->delete();

        return redirect()->route('especialidades.lista');

    }

    ////////////////////////APIS

    
    
    public function modifyAPI(Request $req){

        $especialidad = Especialidad::find($req->id);
     
      
        $especialidad->nombre = $req->nombre;

        $especialidad->save();//insert

        return "Ok";

    }
    

    public function indexAPI(Request $req)
    {
        if($req->id){
            $especialidad = Especialidad::find($req->id);
        }else{
            $especialidad = new Especialidad();
        }
        return "Ok";
        return view('especialidad', compact('especialidad'));

    }

    public function storeAPI(Request $req)
    {
        if($req->id !=0){
            $especialidad = Especialidad::find($req->id);
        }else{
            $especialidad = new Especialidad();
        }

        $especialidad->nombre = $req->nombre;

        $especialidad->save();//insert


        return "Ok";
        //return redirect()->to('/divisiones');
        return redirect()->route('especialidades.lista');

    }

    public function listAPI()
    {
        $especialidades = Especialidad::all();
        
        return $especialidades;
        return view('especialidades', compact('especialidades'));


    }

    public function deleteAPI( Request $id){
        $especialidad = Especialidad::find($id->id);
        $especialidad->delete();

        
        return "Ok";
       // return redirect()->route('especialidades.lista');

    }

    public function show(Request $req)
    {
      
        $especialidad = Especialidad::find($req->id);
       
        return response() ->json ($especialidad);

    }

}
