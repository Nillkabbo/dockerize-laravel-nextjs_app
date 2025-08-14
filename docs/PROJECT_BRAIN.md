# 🧠 PROJECT BRAIN - Laravel + Next.js + MySQL Full Stack Ecosystem

## 🎯 **ECOSYSTEM OVERVIEW**

This is a **production-ready, containerized full-stack development ecosystem** featuring:
- **Backend**: Laravel 12 API with RESTful endpoints
- **Frontend**: Next.js 14 with React 18 and TypeScript
- **Database**: MySQL 8.0 with migrations and sample data
- **Infrastructure**: Docker Compose orchestration with health checks
- **Management**: phpMyAdmin for database administration

## 🏗️ **ARCHITECTURE PATTERNS**

### **Service Architecture**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Next.js 14    │    │   Laravel 12    │    │   MySQL 8.0     │
│   Frontend      │◄──►│   API Backend   │◄──►│   Database      │
│   Port: 3000    │    │   Port: 8000    │    │   Port: 3306    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   phpMyAdmin    │
                    │   Port: 8080    │
                    └─────────────────┘
```

### **Data Flow Pattern**
1. **Frontend** → **Laravel API** → **MySQL Database**
2. **API Responses** → **Frontend State Management**
3. **Database Changes** → **API Updates** → **Frontend Re-renders**

### **Container Communication**
- **Frontend ↔ Backend**: HTTP/HTTPS via Docker network
- **Backend ↔ Database**: MySQL protocol via Docker network
- **All services**: Isolated but interconnected via `myapp_net`

## 📁 **PROJECT STRUCTURE & PURPOSE**

### **Root Level Files**
```
laravel_next_mysql_play/
├── 🚀 setup.sh                 # Initial setup automation (Unix)
├── 🚀 setup.bat                # Initial setup automation (Windows)
├── 🧠 after_setup.sh           # Configuration completion (Unix)
├── 🧠 after_setup.bat          # Configuration completion (Windows)
├── 📚 PROJECT_BRAIN.md         # This file - AI agent knowledge base
├── 📖 SETUP_GUIDE.md           # Human-readable setup instructions
├── 📖 README.md                # Project overview and quick start
├── 🔧 QUICK_REFERENCE.md       # Development commands reference
├── 🚨 TROUBLESHOOTING.md       # Common issues and solutions
├── 🐳 docker-compose.yml       # Service orchestration
├── 🎯 laravel/                 # Laravel backend application
├── ⚡ next/                    # Next.js frontend application
└── 🗄️ mysql/                   # Database initialization
```

### **Laravel Backend Structure**
```
laravel/
├── app/
│   ├── Http/Controllers/Api/   # API controllers (RESTful)
│   │   └── UserController.php  # User management CRUD
│   ├── Models/                 # Eloquent models
│   │   └── User.php           # User model with relationships
│   └── Providers/              # Service providers
├── routes/
│   └── api.php                # API route definitions
├── database/
│   ├── migrations/            # Database schema migrations
│   └── seeders/              # Sample data population
├── .env                       # Environment configuration
└── Dockerfile                 # Container definition
```

### **Next.js Frontend Structure**
```
next/
├── pages/                     # Next.js pages (file-based routing)
│   ├── _app.tsx              # App wrapper component
│   ├── index.tsx             # Home page with user list
│   └── api/                  # API routes (if needed)
├── components/                # Reusable React components
├── styles/                    # CSS and styling
├── public/                    # Static assets
├── package.json              # Dependencies and scripts
├── next.config.js            # Next.js configuration
├── tsconfig.json             # TypeScript configuration
└── Dockerfile                # Container definition
```

### **Database Structure**
```
mysql/
├── init/                      # Initialization scripts
│   └── 01-sample-data.sql    # Sample data insertion
└── data/                      # Persistent data storage (Docker volume)
```

## 🔧 **DEVELOPMENT PATTERNS & BEST PRACTICES**

### **Laravel API Patterns**

#### **Controller Structure**
```php
<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    public function index(): JsonResponse
    {
        $users = User::all();
        return response()->json([
            'success' => true,
            'data' => $users,
            'message' => 'Users retrieved successfully'
        ]);
    }
    
    // Standard CRUD methods: store, show, update, destroy
}
```

#### **API Response Format**
```json
{
    "success": true,
    "data": [...],
    "message": "Operation completed successfully"
}
```

#### **Route Definition Pattern**
```php
// Resource routes for CRUD operations
Route::apiResource('users', UserController::class);

