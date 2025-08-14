# 🚀 Laravel + Next.js + MySQL Quick Reference

## 🌐 Access Points
- **🌐 Laravel API**: http://localhost:8000
- **⚡ Next.js Frontend**: http://localhost:3000
- **🗄️ MySQL Database**: localhost:3306
- **🔧 phpMyAdmin**: http://localhost:8080

## 🚀 Quick Commands

### Start Everything
```bash
./scripts/setup.sh                    # Unix: Complete setup from scratch
setup.bat                     # Windows: Complete setup from scratch
docker-compose up -d          # Start all services
```

### Stop Everything
```bash
docker-compose down           # Stop all services
docker-compose down -v        # Stop + remove volumes
docker system prune -f        # Clean up Docker
```

### Check Status
```bash
docker-compose ps             # Service status
docker-compose logs           # All logs
docker-compose logs laravel   # Laravel logs
docker-compose logs next      # Next.js logs
docker-compose logs db        # MySQL logs
```

## 🔧 Laravel API Commands

```bash
# Generate app key
docker-compose exec laravel php artisan key:generate

# Run migrations
docker-compose exec laravel php artisan migrate

# Clear caches
docker-compose exec laravel php artisan cache:clear
docker-compose exec laravel php artisan config:clear

# Create new controller
docker-compose exec laravel php artisan make:controller Api/NewController

# Access Laravel container
docker-compose exec laravel bash
```

## ⚡ Next.js Commands

```bash
# Install packages
docker-compose exec next npm install package-name

# Development mode
docker-compose exec next npm run dev

# Build production
docker-compose exec next npm run build

# Access Next.js container
docker-compose exec next sh
```

## 🗄️ Database Commands

```bash
# Access MySQL
docker-compose exec db mysql -u app -p app

# Access as root
docker-compose exec db mysql -u root -proot

# Backup database
docker-compose exec db mysqldump -u app -p app > backup.sql

# Restore database
docker-compose exec -i db mysql -u app -p app < backup.sql
```

## 📁 Project Structure
```
laravel_next_mysql_play/
├── 📁 laravel/           # Laravel API Backend
├── 📁 next/              # Next.js Frontend  
├── 📁 mysql/             # Database scripts
├── 📁 docker-compose.yml # Docker orchestration
├── 📁 scripts/           # All automation scripts
└── 📁 setup.bat          # Windows setup script
```

## 🔌 API Endpoints

### Users
- `GET /api/users` - List all users
- `POST /api/users` - Create user
- `GET /api/users/{id}` - Get user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

### Health
- `GET /api/health` - API status

## 🐛 Common Issues

### Port Already in Use
```bash
lsof -i :8000              # Check port 8000
lsof -i :3000              # Check port 3000
lsof -i :3306              # Check port 3306
lsof -i :8080              # Check port 8080
```

### Reset Everything
```bash
# Interactive reset (recommended)
./scripts/reset_project.sh                 # Start fresh

# Non-interactive reset (automation)
echo "yes" | ./scripts/reset_project.sh    # Skip confirmation
```

### Container Issues
```bash
docker-compose build --no-cache  # Rebuild images
docker-compose restart laravel   # Restart Laravel
docker-compose restart next      # Restart Next.js
docker-compose restart db        # Restart MySQL
```

## 🔒 Environment Variables

### Laravel (.env)
```env
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=app
DB_USERNAME=app
DB_PASSWORD=app
CORS_ALLOWED_ORIGINS=http://localhost:3000
```

### Next.js
```env
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_APP_NAME="Laravel + Next.js App"
```

## 📱 Development Workflow

1. **Start Services**: `docker-compose up -d`
2. **Edit Laravel**: Files in `./laravel/` auto-reload
3. **Edit Next.js**: Files in `./next/` auto-reload
4. **Database**: Use phpMyAdmin at http://localhost:8080
5. **API Testing**: Test endpoints at http://localhost:8000/api
6. **Frontend**: View at http://localhost:3000

## 🚀 Production Notes

- Update `.env` files with production values
- Enable HTTPS for all services
- Use strong database passwords
- Implement proper monitoring
- Set up database backups
- Consider Docker Swarm/Kubernetes for scaling

---

**Happy Full-Stack Development! 🚀**

*Built with Laravel, Next.js, MySQL, and Docker*
