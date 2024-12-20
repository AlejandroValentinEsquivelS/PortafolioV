<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;


class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    // public function __construct()
    // {
    //     $this->middleware('auth');
    // }

    protected $database;

    public function __construct()
    {
        // Cargar el archivo de credenciales y la URL desde el archivo .env
        $firebase = (new Factory)
            ->withServiceAccount(env('FIREBASE_CREDENTIALS')) // Llama a la ruta desde el .env
            ->withDatabaseUri(env('FIREBASE_DATABASE_URL')); // URL también desde el .env

        $this->database = $firebase->createDatabase(); // Crear la instancia de Realtime Database
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
   
        $especialidades = [];
        $documents = $this->database->getReference('especialidades')->getValue();
        
        if ($documents) {
            foreach ($documents as $id => $document) {
                $especialidades[] = ['id' => $id, 'data' => $document];
            }
        }

        return view('home', compact('especialidades')); // Asegúrate de que la vista se llama 'inicio.blade.php'
   
        //return view('home');
    }
}
