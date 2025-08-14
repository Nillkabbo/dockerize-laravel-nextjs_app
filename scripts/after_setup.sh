#!/bin/bash

echo "🚀 After Setup Script - Completing Full Stack Setup"
echo "=================================================="

# Check if Docker containers are running
echo "🔍 Checking Docker containers status..."
if ! docker-compose ps | grep -q "Up"; then
    echo "❌ Docker containers are not running. Starting them first..."
    docker-compose up -d
    echo "⏳ Waiting for services to be ready..."
    sleep 10
fi

# Wait for MySQL to be healthy
echo "⏳ Waiting for MySQL to be ready..."
while ! docker-compose exec -T db mysqladmin ping -h"localhost" --silent; do
    echo "⏳ MySQL is not ready yet, waiting..."
    sleep 5
done
echo "✅ MySQL is ready!"

# Wait for Laravel container to be ready
echo "⏳ Waiting for Laravel container to be ready..."
sleep 5

# Generate Laravel application key
echo "🔑 Generating Laravel application key..."
if docker-compose exec -T laravel php artisan key:generate --force; then
    echo "✅ Laravel application key generated successfully"
else
    echo "⚠️  Laravel application key generation failed, trying alternative method..."
    docker-compose exec -T laravel php artisan config:clear
    docker-compose exec -T laravel php artisan key:generate --force
fi

# Run database migrations FIRST (before clearing caches)
echo "🗄️  Running database migrations..."
if docker-compose exec -T laravel php artisan migrate --force; then
    echo "✅ Database migrations completed successfully"
else
    echo "❌ Database migrations failed"
    exit 1
fi

# Clear Laravel caches AFTER migrations (when tables exist)
echo "🧹 Clearing Laravel caches..."
docker-compose exec -T laravel php artisan config:clear
docker-compose exec -T laravel php artisan route:clear
# Clear cache table safely (only if it exists)
if docker-compose exec -T laravel php artisan cache:clear 2>/dev/null; then
    echo "✅ Cache cleared successfully"
else
    echo "ℹ️  Cache table not ready yet (this is normal on first run)"
fi
docker-compose exec -T laravel php artisan view:clear
echo "✅ Laravel caches cleared"

# Check if API routes are working
echo "🔍 Verifying API routes..."
sleep 3
if curl -s http://localhost:8000/api/health > /dev/null; then
    echo "✅ Laravel API is responding"
else
    echo "⚠️  Laravel API is not responding, checking logs..."
    docker-compose logs laravel | tail -10
fi

# Check if Next.js frontend is working
echo "🔍 Verifying Next.js frontend..."
sleep 3
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Next.js frontend is responding"
else
    echo "⚠️  Next.js frontend is not responding, checking logs..."
    docker-compose logs next | tail -10
fi

# Check if MySQL is accessible
echo "🔍 Verifying MySQL connection..."
if docker-compose exec -T db mysql -u app -papp -e "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ MySQL connection successful"
else
    echo "⚠️  MySQL connection failed"
fi

# Check if phpMyAdmin is accessible
echo "🔍 Verifying phpMyAdmin..."
sleep 3
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ phpMyAdmin is accessible"
else
    echo "⚠️  phpMyAdmin is not accessible"
fi

# Display final status
echo ""
echo "🎉 After Setup Complete! 🎉"
echo "============================"
echo ""
echo "📊 Final Status:"
echo "=================="
docker-compose ps
echo ""
echo "🌐 Access Points:"
echo "=================="
echo "🔧 Laravel API:     http://localhost:8000"
echo "⚡ Next.js Frontend: http://localhost:3000"
echo "🗄️  MySQL Database:  localhost:3306"
echo "🔧 phpMyAdmin:      http://localhost:8080"
echo ""
echo "🧪 Test Commands:"
echo "=================="
echo "• Test API Health:    curl http://localhost:8000/api/health"
echo "• Test Users API:     curl http://localhost:8000/api/users"
echo "• Test Frontend:      curl http://localhost:3000"
echo "• View Laravel Logs:  docker-compose logs laravel"
echo "• View Next.js Logs:  docker-compose logs next"
echo "• View MySQL Logs:    docker-compose logs db"
echo ""
echo "🚀 Your full-stack application is now ready!"
echo "Happy coding! 🎯"
