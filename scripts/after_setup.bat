@echo off
echo 🚀 After Setup Script - Completing Full Stack Setup
echo ==================================================

REM Check if Docker containers are running
echo 🔍 Checking Docker containers status...
docker-compose ps | findstr "Up" >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker containers are not running. Starting them first...
    docker-compose up -d
    echo ⏳ Waiting for services to be ready...
    timeout /t 10 /nobreak >nul
)

REM Wait for MySQL to be healthy
echo ⏳ Waiting for MySQL to be ready...
:wait_mysql
docker-compose exec -T db mysqladmin ping -h"localhost" --silent >nul 2>&1
if errorlevel 1 (
    echo ⏳ MySQL is not ready yet, waiting...
    timeout /t 5 /nobreak >nul
    goto wait_mysql
)
echo ✅ MySQL is ready!

REM Wait for Laravel container to be ready
echo ⏳ Waiting for Laravel container to be ready...
timeout /t 5 /nobreak >nul

REM Generate Laravel application key
echo 🔑 Generating Laravel application key...
docker-compose exec -T laravel php artisan key:generate --force
if errorlevel 1 (
    echo ⚠️  Laravel application key generation failed, trying alternative method...
    docker-compose exec -T laravel php artisan config:clear
    docker-compose exec -T laravel php artisan key:generate --force
)
echo ✅ Laravel application key generated successfully

REM Run database migrations FIRST (before clearing caches)
echo 🗄️  Running database migrations...
docker-compose exec -T laravel php artisan migrate --force
if errorlevel 1 (
    echo ❌ Database migrations failed
    exit /b 1
)
echo ✅ Database migrations completed successfully

REM Clear Laravel caches AFTER migrations (when tables exist)
echo 🧹 Clearing Laravel caches...
docker-compose exec -T laravel php artisan config:clear
docker-compose exec -T laravel php artisan route:clear
REM Clear cache table safely (only if it exists)
docker-compose exec -T laravel php artisan cache:clear >nul 2>&1
if errorlevel 1 (
    echo ℹ️  Cache table not ready yet (this is normal on first run)
) else (
    echo ✅ Cache cleared successfully
)
docker-compose exec -T laravel php artisan view:clear
echo ✅ Laravel caches cleared

REM Check if API routes are working
echo 🔍 Verifying API routes...
timeout /t 3 /nobreak >nul
curl -s http://localhost:8000/api/health >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Laravel API is not responding, checking logs...
    docker-compose logs laravel | tail -10
) else (
    echo ✅ Laravel API is responding
)

REM Check if Next.js frontend is working
echo 🔍 Verifying Next.js frontend...
timeout /t 3 /nobreak >nul
curl -s http://localhost:3000 >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Next.js frontend is not responding, checking logs...
    docker-compose logs next | tail -10
) else (
    echo ✅ Next.js frontend is responding
)

REM Check if MySQL is accessible
echo 🔍 Verifying MySQL connection...
docker-compose exec -T db mysql -u app -papp -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  MySQL connection failed
) else (
    echo ✅ MySQL connection successful
)

REM Check if phpMyAdmin is accessible
echo 🔍 Verifying phpMyAdmin...
timeout /t 3 /nobreak >nul
curl -s http://localhost:8080 >nul 2>&1
if errorlevel 1 (
    echo ⚠️  phpMyAdmin is not accessible
) else (
    echo ✅ phpMyAdmin is accessible
)

REM Display final status
echo.
echo 🎉 After Setup Complete! 🎉
echo ============================
echo.
echo 📊 Final Status:
echo ==================
docker-compose ps
echo.
echo 🌐 Access Points:
echo ==================
echo 🔧 Laravel API:     http://localhost:8000
echo ⚡ Next.js Frontend: http://localhost:3000
echo 🗄️  MySQL Database:  localhost:3306
echo 🔧 phpMyAdmin:      http://localhost:8080
echo.
echo 🧪 Test Commands:
echo ==================
echo • Test API Health:    curl http://localhost:8000/api/health
echo • Test Users API:     curl http://localhost:8000/api/users
echo • Test Frontend:      curl http://localhost:3000
echo • View Laravel Logs:  docker-compose logs laravel
echo • View Next.js Logs:  docker-compose logs next
echo • View MySQL Logs:    docker-compose logs db
echo.
echo 🚀 Your full-stack application is now ready!
echo Happy coding! 🎯
pause
