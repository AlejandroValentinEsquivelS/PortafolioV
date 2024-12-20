<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Consultorio;

class ConsultorioController extends Controller
{

    public function index(Request $req)
    {
        if($req->id){
            $consultorio = Consultorio::find($req->id);
        }else{
            $consultorio = new Consultorio();
        }
      
        return view('consultorio', compact('consultorio'));
    }

    public function store(Request $req)
    {
        if($req->id !=0){
            $consultorio = Consultorio::find($req->id);
        }else{
            $consultorio = new Consultorio();
        }

        $consultorio->numero = $req->numero;
        $consultorio->edificio = $req->edificio;
        $consultorio->nivel = $req->nivel;

        $consultorio->save();//insert
     
        return redirect()->route('consultorios.lista');
    }

    public function list()
    {
        $consultorios = Consultorio::all();
        return view('consultorios', compact('consultorios'));
    }

    public function delete($id){
        $consultorio = Consultorio::find($id);
        $consultorio->delete();

        return redirect()->route('consultorios.lista');
    }


    ////////////////////API

    public function modifyAPI(Request $req){

       
        $consultorio = Consultorio::find($req->id);

        $consultorio->numero = $req->numero;
        $consultorio->edificio = $req->edificio;
        $consultorio->nivel = $req->nivel;

        $consultorio->save();//insert
        return "Ok";

    }

    public function indexAPI(Request $req)
    {
        if($req->id){
            $consultorio = Consultorio::find($req->id);
        }else{
            $consultorio = new Consultorio();
        }
        return "Ok";
        return view('consultorio', compact('consultorio'));
    }

    public function storeAPI(Request $req)
    {
        if($req->id !=0){
            $consultorio = Consultorio::find($req->id);
        }else{
            $consultorio = new Consultorio();
        }

        $consultorio->numero = $req->numero;
        $consultorio->edificio = $req->edificio;
        $consultorio->nivel = $req->nivel;

        $consultorio->save();//insert
        return "Ok";
        //return redirect()->to('/divisiones');
        return redirect()->route('consultorios.lista');
    }

    public function listAPI()
    {
        $consultorios = Consultorio::all();
        return $consultorios;
        return view('consultorios', compact('consultorios'));
    }

    public function deleteAPI(Request $id){
        $consultorio = Consultorio::find($id->id);
        $consultorio->delete();
        return "Ok";
        return redirect()->route('consultorios.lista');
    }


}
