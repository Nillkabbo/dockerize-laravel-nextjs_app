# 🐛 Troubleshooting Guide

## 🚨 Common Issues and Solutions

This guide covers the most common problems you might encounter with your Laravel + Next.js + MySQL full-stack setup.

## 🔍 Quick Diagnostic Commands

Before diving into specific issues, always check these first:

```bash
# Check container status
docker-compose ps

# View all logs
docker-compose logs

# Check specific service logs
docker-compose logs laravel
docker-compose logs next
docker-compose logs db
docker-compose logs phpmyadmin

# Check if ports are in use
lsof -i :8000    # Laravel API
lsof -i :3000    # Next.js Frontend
lsof -i :3306    # MySQL Database
lsof -i :8080    # phpMyAdmin
```

## 🐳 Docker Issues

### Issue: Docker Desktop Not Running
**Symptoms**: `Cannot connect to the Docker daemon`

**Solutions**:
1. Start Docker Desktop application
2. Wait for Docker to fully initialize
3. Verify with: `docker info`

### Issue: Port Already in Use
**Symptoms**: `Bind for 0.0.0.0:8000 failed: port is already allocated`

**Solutions**:
```bash
# Check what's using the port
lsof -i :8000

# Kill the process using the port
kill -9 <PID>

# Or change ports in docker-compose.yml
```

### Issue: Container Won't Start
**Symptoms**: Container shows `Exited` status

**Solutions**:
```bash
# Check logs for specific error
docker-compose logs <service-name>

# Rebuild the specific container
docker-compose build --no-cache <service-name>

# Restart the service
docker-compose restart <service-name>
```

## 🔧 Laravel Issues

### Issue: Laravel Shows "Server Error"
**Symptoms**: White page or generic error message

**Solutions**:
```bash
# Generate application key
docker-compose exec laravel php artisan key:generate

# Clear caches
docker-compose exec laravel php artisan config:clear
docker-compose exec laravel php artisan cache:clear

# Check Laravel logs
docker-compose exec laravel tail -f storage/logs/laravel.log
```

### Issue: Database Connection Failed
**Symptoms**: `SQLSTATE[HY000] [2002] Connection refused`

**Solutions**:
```bash
# Wait for MySQL to be ready (check health status)
docker-compose ps db

# Restart database service
docker-compose restart db

# Check MySQL logs
docker-compose logs db

# Verify environment variables
docker-compose exec laravel php artisan config:show database
```

### Issue: Migration Errors
**Symptoms**: `SQLSTATE[42S01]: Base table or view already exists`

**Solutions**:
```bash
# Reset migrations
docker-compose exec laravel php artisan migrate:fresh

# Or rollback and re-run
docker-compose exec laravel php artisan migrate:rollback
docker-compose exec laravel php artisan migrate
```

### Issue: Permission Denied
**Symptoms**: `Permission denied` when accessing files

**Solutions**:
```bash
# Fix file ownership
sudo chown -R $USER:$USER laravel/
sudo chown -R $USER:$USER next/

# Fix permissions
chmod -R 755 laravel/
chmod -R 755 next/
```

## ⚡ Next.js Issues

### Issue: Next.js Build Fails
**Symptoms**: Build errors during Docker build

**Solutions**:
```bash
# Clear node_modules and reinstall
docker-compose exec next rm -rf node_modules package-lock.json
docker-compose exec next npm install

# Rebuild container
docker-compose build next
docker-compose up -d next
```

### Issue: Next.js Not Accessible
**Symptoms**: Can't access http://localhost:3000

**Solutions**:
```bash
# Check Next.js container status
docker-compose ps next

# Check Next.js logs
docker-compose logs next

# Restart Next.js service
docker-compose restart next

# Verify port mapping
docker-compose port next 3000
```

### Issue: API Connection Errors
**Symptoms**: Frontend can't connect to Laravel API

**Solutions**:
1. Verify Laravel API is running: http://localhost:8000/api/health
2. Check CORS configuration in Laravel
3. Verify `NEXT_PUBLIC_API_URL` environment variable
4. Check browser console for CORS errors

## 🗄️ MySQL Issues

### Issue: MySQL Container Restarting
**Symptoms**: Container shows `Restarting` status

**Solutions**:
```bash
# Check MySQL logs
docker-compose logs db

# Check available disk space
df -h

# Restart MySQL service
docker-compose restart db

# Check health status
docker-compose ps db
```

### Issue: Can't Connect to Database
**Symptoms**: Connection timeout or access denied

