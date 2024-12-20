<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\ServiceAccount;

class EspecialidadController extends Controller
{
    protected $database;

    public function __construct()
    {
        // Cargar el archivo de credenciales y la URL desde el archivo .env
        $firebase = (new Factory)
            ->withServiceAccount(env('FIREBASE_CREDENTIALS')) // Llama a la ruta desde el .env
            ->withDatabaseUri(env('FIREBASE_DATABASE_URL')); // URL también desde el .env

        $this->database = $firebase->createDatabase(); // Crear la instancia de Realtime Database
    }

    public function index(Request $req)
    {
        $especialidad = null;
    
        if ($req->id) {
            $especialidad = $this->database->getReference('especialidades/' . $req->id)->getValue();
            if ($especialidad) {
                $especialidad['id'] = $req->id; // Asegurarnos de que se pasa el id a la vista
            } else {
                $especialidad = [];
            }
        } else {
            $especialidad = [];
        }
    
        return view('especialidad', compact('especialidad'));
    }
    
    public function store(Request $req)
    {
        $data = [
            'nombre' => $req->nombre,
        ];
    
        if ($req->has('id')) {
            // Editar una especialidad existente
            $this->database->getReference('especialidades/' . $req->id)->set($data);
        } else {
            // Crear una nueva especialidad
            $this->database->getReference('especialidades')->push($data);
        }
    
        return redirect()->route('especialidades.lista');
    }
    

    public function list()
    {
        $especialidades = [];
        $documents = $this->database->getReference('especialidades')->getValue();
        if ($documents) {
            foreach ($documents as $id => $document) {
                $especialidades[] = ['id' => $id, 'data' => $document];
            }
        }

        return view('especialidades', compact('especialidades'));
    }

    public function delete($id)
    {
        $this->database->getReference('especialidades/' . $id)->remove();
        return redirect()->route('especialidades.lista');
    }

    // Métodos API
    public function modifyAPI(Request $req)
    {
        $data = [
            'nombre' => $req->nombre,
        ];

        $this->database->getReference('especialidades/' . $req->id)->set($data);
        return "Ok";
    }

    public function indexAPI(Request $req)
    {
        if ($req->id) {
            $especialidad = $this->database->getReference('especialidades/' . $req->id)->getValue();
            return response()->json($especialidad ? $especialidad : []);
        } else {
            return response()->json([]);
        }
    }

    public function storeAPI(Request $req)
    {
        $data = [
            'nombre' => $req->nombre,
        ];

        if ($req->id != 0) {
            $this->database->getReference('especialidades/' . $req->id)->set($data);
        } else {
            $this->database->getReference('especialidades')->push($data);
        }

        return "Ok";
    }

    public function listAPI()
    {
        $especialidades = [];
        $documents = $this->database->getReference('especialidades')->getValue();
        if ($documents) {
            foreach ($documents as $id => $document) {
                $especialidades[] = ['id' => $id, 'data' => $document];
            }
        }

        return response()->json($especialidades);
    }

    public function deleteAPI(Request $request)
    {
        $this->database->getReference('especialidades/' . $request->id)->remove();
        return "Ok";
    }

    public function show(Request $req)
    {
        $especialidad = $this->database->getReference('especialidades/' . $req->id)->getValue();
        return response()->json($especialidad ? $especialidad : []);
    }

    public function getEspecialidadNombre($idEspecialidad)
    {
        $especialidad = $this->database->getReference('especialidades/' . $idEspecialidad)->getValue();
        
        if ($especialidad) {
            return response()->json(['nombre' => $especialidad['nombre']]);
        } else {
            return response()->json(['message' => 'Especialidad no encontrada'], 404);
        }
    }




    
}
