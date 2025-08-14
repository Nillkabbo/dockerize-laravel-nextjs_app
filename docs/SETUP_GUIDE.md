# 🚀 Complete Setup Guide for Laravel + Next.js + MySQL Full Stack

This guide will walk you through setting up a complete full-stack development environment with Laravel API, Next.js frontend, MySQL database, and phpMyAdmin.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
- **Git** - [Download here](https://git-scm.com/downloads)
- **Node.js** (v18 or higher) - [Download here](https://nodejs.org/)
- **Composer** (for PHP dependency management) - [Download here](https://getcomposer.org/)

## 🎯 Quick Start (Recommended)

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd laravel_next_mysql_play
```

### 2. Run the Initial Setup
```bash
# On macOS/Linux
./scripts/setup.sh

# On Windows
scripts\setup.bat
```

### 3. Run the After Setup Script
```bash
# On macOS/Linux
./scripts/after_setup.sh

# On Windows
scripts\after_setup.bat
```

**That's it!** Your full-stack application will be ready in minutes! 🎉

## 🔧 Detailed Setup Process

### Phase 1: Initial Setup (`setup.sh` / `setup.bat`)

The initial setup script performs the following tasks:

1. **🧹 Cleanup**: Removes any existing setup
2. **📁 Project Structure**: Creates necessary directories
3. **🎯 Laravel Project**: Creates a fresh Laravel 12 project
4. **⚡ Next.js Project**: Sets up Next.js 14 with React 18 and TypeScript
5. **🐳 Docker Configuration**: Creates all necessary Docker files
6. **🔧 API Setup**: Creates UserController and API endpoints
7. **🗄️ Database Setup**: Creates MySQL initialization scripts
8. **🏗️ Container Building**: Builds all Docker images
9. **🚀 Service Orchestration**: Starts all services

### Phase 2: After Setup (`after_setup.sh` / `after_setup.bat`)

The after setup script completes the remaining configuration:

1. **🔍 Health Checks**: Verifies all containers are running
2. **⏳ Service Readiness**: Waits for MySQL to be healthy
3. **🔑 Laravel Setup**: Generates application key and clears caches
4. **🗄️ Database Migration**: Runs Laravel migrations
5. **✅ Verification**: Tests all services and endpoints
6. **📊 Status Report**: Shows final status and access points

## 🌐 What You Get

After running both scripts, you'll have:

### Backend (Laravel 12)
- **API Endpoints**: RESTful API with user management
- **Database**: MySQL 8.0 with migrations
- **Authentication**: Ready for Laravel Sanctum
- **CORS**: Configured for frontend communication

### Frontend (Next.js 14)
- **React 18**: Latest React with TypeScript
- **Tailwind CSS**: Modern, responsive design
- **API Integration**: Ready to connect with Laravel
- **Hot Reloading**: Fast development experience

### Infrastructure
- **Docker**: Containerized development environment
- **MySQL**: Production-ready database
- **phpMyAdmin**: Database management interface
- **Networking**: Proper service communication

## 🚀 Access Points

Once setup is complete, you can access:

- **🌐 Laravel API**: http://localhost:8000
- **⚡ Next.js Frontend**: http://localhost:3000
- **🗄️ MySQL Database**: localhost:3306
- **🔧 phpMyAdmin**: http://localhost:8080

## 🧪 Testing Your Setup

### Test API Endpoints
```bash
# Health check
curl http://localhost:8000/api/health

# Users endpoint
curl http://localhost:8000/api/users

# Frontend
curl http://localhost:3000
```

### View Logs
```bash
# Laravel logs
docker-compose logs laravel

# Next.js logs
docker-compose logs next

# MySQL logs
docker-compose logs db
```

## 🔄 Development Workflow

### Starting Services
```bash
docker-compose up -d
```

### Stopping Services
```bash
docker-compose down
```

### Viewing Status
```bash
docker-compose ps
```

### Rebuilding After Changes
```bash
docker-compose down
docker-compose up --build -d
```

## 🛠️ Customization

### Adding New API Endpoints
1. Create controllers in `laravel/app/Http/Controllers/Api/`
2. Add routes in `laravel/routes/api.php`
3. Restart Laravel container: `docker-compose restart laravel`

### Modifying Frontend
1. Edit files in `next/pages/` or `next/components/`
2. Changes will hot-reload automatically
3. For major changes, restart: `docker-compose restart next`

### Database Changes
1. Create migrations: `docker-compose exec laravel php artisan make:migration`
2. Run migrations: `docker-compose exec laravel php artisan migrate`
3. Access phpMyAdmin at http://localhost:8080

## 🚨 Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check logs
docker-compose logs <service-name>

# Restart services
docker-compose down
docker-compose up -d
```

#### API Not Responding
```bash
# Check Laravel logs
docker-compose logs laravel

# Clear caches
docker-compose exec laravel php artisan config:clear
docker-compose exec laravel php artisan route:clear
```

#### Database Connection Issues
```bash
# Check MySQL status
docker-compose exec db mysqladmin ping

# Restart MySQL
docker-compose restart db
```

#### Frontend Build Issues
```bash
# Check Next.js logs
docker-compose logs next

# Rebuild container
docker-compose down
docker-compose up --build -d
```

### Reset Everything
If you need to start completely fresh:

```bash
# Stop and remove everything
docker-compose down -v

# Remove project files
rm -rf laravel next
rm -f docker-compose.yml

# Run setup again
./scripts/setup.sh
./scripts/after_setup.sh
```

## 📚 Next Steps

After successful setup, consider:

1. **🔐 Authentication**: Implement Laravel Sanctum
2. **📊 Data Seeding**: Add sample data to your database
3. **🧪 Testing**: Set up PHPUnit and Jest
4. **📝 API Documentation**: Use tools like Swagger
5. **🚀 Deployment**: Prepare for production deployment

## 🆘 Getting Help

If you encounter issues:

1. Check the logs: `docker-compose logs <service-name>`
2. Verify prerequisites are installed
3. Ensure Docker Desktop is running
4. Check port availability (8000, 3000, 3306, 8080)
5. Review the troubleshooting section above

## 🎉 Congratulations!

You now have a fully functional, production-ready full-stack development environment! 

**Happy coding! 🚀**
