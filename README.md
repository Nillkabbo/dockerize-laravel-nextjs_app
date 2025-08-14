# 🚀 Laravel + Next.js + MySQL Full Stack Starter

> **🎯 LOST? CONFUSED?** Start with **[docs/START_HERE.md](docs/START_HERE.md)** - Your navigation guide to all documentation!

**📁 Clean Project Structure**: All documentation is organized in the `docs/` folder for easy navigation!

A complete, production-ready full-stack development environment featuring Laravel API, Next.js frontend, MySQL database, and phpMyAdmin - all containerized with Docker.

## ✨ Features

- **🔧 Backend**: Laravel 12 with RESTful API endpoints
- **⚡ Frontend**: Next.js 14 with React 18 and TypeScript
- **🗄️ Database**: MySQL 8.0 with migrations and sample data
- **🐳 Containerization**: Docker Compose for easy development
- **🔧 Management**: phpMyAdmin for database administration
- **🚀 Automation**: One-command setup scripts

## 🎯 Quick Start

### Prerequisites
- Docker Desktop
- Git
- Node.js (v18+)
- Composer

### Setup Commands
```bash
# 1. Clone the repository
git clone <your-repo-url>
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

📖 **For detailed setup instructions, see [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md)**

## 🌐 Access Points

Once setup is complete:

- **🌐 Laravel API**: http://localhost:8000
- **⚡ Next.js Frontend**: http://localhost:3000
- **🗄️ MySQL Database**: localhost:3306
- **🔧 phpMyAdmin**: http://localhost:8080

## 🧪 Test Your Setup

```bash
# Test API health
curl http://localhost:8000/api/health

# Test users endpoint
curl http://localhost:8000/api/users

# Test frontend
curl http://localhost:3000
```

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
- RESTful API with user management endpoints
- Database migrations and seeders
- CORS configuration for frontend communication
- Ready for authentication with Laravel Sanctum

### Frontend (Next.js 14)
- React 18 with TypeScript
- Tailwind CSS for styling
- API integration with Laravel
- Hot reloading for development

### Infrastructure
- Docker Compose orchestration
- MySQL 8.0 database
- phpMyAdmin for database management
- Proper networking between services

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

## 🔄 Development Commands

```bash
# Start all services
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

## 🛠️ Customization

### Adding API Endpoints
1. Create controllers in `laravel/app/Http/Controllers/Api/`
2. Add routes in `laravel/routes/api.php`
3. Restart Laravel: `docker-compose restart laravel`

### Modifying Frontend
1. Edit files in `next/pages/` or `next/components/`
2. Changes auto-reload
3. For major changes: `docker-compose restart next`

### Database Changes
1. Create migrations: `docker-compose exec laravel php artisan make:migration`
2. Run migrations: `docker-compose exec laravel php artisan migrate`
3. Access phpMyAdmin at http://localhost:8080

## 🚨 Troubleshooting

For common issues and solutions, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

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
1. **🔐 Authentication**: Implement Laravel Sanctum
2. **📊 Data**: Add sample data and seeders
3. **🧪 Testing**: Set up PHPUnit and Jest
4. **📝 Documentation**: Add API documentation
5. **🚀 Deployment**: Prepare for production

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
