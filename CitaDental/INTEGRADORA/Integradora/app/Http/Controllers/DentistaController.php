<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use App\Models\Especialidad;

class DentistaController extends Controller
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

        // Función para mostrar la vista de agregar o editar dentista
        public function index(Request $req)
        {
           // $especialidades = $this->database->getReference('especialidades')->getValue(); // Obtener las especialidades de Firebase
    
            // $especialidadList = [];
            // //if ($especialidades) {
            //     foreach ($especialidades as $id => $data) {
            //         $especialidadList[] = ['id' => $id, 'nombre' => $data['nombre']];
            //     }
            
    
            // Si hay un ID, estamos editando un dentista, si no, creamos uno nuevo
            if ($req->id) {
                $dentista = $this->database->getReference('dentistas/' . $req->id)->getValue();
                if (!$dentista || !isset($dentista['nombre'])) {
                    return redirect()->route('dentistas.lista')->withErrors('Dentista no encontrado.');
                }
            } else {
                $dentista = [
                    'nombre' => '',
                    'cedula' => '',
                    'telefono' => '',
                    'correo' => '',
                    'password' => '',
                ];
            }
    
            // Pasar el dentista y la lista de especialidades a la vista
            return view('dentista', compact('dentista'));
        }
    
        // Guardar o actualizar un dentista
        public function store(Request $req)
{
    // Validar los datos
    $data = $req->validate([
        'nombre' => 'required|string|max:255',
        'cedula' => 'required|string|max:255',
        'telefono' => 'required|string|max:255',
        'correo' => 'required|email|max:255',
        'password' => 'required|string|min:8|max:255',
        'imagen' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048', // Validación de la imagen
    ]);

    // Crear usuario en Firebase Authentication
    try {
        $auth = app('firebase.auth');

        // Crear el usuario con el correo y la contraseña
        $userProperties = [
            'email' => $data['correo'],
            'password' => $data['password'],
            'displayName' => $data['nombre'],
        ];

        $createdUser = $auth->createUser($userProperties);

        // Obtener el UID del usuario creado
        $uid = $createdUser->uid;

    } catch (\Kreait\Firebase\Exception\AuthException $e) {
        return back()->withErrors(['error' => 'Error al crear el usuario en Firebase Authentication: ' . $e->getMessage()]);
    }

    // Subir la imagen a Firebase Storage
    $imageUrl = '';
    if ($req->hasFile('imagen')) {
        $file = $req->file('imagen');
        $imageName = $file->hashName(); // Genera un nombre único para la imagen
        $firebaseStoragePath = 'dentistas/' . $imageName; // Ruta en Firebase Storage
        $localFolder = public_path('firebase-temp-uploads') . '/';

        // Subir el archivo temporalmente
        if ($file->move($localFolder, $imageName)) {
            $uploadedfile = fopen($localFolder . $imageName, 'r');
            $storage = app('firebase.storage');
            $bucket = $storage->getBucket();

            // Subir a Firebase Storage en la carpeta "dentistas"
            $object = $bucket->upload($uploadedfile, [
                'name' => $firebaseStoragePath
            ]);

            // Obtener la URL pública de la imagen
            $object->update(['acl' => []]); // Asegurar que el archivo sea público
            $imageUrl = $object->signedUrl(new \DateTime('9999-12-31')); // URL de acceso directo

            // Eliminar el archivo temporal
            unlink($localFolder . $imageName);
        }
    }

    // Añadir el UID y la URL de la imagen a los datos para almacenarlos en Firebase Realtime Database
    $data['uid'] = $uid;
    $data['imagen_url'] = $imageUrl; // Guardar la URL de la imagen

    // Almacenar en Firebase Realtime Database usando el UID como clave
    $this->database->getReference('dentistas/' . $uid)->set($data);

    // Redirigir después de guardar
    return redirect()->route('dentistas.lista');
}



        
        
    
        // Función para listar dentistas (puedes modificar según sea necesario)
        public function list()
        {
            // Obtener los dentistas y especialidades desde Firebase
            $dentistas = $this->database->getReference('dentistas')->getValue();
            //$especialidades = $this->database->getReference('especialidades')->getValue();

            // Asociar nombre de especialidad a cada dentista
            $dentistaList = [];
             if ($dentistas) {
                 foreach ($dentistas as $id => $dentista) {
                     // Verificar si la especialidad existe y asociar el nombre
                    //  if (isset($dentista['id_especialidad']) && isset($especialidades[$dentista['id_especialidad']])) {
                    //      $dentista['nombre_especialidad'] = $especialidades[$dentista['id_especialidad']]['nombre'];
                    //  } else {
                    //      $dentista['nombre_especialidad'] = 'Especialidad no asignada'; // Por si no tiene especialidad
                    //  }
                     // Añadir el ID del dentista
                    $dentista['id'] = $id;
                     // Agregar el dentista a la lista final
                     $dentistaList[] = $dentista;
                 }
             }

            // Pasar la lista de dentistas a la vista
            return view('dentistas', compact('dentistaList'));
        }


    public function delete($id)
    {
        $this->database->getReference('dentistas/' . $id)->remove();
        return redirect()->route('dentistas.lista')->with('success', 'Dentista eliminado exitosamente.');
    }
}
