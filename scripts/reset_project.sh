#!/bin/bash

echo "🧹 Project Reset Script - Safe Cleanup"
echo "======================================"
echo ""

# Confirmation prompt
echo "⚠️  WARNING: This will remove:"
echo "   • This project's Docker containers"
echo "   • This project's Docker volumes"
echo "   • This project's Docker networks"
echo "   • Laravel project files"
echo "   • Next.js project files"
echo "   • Docker Compose configuration"
echo "   • Database data (will be lost!)"
echo ""
echo "✅ SAFE: Will NOT affect other Docker projects"
echo ""
read -p "🤔 Are you sure you want to continue? (yes/no): " confirm

if [[ $confirm != "yes" ]]; then
    echo "❌ Reset cancelled. Your project is safe."
    exit 0
fi

echo ""
echo "🚀 Starting safe project reset..."
echo ""

# Stop and remove only this project's containers
echo "🛑 Stopping and removing this project's containers..."
if [ -f "docker-compose.yml" ]; then
    docker-compose down -v
    echo "✅ Project containers stopped and removed"
else
    echo "ℹ️  No docker-compose.yml found, no containers to stop"
fi

# Remove only this project's directories
echo "🗑️  Removing project directories..."
if [ -d "laravel" ]; then
    rm -rf laravel
    echo "✅ Laravel directory removed"
fi

if [ -d "next" ]; then
    rm -rf next
    echo "✅ Next.js directory removed"
fi

# Remove Docker Compose file
echo "🗑️  Removing Docker Compose configuration..."
if [ -f "docker-compose.yml" ]; then
    rm -f docker-compose.yml
    echo "✅ Docker Compose file removed"
fi

# Clean up only unused resources (safe for other projects)
echo "🧹 Cleaning up unused Docker resources..."
echo "   • Removing unused containers (this project only)..."
docker container prune -f --filter "label=com.docker.compose.project=laravel_next_mysql_play" >/dev/null 2>&1 || true

echo "   • Removing unused networks (this project only)..."
docker network prune -f --filter "label=com.docker.compose.project=laravel_next_mysql_play" >/dev/null 2>&1 || true

echo "   • Removing unused volumes (this project only)..."
docker volume prune -f --filter "label=com.docker.compose.project=laravel_next_mysql_play" >/dev/null 2>&1 || true

echo "✅ Docker resources cleaned (this project only)"

# Check what's left
echo ""
echo "📁 Current directory contents:"
echo "================================"
ls -la | grep -E "(\.sh|\.bat|\.md|mysql|docs)" || echo "No project files found"

echo ""
echo "🎉 Project Reset Complete! 🎉"
echo "=============================="
echo ""
echo "✅ What was removed:"
echo "   • This project's Docker containers and services"
echo "   • This project's project source code (Laravel + Next.js)"
echo "   • This project's Docker volumes and data"
echo "   • This project's Docker Compose configuration"
echo ""
echo "✅ What remains:"
echo "   • Setup scripts (scripts/ folder)"
echo "   • Documentation (docs/ folder)"
echo "   • MySQL initialization scripts (mysql/ folder)"
echo "   • README and other markdown files"
echo "   • Other Docker projects (unaffected)"
echo ""
echo "🚀 To start fresh:"
echo "   • Run: ./scripts/setup.sh"
echo "   • Then: ./scripts/after_setup.sh"
echo ""
echo "💡 Tip: Other Docker projects on your system are safe!"
echo "Happy coding! 🎯"
