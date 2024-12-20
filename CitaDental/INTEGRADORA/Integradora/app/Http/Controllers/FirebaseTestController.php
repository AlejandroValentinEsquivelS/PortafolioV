<?php

use Kreait\Firebase\Factory;

class FirebaseTestController extends Controller
{
    public function index()
    {
        // Crear una instancia de Firebase
        $firebase = (new Factory)
            ->withServiceAccount(config('firebase.credentials.file'))
            ->create();

        // Acceder a la base de datos
        $database = $firebase->getDatabase();

        // Leer datos desde Realtime Database
        $reference = $database->getReference('ruta/a/tu/datos');
        $data = $reference->getValue();

        return response()->json($data);
    }

    public function store(Request $request)
    {
        // Crear una instancia de Firebase
        $firebase = (new Factory)
            ->withServiceAccount(config('firebase.credentials.file'))
            ->create();

        // Acceder a la base de datos
        $database = $firebase->getDatabase();

        // Guardar datos en Realtime Database
        $newData = [
            'name' => $request->input('name'),
            'email' => $request->input('email'),
        ];

        $database->getReference('ruta/a/tu/datos')->push($newData);

        return response()->json(['message' => 'Data saved successfully']);
    }
}
