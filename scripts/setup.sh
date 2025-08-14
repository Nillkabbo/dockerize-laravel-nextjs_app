#!/bin/bash

# 🚀 Laravel + MySQL + Next.js Full Stack Docker Setup Script
# This script will set up everything you need from scratch!

echo "🚀 Welcome to Laravel + MySQL + Next.js Full Stack Setup!"
echo "=========================================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first!"
    exit 1
fi

echo "✅ Docker is running"

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Desktop with Compose support."
    exit 1
fi

echo "✅ Docker Compose is available"

# Clean up any existing setup
echo "🧹 Cleaning up any existing setup..."
rm -rf laravel next
rm -f docker-compose.yml

# Create project structure
echo "📁 Creating project structure..."
mkdir -p laravel mysql/init next

# Check if Composer is available
if ! command -v composer &> /dev/null; then
    echo "⚠️  Composer is not installed. Please install Composer first:"
    echo "   Visit: https://getcomposer.org/download/"
    echo ""
    echo "After installing Composer, run this script again."
    exit 1
fi

echo "✅ Composer is available"

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "⚠️  Node.js is not installed. Please install Node.js first:"
    echo "   Visit: https://nodejs.org/"
    echo ""
    echo "After installing Node.js, run this script again."
    exit 1
fi

echo "✅ Node.js is available"

# Create Laravel project FIRST (before Dockerfile)
echo "🎯 Creating Laravel project..."
cd laravel
composer create-project laravel/laravel . --prefer-dist --no-interaction

# Create .env file with APP_KEY placeholder
echo "⚙️  Creating .env file..."
cat > .env << 'EOF'
APP_NAME="Laravel + Next.js Full Stack"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000
LOG_CHANNEL=stack
LOG_LEVEL=debug
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=app
DB_USERNAME=app
DB_PASSWORD=app
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
EOF

cd ..

# Create Next.js project
echo "⚡ Creating Next.js project..."
cd next

# Create package.json with proper Next.js configuration
cat > package.json << 'EOF'
{
  "name": "laravel-next-frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "^18",
    "react-dom": "^18",
    "axios": "^1.6.0"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "eslint": "^8",
    "eslint-config-next": "14.0.0",
    "typescript": "^5"
  }
}
EOF

# Install dependencies
npm install

# Create Next.js configuration files
echo "⚙️  Creating Next.js configuration..."
cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  env: {
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000',
  },
  async rewrites() {
    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';
    return [
      {
        source: '/api/:path*',
        destination: `${apiUrl}/api/:path*`,
      },
    ]
  },
}

module.exports = nextConfig
EOF

# Create TypeScript configuration
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

# Create pages directory and index page
mkdir -p pages
cat > pages/index.tsx << 'EOF'
import { useState, useEffect } from 'react'
import Head from 'next/head'

interface User {
  id: number
  name: string
  email: string
  created_at: string
}

