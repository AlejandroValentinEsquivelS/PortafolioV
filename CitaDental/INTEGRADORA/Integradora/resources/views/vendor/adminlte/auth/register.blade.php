@extends('adminlte::auth.auth-page', ['auth_type' => 'register'])

@php( $login_url = View::getSection('login_url') ?? config('adminlte.login_url', 'login') )
@php( $register_url = View::getSection('register_url') ?? config('adminlte.register_url', 'register') )

@if (config('adminlte.use_route_url', false))
    @php( $login_url = $login_url ? route($login_url) : '' )
    @php( $register_url = $register_url ? route($register_url) : '' )
@else
    @php( $login_url = $login_url ? url($login_url) : '' )
    @php( $register_url = $register_url ? url($register_url) : '' )
@endif

@section('auth_header', __('Registrar una nueva cuenta'))

@section('auth_body')
    <form action="{{ $register_url }}" method="post" style="border-radius: 30%;">
        @csrf

        {{-- Name field --}}
        <div class="input-group mb-3">
            <input type="text" name="name" class="form-control @error('name') is-invalid @enderror"
                   value="{{ old('name') }}" placeholder="nombre" autofocus style="border-radius: 15px;">

            <div class="input-group-append" >
                <div class="input-group-text" style="border-radius: 24px;">
                    <span class="fas fa-user {{ config('adminlte.classes_auth_icon', '') }}" ></span>
                </div>
            </div>

            @error('name')
                <span class="invalid-feedback" role="alert">
                    <strong>{{ $message }}</strong>
                </span>
            @enderror
        </div>

        {{-- Email field --}}
        <div class="input-group mb-3">
            <input type="email" name="email" class="form-control @error('email') is-invalid @enderror"
                   value="{{ old('email') }}" placeholder="correo" style="border-radius: 15px;">

            <div class="input-group-append">
                <div class="input-group-text" style="border-radius: 24px;">
                    <span class="fas fa-envelope {{ config('adminlte.classes_auth_icon', '') }}"></span>
                </div>
            </div>

            @error('email')
                <span class="invalid-feedback" role="alert">
                    <strong>{{ $message }}</strong>
                </span>
            @enderror
        </div>

        {{-- Password field --}}
        <div class="input-group mb-3">
            <input type="password" name="password" class="form-control @error('password') is-invalid @enderror"
                   placeholder="contraseña" style="border-radius: 15px;" id="password">

            <div class="input-group-append">
                <button type="button" class="btn btn-outline-secondary" onclick="togglePasswordVisibility()" style="height:38px; padding:0 10px; border-radius:0 10px 10px 0;">
                    <i id="toggleIcon" class="fas fa-eye"></i>
                </button>
            </div>

            @error('password')
                <span class="invalid-feedback" role="alert">
                    <strong>{{ $message }}</strong>
                </span>
            @enderror
        </div>

        {{-- Confirm password field --}}
        <div class="input-group mb-3">
            <input type="password" name="password_confirmation"
                   class="form-control @error('password_confirmation') is-invalid @enderror"
                   placeholder="repeir contraseña" style="border-radius: 15px;" id="password">

            <div class="input-group-append">
                <button type="button" class="btn btn-outline-secondary" onclick="togglePasswordVisibility()" style="height:38px; padding:0 10px; border-radius:0 10px 10px 0;">
                    <i id="toggleIcon" class="fas fa-eye"></i>
                </button>
            </div>

            @error('password_confirmation')
                <span class="invalid-feedback" role="alert" >
                    <strong>{{ $message }}</strong>
                </span>
            @enderror
        </div>

        {{-- Register button --}}
        <button type="submit" class="btn btn-block {{ config('adminlte.classes_auth_btn', 'btn-flat btn-primary') }}"  style="border-radius: 15px;">
            <span class="fas fa-user-plus"></span>
            Registrar
        </button>

    </form>
@stop

@section('auth_footer')
    <p class="my-0">
        <a href="{{ $login_url }}">
            Ya tengo una cuenta
        </a>
    </p>
@stop


<script>
    function togglePasswordVisibility() {
        var passwordInput = document.getElementById('password');
        var toggleIcon = document.getElementById('toggleIcon');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }
</script>