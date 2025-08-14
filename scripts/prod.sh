#!/bin/bash

echo "🚀 Starting Production Environment..."

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Build and start production environment
echo "🔧 Building and starting production environment..."
docker-compose -f docker-compose.prod.yml up -d --build

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 15

# Show status
echo "📊 Production Environment Status:"
docker-compose -f docker-compose.prod.yml ps

echo ""
echo "✅ Production environment is ready!"
echo ""
echo "🌐 Access Points:"
echo "   Frontend (Next.js): http://localhost:3000"
echo "   Backend (Laravel):  http://localhost:8000"
echo "   Database:           http://localhost:8080"
echo ""
echo "📝 Production Features:"
echo "   ✅ Optimized builds for performance"
echo "   ✅ Production-ready configurations"
echo "   ✅ Security hardened settings"
echo "   ✅ Efficient resource usage"
echo ""
echo "🔄 To restart production environment:"
echo "   ./scripts/prod.sh"
echo ""
echo "🛑 To stop production environment:"
echo "   docker-compose -f docker-compose.prod.yml down"