// Custom routes for specific functionality
Route::get('/users/search/{query}', [UserController::class, 'search']);
Route::get('/users/stats', [UserController::class, 'stats']);
```

### **Next.js Frontend Patterns**

#### **Component Structure**
```tsx
import { useState, useEffect } from 'react'
import { User } from '@/types/user'

interface UserListProps {
    users: User[]
    loading: boolean
    error: string | null
}

export default function UserList({ users, loading, error }: UserListProps) {
    if (loading) return <LoadingSpinner />
    if (error) return <ErrorMessage message={error} />
    
    return (
        <div className="user-list">
            {users.map(user => (
                <UserCard key={user.id} user={user} />
            ))}
        </div>
    )
}
```

#### **API Integration Pattern**
```tsx
const [users, setUsers] = useState<User[]>([])
const [loading, setLoading] = useState(true)
const [error, setError] = useState<string | null>(null)

useEffect(() => {
    fetchUsers()
}, [])

const fetchUsers = async () => {
    try {
        setLoading(true)
        const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/users`)
        if (response.ok) {
            const data = await response.json()
            setUsers(data.data || [])
        } else {
            setError('Failed to fetch users')
        }
    } catch (err) {
        setError('Network error')
    } finally {
        setLoading(false)
    }
}
```

#### **TypeScript Interface Definitions**
```typescript
interface User {
    id: number
    name: string
    email: string
    email_verified_at: string | null
    created_at: string
    updated_at: string
}

interface ApiResponse<T> {
    success: boolean
    data: T
    message: string
}
```

### **Database Patterns**

#### **Migration Structure**
```php
<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->rememberToken();
            $table->timestamps();
        });
    }
    
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
```

#### **Model Relationships**
```php
<?php
namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Authenticatable
{
    protected $fillable = [
        'name', 'email', 'password',
    ];
    
    protected $hidden = [
        'password', 'remember_token',
    ];
    
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];
    
    // Define relationships here
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }
}
```

## 🚀 **FEATURE DEVELOPMENT WORKFLOW**

### **Adding New API Endpoints**

#### **Step 1: Create Model & Migration**
```bash
docker-compose exec laravel php artisan make:model Post -m
```

#### **Step 2: Define Migration Schema**
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

#### **Step 3: Create Controller**
```bash
docker-compose exec laravel php artisan make:controller Api/PostController --api
```

#### **Step 4: Implement Controller Methods**
```php
public function index(): JsonResponse
{
    $posts = Post::with('user')->paginate(10);
    return response()->json([
        'success' => true,
        'data' => $posts,
        'message' => 'Posts retrieved successfully'
    ]);
}
```

#### **Step 5: Add Routes**
```php
// In routes/api.php
Route::apiResource('posts', PostController::class);
```

#### **Step 6: Update Frontend**
```tsx
// Add to types
interface Post {
    id: number
    title: string
    content: string
    user_id: number
    user: User
    created_at: string
}

// Add to API calls
const fetchPosts = async () => {
    const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/posts`)
    // Handle response
}
```

### **Adding New Frontend Features**

#### **Step 1: Create Component**
```tsx
// components/PostCard.tsx
export default function PostCard({ post }: { post: Post }) {
    return (
        <div className="bg-white p-6 rounded-lg shadow-md">
            <h3 className="text-xl font-semibold">{post.title}</h3>
            <p className="text-gray-600 mt-2">{post.content}</p>
            <div className="text-sm text-gray-500 mt-4">
                By {post.user.name} on {new Date(post.created_at).toLocaleDateString()}
            </div>
        </div>
    )
}
```

#### **Step 2: Add to Page**
```tsx
// pages/posts.tsx
import PostCard from '@/components/PostCard'