export default function Home() {
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetchUsers()
  }, [])

  const fetchUsers = async () => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/users`)
      if (response.ok) {
        const data = await response.json()
        setUsers(data.data || [])
      } else {
        setError('Failed to fetch users')
      }
    } catch (err) {
      setError('Error connecting to API')
    } finally {
      setLoading(false)
    }
  }

  return (
    <>
      <Head>
        <title>Laravel + Next.js Full Stack App</title>
        <meta name="description" content="Full stack application with Laravel API and Next.js frontend" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main className="min-h-screen bg-gray-50">
        <div className="container mx-auto px-4 py-8">
          <div className="text-center mb-8">
            <h1 className="text-4xl font-bold text-gray-900 mb-4">
              🚀 Laravel + Next.js Full Stack
            </h1>
            <p className="text-xl text-gray-600">
              Modern full-stack development with Laravel API and Next.js frontend
            </p>
          </div>

          <div className="grid md:grid-cols-2 gap-8 mb-8">
            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-2xl font-semibold text-gray-800 mb-4">🔧 Backend (Laravel)</h2>
              <ul className="text-gray-600 space-y-2">
                <li>• RESTful API endpoints</li>
                <li>• MySQL database integration</li>
                <li>• Authentication & authorization</li>
                <li>• Database migrations & seeders</li>
                <li>• API resource controllers</li>
              </ul>
            </div>

            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-2xl font-semibold text-gray-800 mb-4">⚡ Frontend (Next.js)</h2>
              <ul className="text-gray-600 space-y-2">
                <li>• React 18 with TypeScript</li>
                <li>• Server-side rendering (SSR)</li>
                <li>• API integration with Laravel</li>
                <li>• Responsive design</li>
                <li>• Modern development experience</li>
              </ul>
            </div>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-md">
            <h2 className="text-2xl font-semibold text-gray-800 mb-4">👥 Users from Laravel API</h2>
            {loading && (
              <div className="text-center py-8">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
                <p className="mt-4 text-gray-600">Loading users...</p>
              </div>
            )}
            
            {error && (
              <div className="text-center py-8">
                <div className="text-red-600 mb-4">⚠️ {error}</div>
                <p className="text-gray-600">Make sure your Laravel API is running and has users data.</p>
              </div>
            )}

            {!loading && !error && users.length === 0 && (
              <div className="text-center py-8">
                <p className="text-gray-600">No users found. Create some users in your Laravel application first.</p>
              </div>
            )}

            {!loading && !error && users.length > 0 && (
              <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Created</th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {users.map((user) => (
                      <tr key={user.id}>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{user.id}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{user.name}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{user.email}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                          {new Date(user.created_at).toLocaleDateString()}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>

          <div className="mt-8 text-center text-gray-600">
            <p>Check out the <a href="http://localhost:8080" className="text-blue-600 hover:underline">phpMyAdmin</a> to manage your MySQL database</p>
          </div>
        </div>
      </main>
    </>
  )
}
EOF

cd ..

# Create Docker Compose file
echo "🐳 Creating docker-compose.yml..."
cat > docker-compose.yml << 'EOF'
services:
  db:
    image: mysql:8.0
    container_name: myapp-db
    command: --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    environment:
      MYSQL_DATABASE: app
      MYSQL_USER: app
      MYSQL_PASSWORD: app
      MYSQL_ROOT_PASSWORD: root
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
      - ./mysql/init:/docker-entrypoint-initdb.d
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-proot"]
      interval: 5s
      timeout: 3s
      retries: 20
    restart: unless-stopped

  laravel:
    build:
      context: ./laravel
    container_name: myapp-laravel
    ports:
      - "8000:8000"
    volumes:
      - ./laravel:/var/www
    environment:
      DB_CONNECTION: mysql
      DB_HOST: db
      DB_PORT: 3306
      DB_DATABASE: app
      DB_USERNAME: app
      DB_PASSWORD: app
      CORS_ALLOWED_ORIGINS: "http://localhost:3000,http://127.0.0.1:3000"
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  next:
    build:
      context: ./next
    container_name: myapp-next
    ports:
      - "3000:3000"
    volumes:
      - ./next:/app
      - /app/node_modules
      - /app/.next
    environment:
      NEXT_PUBLIC_API_URL: http://localhost:8000
      NEXT_PUBLIC_APP_NAME: "Laravel + Next.js App"
    depends_on:
      - laravel
    restart: unless-stopped

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    container_name: myapp-phpmyadmin
    ports:
      - "8080:80"
    environment:
      PMA_HOST: db
      PMA_PORT: 3306
      PMA_USER: app
      PMA_PASSWORD: app
      MYSQL_ROOT_PASSWORD: root
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

volumes:
  db_data:

networks:
  default:
    name: myapp_net
EOF

# Create Laravel Dockerfile AFTER Laravel project is created
echo "🐳 Creating Laravel Dockerfile..."
cat > laravel/Dockerfile << 'EOF'
FROM php:8.2-cli

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Install dependencies if composer.json exists (Laravel project already present)
RUN if [ -f "composer.json" ]; then \
    composer install --no-interaction --no-dev --optimize-autoloader; \
    fi

EXPOSE 8000
CMD php artisan serve --host=0.0.0.0 --port=8000
EOF

# Create Next.js Dockerfile
echo "🐳 Creating Next.js Dockerfile..."
cat > next/Dockerfile << 'EOF'
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
EOF

# Create MySQL initialization script
echo "🗄️  Creating MySQL initialization script..."
cat > mysql/init/01-sample-data.sql << 'EOF'
-- Sample data for the users table
INSERT INTO users (name, email, email_verified_at, password, remember_token, created_at, updated_at) VALUES
('John Doe', 'john@example.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW(), NOW()),
('Jane Smith', 'jane@example.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW(), NOW()),
('Bob Johnson', 'bob@example.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW(), NOW()),
('Alice Brown', 'alice@example.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW(), NOW()),
('Charlie Wilson', 'charlie@example.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW(), NOW());

-- Sample data for the cache table
INSERT INTO cache (key, value, expiration) VALUES
('app_settings', '{"theme":"light","language":"en"}', UNIX_TIMESTAMP() + 3600);
EOF

# Create Laravel API controller
echo "🔧 Creating Laravel API controller..."
mkdir -p laravel/app/Http/Controllers/Api
cat > laravel/app/Http/Controllers/Api/UserController.php << 'EOF'
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    /**
     * Display a listing of the users.
     */
    public function index(): JsonResponse
    {
        $users = User::select('id', 'name', 'email', 'created_at')
                    ->orderBy('created_at', 'desc')
                    ->get();

        return response()->json([
            'success' => true,
            'data' => $users,
            'message' => 'Users retrieved successfully'
        ]);
    }

    /**
     * Store a newly created user in storage.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => bcrypt($request->password),
        ]);

        return response()->json([
            'success' => true,
            'data' => $user->only(['id', 'name', 'email', 'created_at']),
            'message' => 'User created successfully'
        ], 201);
    }

    /**
     * Display the specified user.
     */
    public function show(User $user): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $user->only(['id', 'name', 'email', 'created_at']),
            'message' => 'User retrieved successfully'
        ]);
    }

    /**
     * Update the specified user in storage.
     */
    public function update(Request $request, User $user): JsonResponse
    {
        $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|string|email|max:255|unique:users,email,' . $user->id,
        ]);

        $user->update($request->only(['name', 'email']));

        return response()->json([
            'success' => true,
            'data' => $user->only(['id', 'name', 'email', 'created_at']),
            'message' => 'User updated successfully'
        ]);
    }

    /**
     * Remove the specified user from storage.
     */
    public function destroy(User $user): JsonResponse
    {
        $user->delete();

        return response()->json([
            'success' => true,
            'message' => 'User deleted successfully'
        ]);
    }
}
EOF

# Update Laravel API routes
echo "🛣️  Updating Laravel API routes..."
cat > laravel/routes/api.php << 'EOF'
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;

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

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Public API routes
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
EOF

# Fix Laravel 11 bootstrap/app.php to include API routes
echo "🔧 Fixing Laravel 11 bootstrap configuration..."
sed -i '' 's/->withRouting(/->withRouting(\n        api: __DIR__.\"\/..\/routes\/api.php\",/' laravel/bootstrap/app.php

echo "🔨 Building Docker containers..."
docker-compose build

echo "🚀 Starting services..."
docker-compose up -d

echo "⏳ Waiting for MySQL to be ready..."
sleep 30

echo "🔑 Generating Laravel application key..."
docker-compose exec laravel php artisan key:generate

echo "🗄️  Running database migrations..."
docker-compose exec laravel php artisan migrate --force

echo ""
echo "🎉 Full Stack Setup Complete! 🎉"
echo "=================================="
echo ""
echo "Your full-stack application is now running at:"
echo "🌐 Laravel API: http://localhost:8000"
echo "⚡ Next.js Frontend: http://localhost:3000"
echo "🗄️  MySQL Database: localhost:3306"
echo "🔧 phpMyAdmin: http://localhost:8080"
echo ""
echo "Useful commands:"
echo "  Start services: docker-compose up -d"
echo "  Stop services:  docker-compose down"
echo "  View logs:      docker-compose logs"
echo "  Check status:   docker-compose ps"
echo ""
echo "Happy full-stack coding! 🚀"
