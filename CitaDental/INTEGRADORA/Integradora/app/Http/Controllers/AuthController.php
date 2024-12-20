<?php

namespace App\Http\Controllers;

use Kreait\Firebase\Auth;
use Kreait\Firebase\Exception\AuthException;

class AuthController extends Controller
{
    protected $auth;

    public function __construct(Auth $auth)
    {
        $this->auth = $auth;
    }

    public function recuperarContrasena(Request $request)
    {
        $request->validate(['email' => 'required|email']);

        try {
            $this->auth->sendPasswordResetLink($request->email);
            return back()->with('status', 'Se ha enviado un enlace para restablecer la contraseña.');
        } catch (AuthException $e) {
            return back()->withErrors(['email' => 'Error al enviar el enlace de restablecimiento.']);
        }
    }
}
