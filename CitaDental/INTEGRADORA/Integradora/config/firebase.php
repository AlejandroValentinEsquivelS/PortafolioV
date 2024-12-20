<?php

return [
    'credentials' => [
        'file' => env('FIREBASE_CREDENTIALS'),
        'auto_discovery' => true,
    ],

    'database' => [
        'url' => env('FIREBASE_DATABASE_URL'),
    ],
];