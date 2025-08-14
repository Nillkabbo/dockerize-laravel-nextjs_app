# 📝 CODE PATTERNS - Laravel + Next.js + MySQL Ecosystem

## 🎯 **OVERVIEW**

This document contains the **exact code patterns, conventions, and examples** used in this project. AI agents should follow these patterns exactly when adding new features or modifying existing code.

## 🔧 **LARAVEL BACKEND PATTERNS**

### **Controller Structure Pattern**

#### **Base API Controller Template**
```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        try {
            $users = User::all();
            
            return response()->json([
                'success' => true,
                'data' => $users,
                'message' => 'Users retrieved successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Failed to retrieve users: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|email|unique:users,email',
                'password' => 'required|string|min:8'
            ]);

            $user = User::create($validated);

            return response()->json([
                'success' => true,
                'data' => $user,
                'message' => 'User created successfully'
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Failed to create user: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user): JsonResponse
    {
        try {
            return response()->json([
                'success' => true,
                'data' => $user,
                'message' => 'User retrieved successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Failed to retrieve user: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $user): JsonResponse
    {
        try {
            $validated = $request->validate([
                'name' => 'sometimes|string|max:255',
                'email' => 'sometimes|email|unique:users,email,' . $user->id,
                'password' => 'sometimes|string|min:8'
            ]);

            $user->update($validated);

            return response()->json([
                'success' => true,
                'data' => $user,
                'message' => 'User updated successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Failed to update user: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user): JsonResponse
    {
        try {
            $user->delete();

            return response()->json([
                'success' => true,
                'data' => null,
                'message' => 'User deleted successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Failed to delete user: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Search users by query.
     */
    public function search(string $query): JsonResponse
    {
        try {
            $users = User::where('name', 'like', "%{$query}%")
                        ->orWhere('email', 'like', "%{$query}%")
                        ->get();

            return response()->json([
                'success' => true,
                'data' => $users,
                'message' => 'Users search completed successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Failed to search users: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get user statistics.
     */
    public function stats(): JsonResponse
    {
        try {
            $stats = [
                'total_users' => User::count(),
                'verified_users' => User::whereNotNull('email_verified_at')->count(),
                'recent_users' => User::where('created_at', '>=', now()->subDays(7))->count()
            ];

            return response()->json([
                'success' => true,
                'data' => $stats,
                'message' => 'User statistics retrieved successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'data' => null,
                'message' => 'Failed to retrieve user statistics: ' . $e->getMessage()
            ], 500);
        }
    }
}
```

### **Model Structure Pattern**

#### **Base Model Template**
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    /**
     * Get the posts for the user.
     */
    public function posts()
    {
        return $this->hasMany(Post::class);
    }

    /**
     * Get the comments for the user.
     */
    public function comments()
    {
        return $this->hasMany(Comment::class);
    }
}
```

### **Migration Structure Pattern**

#### **Base Migration Template**
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->rememberToken();
            $table->timestamps();
            
            // Add indexes for performance
            $table->index(['email']);
            $table->index(['created_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
```

### **API Route Pattern**

#### **Standard API Routes**
```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\PostController;

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

// Health check endpoint
Route::get('/health', function () {
    return response()->json([
        'status' => 'healthy',
        'timestamp' => now(),
        'service' => 'Laravel API',
        'version' => '1.0.0'
    ]);
});

// User management API routes
Route::apiResource('users', UserController::class);

// Additional user routes
Route::get('/users/search/{query}', [UserController::class, 'search']);
Route::get('/users/stats', [UserController::class, 'stats']);

// Post management API routes
Route::apiResource('posts', PostController::class);

// Additional post routes
Route::get('/posts/user/{user}', [PostController::class, 'getByUser']);
Route::get('/posts/search/{query}', [PostController::class, 'search']);

// Authentication routes (when implementing Sanctum)
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});
```

## ⚡ **NEXT.JS FRONTEND PATTERNS**

### **Page Component Pattern**

