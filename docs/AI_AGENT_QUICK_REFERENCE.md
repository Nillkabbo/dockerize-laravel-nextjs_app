# 🤖 AI AGENT QUICK REFERENCE - Laravel + Next.js + MySQL Ecosystem

## 🚀 **IMMEDIATE STARTUP COMMANDS**

### **Check Current State**
```bash
# Always start here to understand what's running
docker-compose ps
docker-compose logs laravel
docker-compose logs next
docker-compose logs db
```

### **Quick Health Check**
```bash
# Test if everything is working
curl http://localhost:8000/api/health
curl http://localhost:3000
docker-compose exec db mysqladmin ping
```

## 🎯 **ECOSYSTEM QUICK FACTS**

- **Backend**: Laravel 12 API on port 8000
- **Frontend**: Next.js 14 on port 3000  
- **Database**: MySQL 8.0 on port 3306
- **Admin**: phpMyAdmin on port 8080
- **Network**: All services communicate via `myapp_net` Docker network

## 🔧 **COMMON OPERATIONS FOR AI AGENTS**

### **Adding New API Endpoints**

#### **1. Create Model & Migration**
```bash
docker-compose exec laravel php artisan make:model Post -m
```

#### **2. Edit Migration File**
```php
// In the generated migration file
Schema::create('posts', function (Blueprint $table) {
    $table->id();
    $table->string('title');
    $table->text('content');
    $table->foreignId('user_id')->constrained()->onDelete('cascade');
    $table->timestamps();
});
```

#### **3. Create Controller**
```bash
docker-compose exec laravel php artisan make:controller Api/PostController --api
```

#### **4. Add Routes**
```php
// In laravel/routes/api.php
Route::apiResource('posts', PostController::class);
```

#### **5. Run Migration**
```bash
docker-compose exec laravel php artisan migrate
```

### **Adding New Frontend Features**

#### **1. Create Component**
```tsx
// Create next/components/PostCard.tsx
export default function PostCard({ post }: { post: Post }) {
    return (
        <div className="bg-white p-6 rounded-lg shadow-md">
            <h3 className="text-xl font-semibold">{post.title}</h3>
            <p className="text-gray-600 mt-2">{post.content}</p>
        </div>
    )
}
```

#### **2. Add to Page**
```tsx
// In next/pages/index.tsx or create new page
import PostCard from '@/components/PostCard'
```

#### **3. Update Types**
```typescript
// Add to your TypeScript interfaces
interface Post {
    id: number
    title: string
    content: string
    user_id: number
    created_at: string
}
```

### **Database Operations**

#### **Connect to MySQL**
```bash
docker-compose exec db mysql -u app -papp
```

#### **Check Tables**
```sql
SHOW TABLES;
DESCRIBE users;
SELECT * FROM users LIMIT 5;
```

#### **Run Laravel Commands**
```bash
# Check migration status
docker-compose exec laravel php artisan migrate:status

# Run migrations
docker-compose exec laravel php artisan migrate

# Create seeder
docker-compose exec laravel php artisan make:seeder PostSeeder
```

## 🐛 **TROUBLESHOOTING QUICK FIXES**

### **API Not Working**
```bash
# Clear Laravel caches
docker-compose exec laravel php artisan config:clear
docker-compose exec laravel php artisan route:clear

# Check if API routes are loaded
docker-compose exec laravel php artisan route:list

# Verify bootstrap/app.php has API routes
docker-compose exec laravel cat bootstrap/app.php | grep "api:"
```

### **Frontend Build Issues**
```bash
# Check package.json scripts
docker-compose exec next cat package.json

# Reinstall dependencies
docker-compose exec next rm -rf node_modules package-lock.json
docker-compose exec next npm install

# Rebuild container
docker-compose restart next
```

### **Database Issues**
```bash
# Check MySQL health
docker-compose ps db

# Restart database
docker-compose restart db

# Check .env configuration
docker-compose exec laravel cat .env | grep DB_
```

### **Container Won't Start**
```bash
# Check logs
docker-compose logs [service-name]

# Check port conflicts
lsof -i :8000
lsof -i :3000
lsof -i :3306
lsof -i :8080

# Reset everything (nuclear option)
docker-compose down -v
rm -rf laravel next
rm -f docker-compose.yml
./setup.sh
./after_setup.sh
```

## 📊 **DEVELOPMENT WORKFLOW PATTERNS**

### **Standard Feature Addition**
1. **Backend**: Model → Migration → Controller → Routes → Test
2. **Frontend**: Component → Page → Types → API Integration → Test
3. **Database**: Schema → Migration → Seeder → Test

### **Bug Fixing Process**
1. **Identify**: Check logs, reproduce issue
2. **Isolate**: Frontend/Backend/Database?
3. **Fix**: Apply solution following established patterns
4. **Test**: Verify fix works
5. **Document**: Update relevant files

### **Update Process**
1. **Check**: Review changelogs
2. **Test**: Test in development
3. **Update**: Apply following workflow
4. **Verify**: Ensure functionality works
5. **Deploy**: Follow deployment checklist

## 🔍 **MONITORING COMMANDS**

### **Service Status**
```bash
# All services
docker-compose ps

# Specific service logs
docker-compose logs -f laravel
docker-compose logs -f next
docker-compose logs -f db

# Resource usage
docker stats
```

### **Application Health**
```bash
# API health
curl http://localhost:8000/api/health

# Frontend status
curl http://localhost:3000

# Database connection
docker-compose exec db mysqladmin ping
```

### **Performance Check**
```bash
# Container resources
docker stats

# Disk usage
docker system df

# Network inspection
docker network inspect myapp_net
```

## 🎯 **AI AGENT BEST PRACTICES**

### **Always Do This First**
1. **Check current state**: `docker-compose ps`
2. **Read recent logs**: `docker-compose logs [service]`
3. **Verify health**: Test endpoints with curl
4. **Understand context**: Check what's already implemented

### **When Making Changes**
1. **Follow established patterns** from existing code
2. **Use consistent naming** conventions
3. **Maintain API response format**: `{success, data, message}`
4. **Update both frontend and backend** when adding features
5. **Test changes** before considering complete

### **When Troubleshooting**
1. **Start with logs** - they usually contain the answer
2. **Check one service at a time** - isolate the problem
3. **Use health check commands** - verify each service
4. **Follow the troubleshooting workflow** - don't skip steps
5. **Document solutions** - help future AI agents

### **Code Quality Standards**
1. **Laravel**: Follow PSR-12, use type hints, return JsonResponse
2. **Next.js**: Use TypeScript, follow React best practices, use Tailwind CSS
3. **Database**: Use migrations, follow naming conventions, add indexes
4. **API**: Consistent response format, proper HTTP status codes, validation

## 🚨 **EMERGENCY COMMANDS**

### **Complete Reset**
```bash
# Stop everything
docker-compose down -v

# Remove all files
rm -rf laravel next
rm -f docker-compose.yml

# Start fresh
./setup.sh
./after_setup.sh
```

### **Quick Restart**
```bash
# Restart specific service
docker-compose restart laravel
docker-compose restart next
docker-compose restart db

# Restart all
docker-compose restart
```

### **Force Rebuild**
```bash
# Rebuild specific service
docker-compose up --build -d laravel
docker-compose up --build -d next

# Rebuild all
docker-compose up --build -d
```

---

**🤖 This quick reference gives AI agents everything they need to immediately start working with this ecosystem. For detailed information, refer to PROJECT_BRAIN.md.**
