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
     // Datos del paciente
     $paciente->nombre = $req->nombre;
     $paciente->edad = $req->edad;
     $paciente->telefono = $req->telefono;
     $paciente->peso = $req->peso;
     $paciente->altura = $req->altura;
     $paciente->direccion = $req->direccion;
     $paciente->correo = $req->correo;
     $paciente->tipo_sangre = $req->tipo_sangre;
    
     $paciente->save();
     
     $user->name = $req->name;
     $user->email = $req->email;
     $user->password = bcrypt($req->password);
     $user->role = $req->role;
     $user->save();
     return "Ok";
     }

      


    // public function storeAPIUseryPaciente(Request $req)
    // {
    // if ($req->id != 0) {
    //     $paciente = Paciente::find($req->id);
    //     $user = User::find($req->id);
    // } else {
    //     $paciente = new Paciente();
    //     $user = new User();
    // }

    // // Datos del paciente
    // $paciente->nombre = $req->nombre;
    // $paciente->edad = $req->edad;
    // $paciente->telefono = $req->telefono;
    // $paciente->peso = $req->peso;
    // $paciente->altura = $req->altura;
    // $paciente->direccion = $req->direccion;
    // $paciente->correo = $req->correo;
    // $paciente->tipo_sangre = $req->tipo_sangre;

    // // Guardar el paciente
    // $paciente->save();

    // $user->name = $req->name;
    // $user->email = $req->email;
    // $user->password = bcrypt($req->password);
    // $user->rol = $req->rol;

    // $user->save();

    // return "Ok";
    // //return redirect()->to('/divisiones');
    // }

    // public function registrarPaciente(Request $req)
    // {
    //     $validator = Validator::make($req->all(), [
    //         'nombre' => 'required|string|max:255',
    //         'edad' => 'required|integer',
    //         'telefono' => 'required|string|max:20',
    //         'peso' => 'required|numeric',
    //         'altura' => 'required|numeric',
    //         'direccion' => 'required|string|max:255',
    //         'correo' => 'required|email|max:255',
    //         'email' => 'required|email|unique:users,email,' . $req->id,
    //         'password' => 'required|string|min:6',
    //         'rol' => 'required|string|max:50',
    //     ]);

    //     if ($validator->fails()) {
    //         return response()->json(['errors' => $validator->errors()], 422);
    //     }

    //     DB::beginTransaction();

    //     try {
    //         if ($req->id != 0) {
    //             $paciente = Paciente::find($req->id);
    //             $user = User::find($req->id);
    //         } else {
    //             $paciente = new Paciente();
    //             $user = new User();
    //         }

    //         // Datos del paciente
    //         $paciente->fill($req->only([
    //             'nombre', 'edad', 'telefono', 'peso', 'altura', 'direccion', 'correo', 'tipo_sangre'
    //         ]));
    //         $paciente->save();

    //         // Datos del usuario
    //         $user->fill($req->only(['name', 'email', 'rol']));
    //         $user->password = bcrypt($req->password);
    //         $user->save();

    //         DB::commit();

    //         return response()->json(['message' => 'Ok']);
    //     } catch (\Exception $e) {
    //         DB::rollBack();
    //         return response()->json(['error' => 'Error saving data', 'message' => $e->getMessage()], 500);
    //     }
    // }


}
