@echo off
REM 🚀 Laravel + MySQL + Next.js Full Stack Docker Setup Script for Windows
REM This script will set up everything you need from scratch!

echo 🚀 Welcome to Laravel + MySQL + Next.js Full Stack Setup!
echo ==========================================================

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop first!
    pause
    exit /b 1
)

echo ✅ Docker is running

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not available. Please install Docker Desktop with Compose support.
    pause
    exit /b 1
)

echo ✅ Docker Compose is available

REM Check if Composer is available
composer --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Composer is not installed. Please install Composer first:
    echo    Visit: https://getcomposer.org/download/
    echo.
    echo After installing Composer, run this script again.
    pause
    exit /b 1
)

echo ✅ Composer is available

REM Check if Node.js is available
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Node.js is not installed. Please install Node.js first:
    echo    Visit: https://nodejs.org/
    echo.
    echo After installing Node.js, run this script again.
    pause
    exit /b 1
)

echo ✅ Node.js is available

REM Clean up any existing setup
echo 🧹 Cleaning up any existing setup...
if exist "laravel" rmdir /s /q laravel
if exist "next" rmdir /s /q next
if exist "docker-compose.yml" del docker-compose.yml

REM Create project structure
echo 📁 Creating project structure...
if not exist "laravel" mkdir laravel
if not exist "mysql" mkdir mysql
if not exist "mysql\init" mkdir mysql\init
if not exist "next" mkdir next

REM Create Laravel project
echo 🎯 Creating Laravel project...
cd laravel
composer create-project laravel/laravel . --prefer-dist --no-interaction

REM Create .env file
echo ⚙️  Creating .env file...
(
echo APP_NAME="Laravel + Next.js Full Stack"
echo APP_ENV=local
echo APP_KEY=
echo APP_DEBUG=true
echo APP_URL=http://localhost:8000
echo LOG_CHANNEL=stack
echo LOG_LEVEL=debug
echo CACHE_DRIVER=file
echo SESSION_DRIVER=file
echo QUEUE_CONNECTION=sync
echo DB_CONNECTION=mysql
echo DB_HOST=db
echo DB_PORT=3306
echo DB_DATABASE=app
echo DB_USERNAME=app
echo DB_PASSWORD=app
echo CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
) > .env

cd ..

REM Create Next.js project
echo ⚡ Creating Next.js project...
cd next

REM Create package.json with proper Next.js configuration
(
echo {
echo   "name": "laravel-next-frontend",
echo   "version": "0.1.0",
echo   "private": true,
echo   "scripts": {
echo     "dev": "next dev",
echo     "build": "next build",
echo     "start": "next start",
echo     "lint": "next lint"
echo   },
echo   "dependencies": {
echo     "next": "14.0.0",
echo     "react": "^18",
echo     "react-dom": "^18",
echo     "axios": "^1.6.0"
echo   },
echo   "devDependencies": {
echo     "@types/node": "^20",
echo     "@types/react": "^18",
echo     "@types/react-dom": "^18",
echo     "eslint": "^8",
echo     "eslint-config-next": "14.0.0",
echo     "typescript": "^5"
echo   }
echo }
) > package.json

REM Install dependencies
npm install

REM Create Next.js configuration files
echo ⚙️  Creating Next.js configuration...
(
echo /** @type {import^('next'^).NextConfig} */
echo const nextConfig = {
echo   reactStrictMode: true,
echo   swcMinify: true,
echo   env: {
echo     NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL ^|^| 'http://localhost:8000',
echo   },
echo   async rewrites^(^) {
echo     const apiUrl = process.env.NEXT_PUBLIC_API_URL ^|^| 'http://localhost:8000';
echo     return [
echo       {
echo         source: '/api/:path*',
echo         destination: `$^{apiUrl}/api/:path*`,
echo       },
echo     ]
echo   },
echo }
echo.
echo module.exports = nextConfig
) > next.config.js

REM Create TypeScript configuration
(
echo {
echo   "compilerOptions": {
echo     "target": "es5",
echo     "lib": ["dom", "dom.iterable", "es6"],
echo     "allowJs": true,
echo     "skipLibCheck": true,
echo     "strict": true,
echo     "noEmit": true,
echo     "esModuleInterop": true,
echo     "module": "esnext",
echo     "moduleResolution": "bundler",
echo     "resolveJsonModule": true,
echo     "isolatedModules": true,
echo     "jsx": "preserve",
echo     "incremental": true,
echo     "plugins": [
echo       {
echo         "name": "next"
echo       }
echo     ],
echo     "baseUrl": ".",
echo     "paths": {
echo       "@/*": ["./*"]
echo     }
echo   },
echo   "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
echo   "exclude": ["node_modules"]
echo }
) > tsconfig.json

