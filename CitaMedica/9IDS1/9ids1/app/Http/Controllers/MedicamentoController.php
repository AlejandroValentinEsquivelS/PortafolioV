<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Medicamento;

class MedicamentoController extends Controller
{

    public function index(Request $req)
    {
        if($req->id){
            $medicamento = Medicamento::find($req->id);
        }else{
            $medicamento = new Medicamento();
        }
        return view('medicamento', compact('medicamento'));
    }

    public function store(Request $req)
    {
        if($req->id !=0){
            $medicamento = Medicamento::find($req->id);
        }else{
            $medicamento = new Medicamento();
        }

        $medicamento->nombre = $req->nombre;
        $medicamento->marca = $req->marca;
        $medicamento->tipo = $req->tipo;
        $medicamento->presentacion = $req->presentacion;
        $medicamento->fechaCaducidad = $req->fechaCaducidad;
        $medicamento->lote = $req->lote;


        $medicamento->save();//insert

        return redirect()->route('medicamentos.lista');
    }

    public function list()
    {
        $medicamentos = Medicamento::all();
        return view('medicamentos', compact('medicamentos'));
    }

    public function delete($id){
        $medicamento = Medicamento::find($id);
        $medicamento->delete();
        return redirect()->route('medicamentos.lista');
    }


    ////////////////////////////API 

    public function modifyAPI(Request $req){

    
        $medicamento = Medicamento::find($req->id);
        
        $medicamento->nombre = $req->nombre;
        $medicamento->marca = $req->marca;
        $medicamento->tipo = $req->tipo;
        $medicamento->presentacion = $req->presentacion;
        $medicamento->fechaCaducidad = $req->fechaCaducidad;
        $medicamento->lote = $req->lote;


        $medicamento->save();//insert

        return "Ok";

    }

    public function indexAPI(Request $req)
    {
        if($req->id){
            $medicamento = Medicamento::find($req->id);
        }else{
            $medicamento = new Medicamento();
        }

        return view('medicamento', compact('medicamento'));
    }

    public function storeAPI(Request $req)
    {
        if($req->id !=0){
            $medicamento = Medicamento::find($req->id);
        }else{
            $medicamento = new Medicamento();
        }

        $medicamento->nombre = $req->nombre;
        $medicamento->marca = $req->marca;
        $medicamento->tipo = $req->tipo;
        $medicamento->presentacion = $req->presentacion;
        $medicamento->fechaCaducidad = $req->fechaCaducidad;
        $medicamento->lote = $req->lote;


        $medicamento->save();//insert

        //return redirect()->to('/divisiones');
        return redirect()->route('medicamentos.lista');
    }

    public function listAPI()
    {
        $medicamentos = Medicamento::all();

        return $medicamentos;

        return view('medicamentos', compact('medicamentos'));
    }

    public function deleteAPI(Request $id){
        $medicamento = Medicamento::find($id->id);
        $medicamento->delete();

        return "Ok";

        return redirect()->route('medicamentos.lista');
    }
}
