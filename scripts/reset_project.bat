@echo off
echo 🧹 Project Reset Script - Safe Cleanup
echo ======================================
echo.

REM Confirmation prompt
echo ⚠️  WARNING: This will remove:
echo    • This project's Docker containers
echo    • This project's Docker volumes
echo    • This project's Docker networks
echo    • Laravel project files
echo    • Next.js project files
echo    • Docker Compose configuration
echo    • Database data (will be lost!)
echo.
echo ✅ SAFE: Will NOT affect other Docker projects
echo.
set /p confirm="🤔 Are you sure you want to continue? (yes/no): "

if /i not "%confirm%"=="yes" (
    echo ❌ Reset cancelled. Your project is safe.
    exit /b 0
)

echo.
echo 🚀 Starting safe project reset...
echo.

REM Stop and remove only this project's containers
echo 🛑 Stopping and removing this project's containers...
if exist "docker-compose.yml" (
    docker-compose down -v
    echo ✅ Project containers stopped and removed
) else (
    echo ℹ️  No docker-compose.yml found, no containers to stop
)

REM Remove only this project's directories
echo 🗑️  Removing project directories...
if exist "laravel" (
    rmdir /s /q laravel
    echo ✅ Laravel directory removed
)

if exist "next" (
    rmdir /s /q next
    echo ✅ Next.js directory removed
)

REM Remove Docker Compose file
echo 🗑️  Removing Docker Compose configuration...
if exist "docker-compose.yml" (
    del /f docker-compose.yml
    echo ✅ Docker Compose file removed
)

REM Clean up only unused resources (safe for other projects)
echo 🧹 Cleaning up unused Docker resources...
echo    • Removing unused containers (this project only)...
docker container prune -f --filter "label=com.docker.compose.project=laravel_next_mysql_play" >nul 2>&1

echo    • Removing unused networks (this project only)...
docker network prune -f --filter "label=com.docker.compose.project=laravel_next_mysql_play" >nul 2>&1

echo    • Removing unused volumes (this project only)...
docker volume prune -f --filter "label=com.docker.compose.project=laravel_next_mysql_play" >nul 2>&1

echo ✅ Docker resources cleaned (this project only)

REM Check what's left
echo.
echo 📁 Current directory contents:
echo ================================
dir /b | findstr /i "\.sh \.bat \.md mysql docs" 2>nul || echo No project files found

echo.
echo 🎉 Project Reset Complete! 🎉
echo ==============================
echo.
echo ✅ What was removed:
echo    • This project's Docker containers and services
echo    • This project's project source code (Laravel + Next.js)
echo    • This project's Docker volumes and data
echo    • This project's Docker Compose configuration
echo.
echo ✅ What remains:
echo    • Setup scripts (scripts/ folder)
echo    • Documentation (docs/ folder)
echo    • MySQL initialization scripts (mysql/ folder)
echo    • README and other markdown files
echo    • Other Docker projects (unaffected)
echo.
echo 🚀 To start fresh:
echo    • Run: scripts\setup.bat
echo    • Then: scripts\after_setup.bat
echo.
echo 💡 Tip: Other Docker projects on your system are safe!
echo Happy coding! 🎯
pause
