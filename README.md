# 🚀 Laravel + Next.js + MySQL Full Stack Starter

> **🔗 Repository**: [https://github.com/Nillkabbo/dockerize-laravel-nextjs_app](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app)

> **🎯 LOST? CONFUSED?** Start with **[docs/START_HERE.md](docs/START_HERE.md)** - Your navigation guide to all documentation!
> 
> **🌐 GitHub Viewers**: Use **[docs/START_HERE.md](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app/blob/main/docs/START_HERE.md)** for proper navigation on GitHub!

**📁 Clean Project Structure**: All documentation is organized in the `docs/` folder for easy navigation!

## 🌐 **GitHub Navigation**

> **📱 Viewing on GitHub?** Use these direct links for proper navigation:

- **🚀 [START_HERE.md](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app/blob/main/docs/START_HERE.md)** - Begin here!
- **📚 [Documentation Index](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app/blob/main/docs/INDEX.md)** - All docs overview
- **🔧 [Setup Guide](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app/blob/main/docs/SETUP_GUIDE.md)** - Detailed setup
- **⚡ [Quick Reference](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app/blob/main/docs/QUICK_REFERENCE.md)** - Common commands
- **🚨 [Troubleshooting](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app/blob/main/docs/TROUBLESHOOTING.md)** - Fix common issues

A complete, production-ready full-stack development environment featuring Laravel API, Next.js frontend, MySQL database, and phpMyAdmin - all containerized with Docker.

## ✨ Features

- **🔧 Backend**: Laravel 12 with RESTful API endpoints and authentication
- **⚡ Frontend**: Next.js 14 with React 18, TypeScript, and complete authentication system
- **🗄️ Database**: MySQL 8.0 with migrations, seeders, and sample users
- **🐳 Containerization**: Docker Compose with development and production modes
- **🔧 Management**: phpMyAdmin for database administration
- **🚀 Automation**: One-command setup scripts with hot reload
- **🔐 Authentication**: Complete login/register system with protected routes
- **📊 User Management**: Real-time users list display on both home and welcome pages

## 🎯 Quick Start

### Prerequisites
- Docker Desktop
- Git
- Node.js (v18+)
- Composer

### Setup Commands
```bash
# 1. Clone the repository
git clone git@github.com:Nillkabbo/dockerize-laravel-nextjs_app.git
cd laravel_next_mysql_play

# 2. Run initial setup (creates projects and containers)
./scripts/setup.sh                    # macOS/Linux
# OR
scripts\setup.bat                     # Windows

# 3. Complete the setup (configures Laravel and verifies everything)
./scripts/after_setup.sh             # macOS/Linux
# OR
scripts\after_setup.bat              # Windows
```

**That's it!** Your full-stack application will be ready in minutes! 🎉

📖 **For detailed setup instructions, see [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md)** ([GitHub](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app/blob/main/docs/SETUP_GUIDE.md))

## 🌐 Access Points

Once setup is complete:

- **🌐 Laravel API**: http://localhost:8000
- **⚡ Next.js Frontend**: http://localhost:3000
- **🗄️ MySQL Database**: localhost:3306
- **🔧 phpMyAdmin**: http://localhost:8080

## 🧪 Test Your Setup

### **Basic API Testing**
```bash
# Test API health
curl http://localhost:8000/api/health

# Test users endpoint (public access)
curl http://localhost:8000/api/users

# Test frontend
curl http://localhost:3000
```

### **Authentication Testing**
```bash
# 1. Register a new user
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123","password_confirmation":"password123"}'

# 2. Login and get token
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin123"}'

# 3. Use token to access protected endpoints
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8000/api/users

# 4. Get user profile
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8000/api/auth/me
```

### **Frontend Testing**
1. **Home Page**: http://localhost:3000 - Users list (public access)
2. **Login Page**: http://localhost:3000/login - Authentication form
3. **Register Page**: http://localhost:3000/register - User registration
4. **Welcome Page**: http://localhost:3000/welcome - Protected dashboard (requires login)

## 🏗️ Architecture

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

## 🚀 What You Get

### Backend (Laravel 12)
- ✅ **RESTful API** with user management endpoints
- ✅ **Authentication System** with custom token-based auth
- ✅ **Database migrations** and seeders with sample users
- ✅ **CORS configuration** for frontend communication
- ✅ **Swagger Documentation** at `/api/documentation`
- ✅ **Health Check** endpoint at `/api/health`

### Frontend (Next.js 14)
- ✅ **React 18** with TypeScript
- ✅ **Tailwind CSS** for modern styling
- ✅ **Complete Authentication** system (login/register/logout)
- ✅ **Protected Routes** with authentication guards
- ✅ **Real-time Users List** on both home and welcome pages
- ✅ **Hot Reloading** for development
- ✅ **Responsive Design** for all devices

### Infrastructure
- ✅ **Docker Compose** orchestration with dev/prod modes
- ✅ **MySQL 8.0** database with sample data
- ✅ **phpMyAdmin** for database management
- ✅ **Proper networking** between services
- ✅ **Volume mounting** for development
- ✅ **Multi-stage builds** for production

## 📁 Project Structure

```
laravel_next_mysql_play/
├── 🚀 docs/                      # Documentation folder
│   ├── START_HERE.md             # START HERE - Navigation guide
│   ├── AI_AGENT_INDEX.md         # AI agent entry point
│   ├── CODE_PATTERNS.md          # Code examples and templates
│   ├── PROJECT_BRAIN.md          # Complete knowledge base
│   ├── SETUP_GUIDE.md            # Detailed setup instructions
│   ├── QUICK_REFERENCE.md        # Quick commands reference
│   ├── TROUBLESHOOTING.md        # Common issues and solutions
│   └── ...                       # More documentation files
├── setup.sh                      # Initial setup script (macOS/Linux)
├── setup.bat                     # Initial setup script (Windows)
├── after_setup.sh                # Complete setup script (macOS/Linux)
├── after_setup.bat               # Complete setup script (Windows)
├── README.md                     # This file
├── docker-compose.yml            # Docker services configuration
├── laravel/                      # Laravel backend application
├── next/                         # Next.js frontend application
└── mysql/                        # MySQL initialization scripts
```

## 📜 Available Scripts

### **Setup Scripts**
- `./scripts/setup.sh` - Initial project creation and container setup
- `./scripts/after_setup.sh` - Complete Laravel and Next.js configuration
- `./scripts/reset_project.sh` - Reset everything and start fresh

### **Development Scripts**
- `./scripts/dev.sh` - Start development environment with hot reload
- `./scripts/quick-dev.sh` - Quick restart of frontend only
- `./scripts/prod.sh` - Start production environment

### **Windows Users**
- `scripts\setup.bat` - Initial setup for Windows
- `scripts\after_setup.bat` - Complete setup for Windows

## 🚀 Development Workflow

### **Development Mode (Hot Reload)**
```bash
# Start development environment with hot reload
./scripts/dev.sh

# Quick restart of just the frontend
./scripts/quick-dev.sh

# Stop development environment
docker-compose -f docker-compose.dev.yml down
```

**Development Features:**
- ✅ **Hot Reload**: Changes reflect immediately without rebuilding
- ✅ **Volume Mounting**: Source code mounted as volumes
- ✅ **Fast Iteration**: Edit files and see changes instantly
- ✅ **No Rebuilds**: Perfect for active development

### **Production Mode (Optimized)**
```bash
# Start production environment with optimized builds
./scripts/prod.sh

# Stop production environment
docker-compose -f docker-compose.prod.yml down
```

**Production Features:**
- ✅ **Optimized Performance**: Built and minified code
- ✅ **Security Hardened**: Production-ready configurations
- ✅ **Resource Efficient**: Smaller container sizes
- ✅ **Scalable**: Ready for production deployment

### **Legacy Commands**
```bash
# Start all services (basic)
docker-compose up -d

# Stop all services
docker-compose down

# View service status
docker-compose ps

# View logs
docker-compose logs [service-name]

# Rebuild after changes
docker-compose up --build -d
```

## 🎯 Current Functionality

### **Authentication System**
- ✅ **User Registration** at `/register`
- ✅ **User Login** at `/login` with automatic redirection
- ✅ **Protected Dashboard** at `/welcome`
- ✅ **Token-based Authentication** with Bearer tokens
- ✅ **Automatic Logout** and session management

### **Users Management**
- ✅ **Home Page** (`/`) - Public users list with authentication awareness
- ✅ **Welcome Page** (`/welcome`) - Protected users list with full features
- ✅ **Real-time Updates** with refresh buttons
- ✅ **Status Indicators** (Active/Registered) for each user
- ✅ **API Integration** with Laravel backend

### **API Endpoints**
- ✅ **Health Check**: `GET /api/health`
- ✅ **User Registration**: `POST /api/auth/register`
- ✅ **User Login**: `POST /api/auth/login`
- ✅ **User Logout**: `POST /api/auth/logout`
- ✅ **User Profile**: `GET /api/auth/me`
- ✅ **Users List**: `GET /api/users`
- ✅ **User Statistics**: `GET /api/users/stats`

## 🛠️ Customization

### Adding API Endpoints
1. Create controllers in `laravel/app/Http/Controllers/Api/`
2. Add routes in `laravel/routes/api.php`
3. Restart Laravel: `docker-compose restart laravel`

### Modifying Frontend
1. Edit files in `next/pages/` or `next/components/`
2. Changes auto-reload in development mode
3. For major changes: `docker-compose restart next`

### Database Changes
1. Create migrations: `docker-compose exec laravel php artisan make:migration`
2. Run migrations: `docker-compose exec laravel php artisan migrate`
3. Access phpMyAdmin at http://localhost:8080

## 🚨 Troubleshooting

For common issues and solutions, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) ([GitHub](https://github.com/Nillkabbo/dockerize-laravel-nextjs_app/blob/main/docs/TROUBLESHOOTING.md))

Quick fixes:
```bash
# Reset everything and start fresh
docker-compose down -v
rm -rf laravel next
rm -f docker-compose.yml
./setup.sh
./after_setup.sh
```

## 📚 Next Steps

After successful setup:
1. **🔐 Authentication**: ✅ Complete - Custom token-based system implemented
2. **📊 Data**: ✅ Complete - Sample users and seeders available
3. **🧪 Testing**: ✅ Complete - API endpoints tested and working
4. **📝 Documentation**: ✅ Complete - Swagger UI and comprehensive docs
5. **🚀 Deployment**: ✅ Ready - Production Docker configuration available

## 🎉 Recent Updates (August 14, 2025)

### **✅ Completed Features**
- **Authentication System**: Complete login/register/logout with protected routes
- **Users List Integration**: Real-time users display on both home and welcome pages
- **Development Workflow**: Hot reload automation with dev/prod modes
- **Documentation**: Comprehensive feature documentation and troubleshooting guides

### **🚀 Current Status**
- **Frontend**: 100% Complete with authentication and user management
- **Backend**: 100% Complete with API endpoints and authentication
- **Infrastructure**: 100% Complete with development and production modes
- **Documentation**: 100% Complete with feature guides and examples

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with the setup scripts
5. Submit a pull request

## 📄 License

This project is open-sourced software licensed under the [MIT license](LICENSE).

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting guide
2. Review the setup guide
3. Check Docker and service logs
4. Open an issue with detailed information

---

**🎉 Happy full-stack coding! 🚀**