REM Create pages directory and index page
if not exist "pages" mkdir pages
(
echo import { useState, useEffect } from 'react'
echo import Head from 'next/head'
echo.
echo interface User {
echo   id: number
echo   name: string
echo   email: string
echo   created_at: string
echo }
echo.
echo export default function Home^(^) {
echo   const [users, setUsers] = useState^<User[]^>^([]^)
echo   const [loading, setLoading] = useState^(true^)
echo   const [error, setError] = useState^<string ^| null^>^(null^)
echo.
echo   useEffect^(^(^) =^> {
echo     fetchUsers^(^)
echo   }, []^)
echo.
echo   const fetchUsers = async ^(^) =^> {
echo     try {
echo       const response = await fetch^(`$^{process.env.NEXT_PUBLIC_API_URL}/api/users`^)
echo       if ^(response.ok^) {
echo         const data = await response.json^(^)
echo         setUsers^(data.data ^|^| []^)
echo       } else {
echo         setError^('Failed to fetch users'^)
echo       }
echo     } catch ^(err^) {
echo       setError^('Error connecting to API'^)
echo     } finally {
echo       setLoading^(false^)
echo     }
echo   }
echo.
echo   return ^(
echo     ^<^>
echo       ^<Head^>
echo         ^<title^>Laravel + Next.js Full Stack App^</title^>
echo         ^<meta name="description" content="Full stack application with Laravel API and Next.js frontend" /^>
echo         ^<meta name="viewport" content="width=device-width, initial-scale=1" /^>
echo         ^<link rel="icon" href="/favicon.ico" /^>
echo       ^</Head^>
echo       ^<main className="min-h-screen bg-gray-50"^>
echo         ^<div className="container mx-auto px-4 py-8"^>
echo           ^<div className="text-center mb-8"^>
echo             ^<h1 className="text-4xl font-bold text-gray-900 mb-4"^>
echo               🚀 Laravel + Next.js Full Stack
echo             ^</h1^>
echo             ^<p className="text-xl text-gray-600"^>
echo               Modern full-stack development with Laravel API and Next.js frontend
echo             ^</p^>
echo           ^</div^>
echo           ^<div className="text-center text-gray-600"^>
echo             ^<p^>Your Next.js frontend is ready! Check the Laravel API at ^<a href="http://localhost:8000" className="text-blue-600 hover:underline"^>http://localhost:8000^</a^>^</p^>
echo           ^</div^>
echo         ^</div^>
echo       ^</main^>
echo     ^</^>
echo   ^)
echo }
) > pages\index.tsx

cd ..

REM Create Docker Compose file
echo 🐳 Creating docker-compose.yml...
(
echo services:
echo   db:
echo     image: mysql:8.0
echo     container_name: myapp-db
echo     command: --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
echo     environment:
echo       MYSQL_DATABASE: app
echo       MYSQL_USER: app
echo       MYSQL_PASSWORD: app
echo       MYSQL_ROOT_PASSWORD: root
echo     ports:
echo       - "3306:3306"
echo     volumes:
echo       - db_data:/var/lib/mysql
echo       - ./mysql/init:/docker-entrypoint-initdb.d
echo     healthcheck:
echo       test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-proot"]
echo       interval: 5s
echo       timeout: 3s
echo       retries: 20
echo     restart: unless-stopped
echo.
echo   laravel:
echo     build:
echo       context: ./laravel
echo     container_name: myapp-laravel
echo     ports:
echo       - "8000:8000"
echo     volumes:
echo       - ./laravel:/var/www
echo     environment:
echo       DB_CONNECTION: mysql
echo       DB_HOST: db
echo       DB_PORT: 3306
echo       DB_DATABASE: app
echo       DB_USERNAME: app
echo       DB_PASSWORD: app
echo       CORS_ALLOWED_ORIGINS: "http://localhost:3000,http://127.0.0.1:3000"
echo     depends_on:
echo       db:
echo         condition: service_healthy
echo     restart: unless-stopped
echo.
echo   next:
echo     build:
echo       context: ./next
echo     container_name: myapp-next
echo     ports:
echo       - "3000:3000"
echo     volumes:
echo       - ./next:/app
echo       - /app/node_modules
echo       - /app/.next
echo     environment:
echo       NEXT_PUBLIC_API_URL: http://localhost:8000
echo       NEXT_PUBLIC_APP_NAME: "Laravel + Next.js App"
echo     depends_on:
echo       - laravel
echo     restart: unless-stopped
echo.
echo   phpmyadmin:
echo     image: phpmyadmin/phpmyadmin:latest
echo     container_name: myapp-phpmyadmin
echo     ports:
echo       - "8080:80"
echo     environment:
echo       PMA_HOST: db
echo       PMA_PORT: 3306
echo       PMA_USER: app
echo       PMA_PASSWORD: app
echo       MYSQL_ROOT_PASSWORD: root
echo     depends_on:
echo       db:
echo         condition: service_healthy
echo     restart: unless-stopped
echo.
echo volumes:
echo   db_data:
echo.
echo networks:
echo   default:
echo     name: myapp_net
) > docker-compose.yml

