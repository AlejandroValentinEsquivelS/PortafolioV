<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\ServiceAccount;

class ConsultorioController extends Controller
{
    protected $database;

    public function __construct()
    {
        // Cargar el archivo de credenciales y la URL desde el archivo .env
        $firebase = (new Factory)
            ->withServiceAccount(env('FIREBASE_CREDENTIALS'))
            ->withDatabaseUri(env('FIREBASE_DATABASE_URL'));

        $this->database = $firebase->createDatabase();
    }

    public function index(Request $req)
    {
        // Verificar si se pasa un id para editar
        if ($req->id) {
            $consultorio = $this->database->getReference('consultorios/' . $req->id)->getValue();
            if (!$consultorio) {
                return redirect()->route('consultorios.lista')->withErrors('Consultorio no encontrado');
            } else {
                $consultorio['id'] = $req->id; // Asegurarse de pasar el id a la vista
            }
        } else {
            // Crear un nuevo consultorio con valores vacíos
            $consultorio = [
                'numero' => '',
                'edificio' => '',
                'nivel' => '',
            ];
        }

        return view('consultorio', compact('consultorio'));
    }

    public function store(Request $req)
    {
        $data = [
            'numero' => $req->numero,
            'edificio' => $req->edificio,
            'nivel' => $req->nivel,
        ];

        // Verificar si se ha pasado un ID
        if ($req->has('id') && $req->id != 0) {
            // Editar un consultorio existente
            $this->database->getReference('consultorios/' . $req->id)->set($data);
        } else {
            // Crear un nuevo consultorio
            $this->database->getReference('consultorios')->push($data);
        }

        return redirect()->route('consultorios.lista');
    }

    public function list()
    {
        $consultorios = [];
        $documents = $this->database->getReference('consultorios')->getValue();
        if ($documents) {
            foreach ($documents as $id => $document) {
                $consultorios[] = ['id' => $id, 'data' => $document];
            }
        }

        return view('consultorios', compact('consultorios'));
    }

    public function delete($id)
    {
        $this->database->getReference('consultorios/' . $id)->remove();
        return redirect()->route('consultorios.lista');
    }
}
