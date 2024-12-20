<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use App\Models\Paciente;
use App\Models\Users;
class PacienteController extends Controller
{
    public function storeAPI(Request $req)
    {
        if ($req->id != 0) {
            $paciente = Paciente::find($req->id);
        } else {
            $paciente = new Paciente();
        }
    
        $paciente->nombre = $req->nombre;
        $paciente->edad = $req->edad;
        $paciente->telefono = $req->telefono;
        $paciente->peso = $req->peso;
        $paciente->altura = $req->altura;
        $paciente->direccion = $req->direccion;
        $paciente->correo = $req->correo;
        $paciente->tipo_sangre = $req->tipo_sangre;
        
        $paciente->save();
    
        return "ok";
    
        //return redirect()->route('especialidades.lista');
    }


     public function storeAPIUseryPaciente(Request $req)
     {
     if ($req->id != 0) {
         $paciente = Paciente::find($req->id);
         $user = Users::find($req->id);
     } else {
         $paciente = new Paciente();
         $user = new Users();
     }


     $user->name = $req->name;
     $user->email = $req->email;
    //  $user->email_verified_at = datetime();
     $user->password = bcrypt($req->password);
    //  $user->remember_token = $req->remember_token;
    //  $user->created_at = Carbon::now();
    //  $user->update_at = Carbon::now();
     $user->role = $req->role;

     $user->save();

     // Datos del paciente
     $paciente->id = $user->id;
     $paciente->nombre = $req->nombre;
     $paciente->edad = $req->edad;
     $paciente->telefono = $req->telefono;
     $paciente->peso = $req->peso;
     $paciente->altura = $req->altura;
     $paciente->direccion = $req->direccion;
     $paciente->correo = $req->correo;
     $paciente->tipo_sangre = $req->tipo_sangre;

     // Guardar el paciente
     $paciente->save();
     

     

     return "Ok";
     //return redirect()->to('/divisiones');
     }

     public function listAPI()
     {
         $pacientes = Paciente::all();
         return $pacientes;
         return view('pacientes', compact('pacientes'));
     }

     public function obtenerPaciente($idPaciente)
{
    try {
        $paciente = Paciente::findOrFail($idPaciente);
        return response()->json($paciente);
    } catch (\Exception $e) {
        return response()->json(['error' => 'Error al obtener los datos del paciente'], 404);
    }
}



}
