<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\SwaggerController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Swagger Documentation
Route::get('/documentation', [SwaggerController::class, 'api']);

// Public API routes
Route::get('/health', function () {
    return response()->json([
        'status' => 'healthy',
        'timestamp' => now(),
        'service' => 'Laravel API',
        'version' => '1.0.0'
    ]);
});

// Authentication routes (public)
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

// Protected routes (require authentication)
Route::middleware('api.auth')->group(function () {
    // User profile
    Route::get('/auth/me', [AuthController::class, 'me']);
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::post('/auth/refresh', [AuthController::class, 'refresh']);
    
    // User management API routes (protected)
    Route::apiResource('users', UserController::class);
    
    // Additional user routes (protected)
    Route::get('/users/search/{query}', [UserController::class, 'search']);
    Route::get('/users/stats', [UserController::class, 'stats']);
});

// Legacy route for backward compatibility (will redirect to protected version)
Route::get('/user', function (Request $request) {
    return response()->json([
        'success' => false,
        'message' => 'This endpoint is deprecated. Use /auth/me with Bearer token instead.',
        'code' => 'DEPRECATED_ENDPOINT'
    ], 410);
});