#### **Base Page Template**
```tsx
import { useState, useEffect } from 'react'
import Head from 'next/head'
import { User } from '@/types/user'

export default function HomePage() {
    const [users, setUsers] = useState<User[]>([])
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState<string | null>(null)

    useEffect(() => {
        fetchUsers()
    }, [])

    const fetchUsers = async () => {
        try {
            setLoading(true)
            setError(null)
            
            const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/users`)
            
            if (response.ok) {
                const data = await response.json()
                setUsers(data.data || [])
            } else {
                setError('Failed to fetch users')
            }
        } catch (err) {
            setError('Network error occurred')
        } finally {
            setLoading(false)
        }
    }

    if (loading) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                    <p className="mt-4 text-gray-600">Loading...</p>
                </div>
            </div>
        )
    }

    if (error) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <div className="text-center">
                    <div className="text-red-600 text-xl mb-4">⚠️ Error</div>
                    <p className="text-gray-600">{error}</p>
                    <button 
                        onClick={fetchUsers}
                        className="mt-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
                    >
                        Retry
                    </button>
                </div>
            </div>
        )
    }

    return (
        <>
            <Head>
                <title>Users - Laravel + Next.js App</title>
                <meta name="description" content="User management application" />
            </Head>

            <main className="min-h-screen bg-gray-50">
                <div className="container mx-auto px-4 py-8">
                    <div className="text-center mb-8">
                        <h1 className="text-4xl font-bold text-gray-900 mb-4">
                            👥 Users
                        </h1>
                        <p className="text-xl text-gray-600">
                            Manage your application users
                        </p>
                    </div>

                    <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                        {users.map(user => (
                            <UserCard key={user.id} user={user} />
                        ))}
                    </div>

                    {users.length === 0 && (
                        <div className="text-center py-12">
                            <p className="text-gray-500 text-lg">No users found</p>
                        </div>
                    )}
                </div>
            </main>
        </>
    )
}
```

### **Component Pattern**

#### **Base Component Template**
```tsx
import { User } from '@/types/user'

interface UserCardProps {
    user: User
    onEdit?: (user: User) => void
    onDelete?: (userId: number) => void
}

