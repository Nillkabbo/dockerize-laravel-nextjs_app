#!/bin/bash

echo "🚀 Starting Development Environment with Hot Reload..."

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Start development environment
echo "🔧 Starting development environment..."
docker-compose -f docker-compose.dev.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Show status
echo "📊 Development Environment Status:"
docker-compose -f docker-compose.dev.yml ps

echo ""
echo "✅ Development environment is ready!"
echo ""
echo "🌐 Access Points:"
echo "   Frontend (Next.js): http://localhost:3000"
echo "   Backend (Laravel):  http://localhost:8000"
echo "   Database:           http://localhost:8080"
echo ""
echo "📝 Development Features:"
echo "   ✅ Hot reload enabled - changes reflect immediately"
echo "   ✅ Source code mounted as volumes"
echo "   ✅ No rebuild required for code changes"
echo "   ✅ Fast development iteration"
echo ""
echo "🔄 To restart development environment:"
echo "   ./scripts/dev.sh"
echo ""
echo "🛑 To stop development environment:"
echo "   docker-compose -f docker-compose.dev.yml down"