**Solutions**:
```bash
# Test database connection
docker-compose exec db mysql -u app -p app

# Check MySQL user permissions
docker-compose exec db mysql -u root -proot -e "SHOW GRANTS FOR 'app'@'%';"

# Recreate database user
docker-compose exec db mysql -u root -proot -e "DROP USER 'app'@'%'; CREATE USER 'app'@'%' IDENTIFIED BY 'app'; GRANT ALL PRIVILEGES ON app.* TO 'app'@'%'; FLUSH PRIVILEGES;"
```

### Issue: Database Data Lost
**Symptoms**: Tables or data missing after restart

**Solutions**:
1. Check if volumes are properly mounted
2. Verify `db_data` volume exists: `docker volume ls`
3. Check volume mount in docker-compose.yml
4. Restore from backup if available

## 🔧 phpMyAdmin Issues

### Issue: Can't Access phpMyAdmin
**Symptoms**: http://localhost:8080 not accessible

**Solutions**:
```bash
# Check phpMyAdmin container status
docker-compose ps phpmyadmin

# Check phpMyAdmin logs
docker-compose logs phpmyadmin

# Restart phpMyAdmin service
docker-compose restart phpmyadmin

# Verify environment variables
docker-compose exec phpmyadmin env | grep PMA
```

### Issue: Login Fails
**Symptoms**: Can't log in with app/app credentials

**Solutions**:
1. Verify MySQL is running and healthy
2. Check if user 'app' exists in MySQL
3. Try root credentials: root/root
4. Check MySQL user permissions

## 🚀 Performance Issues

### Issue: Slow Container Startup
**Symptoms**: Containers take a long time to start

**Solutions**:
```bash
# Check Docker resources
docker system df

# Clean up unused resources
docker system prune -f

# Increase Docker memory/CPU allocation in Docker Desktop
```

### Issue: High Memory Usage
**Symptoms**: Containers using excessive memory

**Solutions**:
```bash
# Check container resource usage
docker stats

# Restart services to free memory
docker-compose restart

# Check for memory leaks in application code
```

## 🔄 Reset and Recovery

### Complete Reset
When all else fails, start fresh:

```bash
# Stop and remove everything
docker-compose down -v

# Clean Docker system
docker system prune -af

# Remove project files
rm -rf laravel next

# Run setup script again
./scripts/setup.sh
```

### Partial Reset
Reset specific components:

```bash
# Reset only Laravel
docker-compose stop laravel
rm -rf laravel
# Re-run Laravel setup steps

# Reset only Next.js
docker-compose stop next
rm -rf next
# Re-run Next.js setup steps

# Reset only database
docker-compose down -v
docker-compose up -d db
```

### Reset Everything
If you need to start completely fresh:

```bash
# Stop and remove everything
docker-compose down -v

# Remove project files
rm -rf laravel next
rm -f docker-compose.yml

# Run setup again (interactive)
./scripts/setup.sh
./scripts/after_setup.sh

# OR run setup again (non-interactive)
echo "yes" | ./scripts/reset_project.sh
./scripts/setup.sh
./scripts/after_setup.sh
```

## 📊 Health Check Commands

### Service Health
```bash
# Check all services
docker-compose ps

# Check specific service health
docker-compose exec db mysqladmin ping -h 127.0.0.1 -proot
curl -f http://localhost:8000/api/health
curl -f http://localhost:3000
```

### Network Connectivity
```bash
# Test inter-container communication
docker-compose exec laravel ping db
docker-compose exec next ping laravel

# Check network configuration
docker network ls
docker network inspect myapp_net
```

## 🆘 Getting Help

### Before Asking for Help
1. ✅ Check this troubleshooting guide
2. ✅ Run diagnostic commands above
3. ✅ Check container logs
4. ✅ Verify prerequisites are installed
5. ✅ Try resetting the problematic service

### Information to Provide
When seeking help, include:
- Your operating system
- Docker version: `docker --version`
- Docker Compose version: `docker-compose --version`
- Complete error messages
- Container logs: `docker-compose logs`
- Container status: `docker-compose ps`

### Additional Resources
- [Docker Documentation](https://docs.docker.com/)
- [Laravel Documentation](https://laravel.com/docs)
- [Next.js Documentation](https://nextjs.org/docs)
- [MySQL Documentation](https://dev.mysql.com/doc/)

---

**Remember**: Most issues can be resolved by checking logs and restarting services. When in doubt, the complete reset option (`./scripts/setup.sh`) will get you back to a working state! 🚀