export default function UserCard({ user, onEdit, onDelete }: UserCardProps) {
    const handleEdit = () => {
        if (onEdit) {
            onEdit(user)
        }
    }

    const handleDelete = () => {
        if (onDelete && confirm('Are you sure you want to delete this user?')) {
            onDelete(user.id)
        }
    }

    return (
        <div className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
            <div className="flex items-center justify-between mb-4">
                <h3 className="text-xl font-semibold text-gray-900">
                    {user.name}
                </h3>
                <div className="flex space-x-2">
                    {onEdit && (
                        <button
                            onClick={handleEdit}
                            className="text-blue-600 hover:text-blue-800 text-sm font-medium"
                        >
                            Edit
                        </button>
                    )}
                    {onDelete && (
                        <button
                            onClick={handleDelete}
                            className="text-red-600 hover:text-red-800 text-sm font-medium"
                        >
                            Delete
                        </button>
                    )}
                </div>
            </div>

            <div className="space-y-2">
                <div className="flex items-center">
                    <span className="text-gray-500 w-20">Email:</span>
                    <span className="text-gray-900">{user.email}</span>
                </div>
                
                <div className="flex items-center">
                    <span className="text-gray-500 w-20">Status:</span>
                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                        user.email_verified_at 
                            ? 'bg-green-100 text-green-800' 
                            : 'bg-yellow-100 text-yellow-800'
                    }`}>
                        {user.email_verified_at ? 'Verified' : 'Pending'}
                    </span>
                </div>

                <div className="flex items-center">
                    <span className="text-gray-500 w-20">Created:</span>
                    <span className="text-gray-900">
                        {new Date(user.created_at).toLocaleDateString()}
                    </span>
                </div>
            </div>
        </div>
    )
}
```

### **TypeScript Interface Pattern**

#### **Base Type Definitions**
```typescript
// types/user.ts
export interface User {
    id: number
    name: string
    email: string
    email_verified_at: string | null
    created_at: string
    updated_at: string
}

// types/post.ts
export interface Post {
    id: number
    title: string
    content: string
    user_id: number
    user: User
    created_at: string
    updated_at: string
}

// types/api.ts
export interface ApiResponse<T> {
    success: boolean
    data: T
    message: string
}

export interface PaginatedResponse<T> {
    success: boolean
    data: T[]
    message: string
    pagination: {
        current_page: number
        last_page: number
        per_page: number
        total: number
    }
}

// types/common.ts
export interface LoadingState {
    loading: boolean
    error: string | null
}

export interface FormData {
    [key: string]: string | number | boolean | null
}
```

### **API Integration Pattern**

#### **Base API Service**
```typescript
// services/api.ts
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'

export class ApiService {
    private static async request<T>(
        endpoint: string, 
        options: RequestInit = {}
    ): Promise<ApiResponse<T>> {
        const url = `${API_BASE_URL}/api${endpoint}`
        
        const config: RequestInit = {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers,
            },
            ...options,
        }

        try {
            const response = await fetch(url, config)
            const data = await response.json()

            if (!response.ok) {
                throw new Error(data.message || 'API request failed')
            }

            return data
        } catch (error) {
            throw new Error(error instanceof Error ? error.message : 'Network error')
        }
    }

    // User API methods
    static async getUsers(): Promise<ApiResponse<User[]>> {
        return this.request<User[]>('/users')
    }

    static async getUser(id: number): Promise<ApiResponse<User>> {
        return this.request<User>(`/users/${id}`)
    }

    static async createUser(userData: Partial<User>): Promise<ApiResponse<User>> {
        return this.request<User>('/users', {
            method: 'POST',
            body: JSON.stringify(userData),
        })
    }

    static async updateUser(id: number, userData: Partial<User>): Promise<ApiResponse<User>> {
        return this.request<User>(`/users/${id}`, {
            method: 'PUT',
            body: JSON.stringify(userData),
        })
    }

    static async deleteUser(id: number): Promise<ApiResponse<null>> {
        return this.request<null>(`/users/${id}`, {
            method: 'DELETE',
        })
    }

    static async searchUsers(query: string): Promise<ApiResponse<User[]>> {
        return this.request<User[]>(`/users/search/${encodeURIComponent(query)}`)
    }

    static async getUserStats(): Promise<ApiResponse<any>> {
        return this.request<any>('/users/stats')
    }

    // Post API methods
    static async getPosts(): Promise<ApiResponse<Post[]>> {
        return this.request<Post[]>('/posts')
    }

    static async getPost(id: number): Promise<ApiResponse<Post>> {
        return this.request<Post>(`/posts/${id}`)
    }

    static async createPost(postData: Partial<Post>): Promise<ApiResponse<Post>> {
        return this.request<Post>('/posts', {
            method: 'POST',
            body: JSON.stringify(postData),
        })
    }

    static async updatePost(id: number, postData: Partial<Post>): Promise<ApiResponse<Post>> {
        return this.request<Post>(`/posts/${id}`, {
            method: 'PUT',
            body: JSON.stringify(postData),
        })
    }

    static async deletePost(id: number): Promise<ApiResponse<null>> {
        return this.request<null>(`/posts/${id}`, {
            method: 'DELETE',
        })
    }
}
```

### **Hook Pattern**

#### **Base Custom Hook**
```typescript
// hooks/useApi.ts
import { useState, useEffect } from 'react'
import { ApiService } from '@/services/api'
import { ApiResponse, LoadingState } from '@/types'

export function useApi<T>(
    apiCall: () => Promise<ApiResponse<T>>,
    dependencies: any[] = []
) {
    const [data, setData] = useState<T | null>(null)
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState<string | null>(null)

    useEffect(() => {
        const fetchData = async () => {
            try {
                setLoading(true)
                setError(null)
                
                const response = await apiCall()
                setData(response.data)
            } catch (err) {
                setError(err instanceof Error ? err.message : 'An error occurred')
            } finally {
                setLoading(false)
            }
        }

        fetchData()
    }, dependencies)

    const refetch = () => {
        setLoading(true)
        setError(null)
        apiCall()
            .then(response => setData(response.data))
            .catch(err => setError(err instanceof Error ? err.message : 'An error occurred'))
            .finally(() => setLoading(false))
    }

    return { data, loading, error, refetch }
}

// Specific hooks
export function useUsers() {
    return useApi(() => ApiService.getUsers())
}

export function useUser(id: number) {
    return useApi(() => ApiService.getUser(id), [id])
}

export function usePosts() {
    return useApi(() => ApiService.getPosts())
}

export function usePost(id: number) {
    return useApi(() => ApiService.getPost(id), [id])
}
```

## 🗄️ **DATABASE PATTERNS**

### **Seeder Pattern**

#### **Base Seeder Template**
```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create admin user
        User::create([
            'name' => 'Admin User',
            'email' => 'admin@example.com',
            'password' => Hash::make('password'),
            'email_verified_at' => now(),
        ]);

        // Create sample users
        $users = [
            [
                'name' => 'John Doe',
                'email' => 'john@example.com',
                'password' => Hash::make('password'),
                'email_verified_at' => now(),
            ],
            [
                'name' => 'Jane Smith',
                'email' => 'jane@example.com',
                'password' => Hash::make('password'),
                'email_verified_at' => now(),
            ],
            [
                'name' => 'Bob Johnson',
                'email' => 'bob@example.com',
                'password' => Hash::make('password'),
                'email_verified_at' => now(),
            ],
        ];

        foreach ($users as $userData) {
            User::create($userData);
        }
    }
}
```

### **Factory Pattern**

#### **Base Factory Template**
```php
<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\User>
 */
class UserFactory extends Factory
{
    /**
     * The current password being used by the factory.
     */
    protected static ?string $password;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->name(),
            'email' => fake()->unique()->safeEmail(),
            'email_verified_at' => now(),
            'password' => static::$password ??= Hash::make('password'),
            'remember_token' => Str::random(10),
        ];
    }

    /**
     * Indicate that the model's email address should be unverified.
     */
    public function unverified(): static
    {
        return $this->state(fn (array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
}
```

## 🎨 **STYLING PATTERNS**

### **Tailwind CSS Classes**

#### **Common Component Classes**
```tsx
// Card component
<div className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">

// Button variants
<button className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition-colors">
<button className="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors">
<button className="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 transition-colors">

// Form inputs
<input className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" />

// Layout containers
<div className="container mx-auto px-4 py-8">
<div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
<div className="flex items-center justify-between">
<div className="text-center">
<div className="space-y-4">

// Text styles
<h1 className="text-4xl font-bold text-gray-900 mb-4">
<p className="text-xl text-gray-600">
<span className="text-sm text-gray-500">
<div className="text-red-600 text-lg">
```

## 🔒 **SECURITY PATTERNS**

### **Validation Pattern**

#### **Laravel Request Validation**
```php
// In controller methods
$validated = $request->validate([
    'name' => 'required|string|max:255',
    'email' => 'required|email|unique:users,email',
    'password' => 'required|string|min:8|confirmed',
    'age' => 'nullable|integer|min:18|max:120',
    'terms' => 'required|accepted',
]);

// Custom validation rules
$validated = $request->validate([
    'email' => [
        'required',
        'email',
        'unique:users,email,' . $user->id,
        'max:255'
    ],
    'password' => [
        'required',
        'string',
        'min:8',
        'regex:/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/',
        'confirmed'
    ],
]);
```

### **CORS Configuration**

#### **Laravel CORS Setup**
```php
// config/cors.php
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['http://localhost:3000', 'https://yourdomain.com'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

## 📱 **RESPONSIVE DESIGN PATTERNS**

### **Breakpoint Classes**
```tsx
// Mobile first approach
<div className="w-full md:w-1/2 lg:w-1/3">
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
<div className="text-sm md:text-base lg:text-lg">
<div className="p-4 md:p-6 lg:p-8">
<div className="hidden md:block">
<div className="md:hidden">
```

## 🧪 **TESTING PATTERNS**

### **Laravel Test Pattern**
```php
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

class UserApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_users(): void
    {
        User::factory()->count(3)->create();

        $response = $this->getJson('/api/users');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'success',
                    'data',
                    'message'
                ])
                ->assertJson([
                    'success' => true,
                    'message' => 'Users retrieved successfully'
                ]);

        $this->assertCount(3, $response->json('data'));
    }

    public function test_can_create_user(): void
    {
        $userData = [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123'
        ];

        $response = $this->postJson('/api/users', $userData);

        $response->assertStatus(201)
                ->assertJson([
                    'success' => true,
                    'message' => 'User created successfully'
                ]);

        $this->assertDatabaseHas('users', [
            'name' => 'Test User',
            'email' => 'test@example.com'
        ]);
    }
}
```

---

**📝 These code patterns represent the exact conventions and structures used in this project. AI agents should follow these patterns precisely when adding new features or modifying existing code to maintain consistency and quality.**
