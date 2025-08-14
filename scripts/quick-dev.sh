#!/bin/bash

echo "⚡ Quick Development Restart (Frontend Only)..."

# Check if development environment is running
if ! docker-compose -f docker-compose.dev.yml ps | grep -q "myapp-next-dev"; then
    echo "❌ Development environment not running. Use './scripts/dev.sh' first."
    exit 1
fi

# Restart only the frontend container
echo "🔄 Restarting frontend container..."
docker-compose -f docker-compose.dev.yml restart next

echo "✅ Frontend restarted! Changes should be reflected immediately."
echo ""
echo "🌐 Frontend: http://localhost:3000"
echo "📝 Hot reload is active - edit files and see changes instantly!"