export default function PostsPage() {
    // Implementation
}
```

#### **Step 3: Update Navigation**
```tsx
// Add navigation links as needed
<Link href="/posts" className="text-blue-600 hover:underline">
    View Posts
</Link>
```

## 🐛 **BUG FIXING WORKFLOW**

### **Common Issues & Solutions**

#### **Laravel API Issues**

**Problem**: API routes not responding
```bash
# Solution 1: Clear route cache
docker-compose exec laravel php artisan route:clear

# Solution 2: Check if API routes are loaded
docker-compose exec laravel php artisan route:list

# Solution 3: Verify bootstrap/app.php has API routes
# Should include: api: __DIR__.'/../routes/api.php'
```

**Problem**: Database connection errors
```bash
# Solution 1: Check MySQL health
docker-compose ps db

# Solution 2: Restart database
docker-compose restart db

# Solution 3: Check .env configuration
docker-compose exec laravel cat .env | grep DB_
```

**Problem**: Application key missing
```bash
# Solution: Generate new key
docker-compose exec laravel php artisan key:generate
```

#### **Next.js Frontend Issues**

**Problem**: Build failures
```bash
# Solution 1: Check package.json scripts
docker-compose exec next cat package.json

# Solution 2: Reinstall dependencies
docker-compose exec next rm -rf node_modules package-lock.json
docker-compose exec next npm install

# Solution 3: Rebuild container
docker-compose down
docker-compose up --build -d
```

**Problem**: API calls failing
```bash
# Solution 1: Check environment variables
docker-compose exec next cat .env.local

# Solution 2: Verify API is accessible
curl http://localhost:8000/api/health

# Solution 3: Check CORS configuration in Laravel
```

#### **Docker Issues**

**Problem**: Container won't start
```bash
# Solution 1: Check logs
docker-compose logs [service-name]

# Solution 2: Check port conflicts
lsof -i :8000
lsof -i :3000
lsof -i :3306
lsof -i :8080

# Solution 3: Reset everything
docker-compose down -v
rm -rf laravel next
rm -f docker-compose.yml
./setup.sh
./after_setup.sh
```

### **Debugging Commands**

#### **Service Health Checks**
```bash
# Check all services
docker-compose ps

# Check specific service logs
docker-compose logs laravel
docker-compose logs next
docker-compose logs db

# Check service health
docker-compose exec db mysqladmin ping
curl http://localhost:8000/api/health
curl http://localhost:3000
```

#### **Database Debugging**
```bash
# Connect to MySQL
docker-compose exec db mysql -u app -papp

# Check tables
SHOW TABLES;

# Check data
SELECT * FROM users;

# Check migrations
docker-compose exec laravel php artisan migrate:status
```

## 🔄 **UPDATE & MAINTENANCE WORKFLOW**

### **Updating Dependencies**

#### **Laravel Updates**
```bash
# Update Composer dependencies
docker-compose exec laravel composer update

# Update Laravel framework
docker-compose exec laravel composer update laravel/framework

# Check for updates
docker-compose exec laravel composer outdated
```

#### **Next.js Updates**
```bash
# Update npm packages
docker-compose exec next npm update

# Update specific packages
docker-compose exec next npm install next@latest react@latest

# Check for updates
docker-compose exec next npm outdated
```

#### **Docker Updates**
```bash
# Update base images
docker-compose pull

# Rebuild with new images
docker-compose up --build -d
```

### **Security Updates**

#### **Laravel Security**
```bash
# Check for security vulnerabilities
docker-compose exec laravel composer audit

# Update packages with security fixes
docker-compose exec laravel composer update --with-dependencies
```

#### **Node.js Security**
```bash
# Check for security vulnerabilities
docker-compose exec next npm audit

# Fix security issues
docker-compose exec next npm audit fix

# Force fix (may break things)
docker-compose exec next npm audit fix --force
```

### **Performance Optimization**

#### **Laravel Optimization**
```bash
# Optimize for production
docker-compose exec laravel php artisan config:cache
docker-compose exec laravel php artisan route:cache
docker-compose exec laravel php artisan view:cache