REM Create Laravel Dockerfile
echo 🐳 Creating Laravel Dockerfile...
(
echo FROM php:8.2-cli
echo.
echo # Install system dependencies and PHP extensions
echo RUN apt-get update ^&^& apt-get install -y \
echo     unzip \
echo     git \
echo     curl \
echo     libpng-dev \
echo     libonig-dev \
echo     libxml2-dev \
echo     zip \
echo     ^&^& docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd
echo.
echo # Install Composer
echo COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer
echo.
echo WORKDIR /var/www
echo.
echo # Install dependencies if composer.json exists ^(Laravel project already present^)
echo RUN if [ ! -f "composer.json" ]; then \
echo     composer install --no-interaction --no-dev --optimize-autoloader; \
echo     fi
echo.
echo EXPOSE 8000
echo CMD php artisan serve --host=0.0.0.0 --port=8000
) > laravel\Dockerfile

REM Create Next.js Dockerfile
echo 🐳 Creating Next.js Dockerfile...
(
echo FROM node:18-alpine
echo.
echo # Set working directory
echo WORKDIR /app
echo.
echo # Copy package files
echo COPY package*.json ./
echo.
echo # Install dependencies
echo RUN npm ci --only=production
echo.
echo # Copy source code
echo COPY . .
echo.
echo # Build the application
echo RUN npm run build
echo.
echo # Expose port
echo EXPOSE 3000
echo.
echo # Start the application
echo CMD ["npm", "start"]
) > next\Dockerfile

REM Create MySQL initialization script
echo 🗄️  Creating MySQL initialization script...
(
echo -- Sample data for the users table
echo INSERT INTO users ^(name, email, email_verified_at, password, remember_token, created_at, updated_at^) VALUES
echo ^('John Doe', 'john@example.com', NOW^(^), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW^(^), NOW^(^)^),
echo ^('Jane Smith', 'jane@example.com', NOW^(^), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW^(^), NOW^(^)^),
echo ^('Bob Johnson', 'bob@example.com', NOW^(^), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW^(^), NOW^(^)^),
echo ^('Alice Brown', 'alice@example.com', NOW^(^), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW^(^), NOW^(^)^),
echo ^('Charlie Wilson', 'charlie@example.com', NOW^(^), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, NOW^(^), NOW^(^)^);
echo.
echo -- Sample data for the cache table
echo INSERT INTO cache ^(key, value, expiration^) VALUES
echo ^('app_settings', '{"theme":"light","language":"en"}', UNIX_TIMESTAMP^(^) + 3600^);
) > mysql\init\01-sample-data.sql

REM Update Laravel API routes
echo 🛣️  Updating Laravel API routes...
(
echo ^<?php
echo.
echo use Illuminate\Http\Request;
echo use Illuminate\Support\Facades\Route;
echo use App\Http\Controllers\Api\UserController;
echo.
echo /*
echo |--------------------------------------------------------------------------
echo | API Routes
echo |--------------------------------------------------------------------------
echo |
echo | Here is where you can register API routes for your application. These
echo | routes are loaded by the RouteServiceProvider and all of them will
echo | be assigned to the "api" middleware group. Make something great!
echo |
echo */
echo.
echo Route::middleware^('auth:sanctum'^)->get^('/user', function ^(Request $request^) {
echo     return $request->user^(^);
echo }^);
echo.
echo // Public API routes
echo Route::get^('/health', function ^(^) {
echo     return response^()->json^([
echo         'status' => 'healthy',
echo         'timestamp' => now^(^),
echo         'service' => 'Laravel API',
echo         'version' => '1.0.0'
echo     ]^);
echo }^);
echo.
echo // User management API routes
echo Route::apiResource^('users', UserController::class^);
echo.
echo // Additional user routes
echo Route::get^('/users/search/{query}', [UserController::class, 'search']^);
echo Route::get^('/users/stats', [UserController::class, 'stats']^);
) > laravel\routes\api.php

REM Fix Laravel 11 bootstrap/app.php to include API routes
echo 🔧 Fixing Laravel 11 bootstrap configuration...
powershell -Command "(Get-Content laravel\bootstrap\app.php) -replace '->withRouting\(', '->withRouting(`n        api: __DIR__.\"\/..\/routes\/api.php\",' | Set-Content laravel\bootstrap\app.php"

echo 🔨 Building Docker containers...
docker-compose build

echo 🚀 Starting services...
docker-compose up -d

echo ⏳ Waiting for MySQL to be ready...
timeout /t 30 /nobreak >nul

echo 🔑 Generating Laravel application key...
docker-compose exec laravel php artisan key:generate

echo 🗄️  Running database migrations...
docker-compose exec laravel php artisan migrate --force

echo.
echo 🎉 Full Stack Setup Complete! 🎉
echo ==================================
echo.
echo Your full-stack application is now running at:
echo 🌐 Laravel API: http://localhost:8000
echo ⚡ Next.js Frontend: http://localhost:3000
echo 🗄️  MySQL Database: localhost:3306
echo 🔧 phpMyAdmin: http://localhost:8080
echo.
echo Useful commands:
echo   Start services: docker-compose up -d
echo   Stop services:  docker-compose down
echo   View logs:      docker-compose logs
echo   Check status:   docker-compose ps
echo.
echo Happy full-stack coding! 🚀
pause