# Clear caches for development
docker-compose exec laravel php artisan config:clear
docker-compose exec laravel php artisan route:clear
docker-compose exec laravel php artisan view:clear
```

#### **Next.js Optimization**
```bash
# Build for production
docker-compose exec next npm run build

# Analyze bundle
docker-compose exec next npm run build -- --analyze
```

## 📊 **TESTING STRATEGIES**

### **Laravel Testing**
```bash
# Run PHPUnit tests
docker-compose exec laravel php artisan test

# Run specific test
docker-compose exec laravel php artisan test --filter UserTest

# Generate test coverage
docker-compose exec laravel php artisan test --coverage
```

### **Next.js Testing**
```bash
# Run Jest tests
docker-compose exec next npm test

# Run tests in watch mode
docker-compose exec next npm run test:watch

# Run tests with coverage
docker-compose exec next npm run test:coverage
```

### **Integration Testing**
```bash
# Test API endpoints
curl -X GET http://localhost:8000/api/users
curl -X POST http://localhost:8000/api/users -H "Content-Type: application/json" -d '{"name":"Test","email":"test@example.com"}'

# Test frontend
curl http://localhost:3000
```

## 🚀 **DEPLOYMENT CONSIDERATIONS**

### **Production Environment Variables**
```bash
# Laravel .env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://yourdomain.com
DB_HOST=production-db-host
DB_DATABASE=production_db
DB_USERNAME=production_user
DB_PASSWORD=strong_password

# Next.js .env.local
NEXT_PUBLIC_API_URL=https://api.yourdomain.com
NODE_ENV=production
```

### **Docker Production Configuration**
```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  laravel:
    build: ./laravel
    environment:
      - APP_ENV=production
      - APP_DEBUG=false
    restart: unless-stopped
    
  next:
    build: ./next
    environment:
      - NODE_ENV=production
    restart: unless-stopped
```

### **Database Production Setup**
```bash
# Use external MySQL/PostgreSQL
# Set up proper backups
# Configure replication if needed
# Use managed database services (AWS RDS, Google Cloud SQL)
```

## 🔍 **MONITORING & LOGGING**

### **Application Logs**
```bash
# Laravel logs
docker-compose exec laravel tail -f storage/logs/laravel.log

# Next.js logs
docker-compose logs -f next

# MySQL logs
docker-compose logs -f db
```

### **Performance Monitoring**
```bash
# Check container resource usage
docker stats

# Check disk usage
docker system df

# Check network usage
docker network ls
docker network inspect myapp_net
```

## 🎯 **AI AGENT QUICK REFERENCE**

### **When Adding Features:**
1. **Backend**: Create model → migration → controller → routes → test
2. **Frontend**: Create component → add to page → update types → test
3. **Database**: Design schema → create migration → seed data → test

### **When Fixing Bugs:**
1. **Identify**: Check logs, reproduce issue
2. **Isolate**: Determine if frontend, backend, or database issue
3. **Fix**: Apply solution following established patterns
4. **Test**: Verify fix works and doesn't break other features
5. **Document**: Update relevant documentation

### **When Updating:**
1. **Check**: Review changelogs and security advisories
2. **Test**: Test updates in development environment
3. **Update**: Apply updates following established workflow
4. **Verify**: Ensure all functionality still works
5. **Deploy**: Deploy to production following deployment checklist

### **Key Commands for AI Agents:**
```bash
# Always start with these to understand current state
docker-compose ps
docker-compose logs [service-name]

# Use these for common operations
docker-compose exec laravel php artisan [command]
docker-compose exec next npm [command]
docker-compose exec db mysql -u app -papp

# Use these for troubleshooting
docker-compose down -v
./setup.sh
./after_setup.sh
```

---

**🧠 This PROJECT_BRAIN serves as the central knowledge base for any AI agent working with this ecosystem. It provides patterns, workflows, and best practices to ensure consistent, high-quality development and maintenance.**
