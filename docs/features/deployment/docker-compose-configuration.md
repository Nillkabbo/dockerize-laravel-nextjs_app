# 🐳 Docker Compose Configuration Guide

## 🎯 **Overview**
This project uses **enhanced Docker Compose configurations** with separate files for development and production environments, eliminating the need for a basic `docker-compose.yml` file.

## 📁 **Docker Compose Files**

### **1. Development Configuration (`docker-compose.dev.yml`)**
- **Purpose**: Development environment with hot reload and volume mounting
- **Features**:
  - ✅ **Hot Reload**: Changes reflect immediately without rebuilding
  - ✅ **Volume Mounting**: Source code mounted as volumes
  - ✅ **Development Dockerfiles**: Uses `Dockerfile.dev` for Next.js
  - ✅ **Fast Iteration**: Edit files and see changes instantly
  - ✅ **Container Naming**: Services have `-dev` suffix

**Usage:**
```bash
# Start development environment
./scripts/dev.sh

# Or manually
docker-compose -f docker-compose.dev.yml up -d

# Stop development environment
docker-compose -f docker-compose.dev.yml down
```

### **2. Production Configuration (`docker-compose.prod.yml`)**
- **Purpose**: Production environment with optimized builds and security
- **Features**:
  - ✅ **Optimized Performance**: Built and minified code
  - ✅ **Security Hardened**: Production-ready configurations
  - ✅ **Production Dockerfiles**: Uses `Dockerfile.prod` for Next.js
  - ✅ **Resource Efficient**: Smaller container sizes
  - ✅ **Container Naming**: Services have `-prod` suffix

**Usage:**
```bash
# Start production environment
./scripts/prod.sh

# Or manually
docker-compose -f docker-compose.prod.yml up -d

# Stop production environment
docker-compose -f docker-compose.prod.yml down
```

### **3. Base Configuration (`docker-compose.yml`) - NOT NEEDED**
- **Status**: ❌ **Removed/Not Used**
- **Reason**: Setup scripts now use enhanced configurations directly
- **Benefit**: No confusion about which configuration to use

## 🔧 **Setup Scripts Integration**

### **Updated Setup Workflow**

#### **Phase 1: Initial Setup (`./scripts/setup.sh`)**
```bash
# What it does:
1. Creates Laravel and Next.js projects
2. Sets up project structure
3. Creates necessary Dockerfiles
4. Uses docker-compose.dev.yml for building and starting
5. NO LONGER creates basic docker-compose.yml
```

#### **Phase 2: Complete Setup (`./scripts/after_setup.sh`)**
```bash
# What it does:
1. Runs database migrations
2. Seeds sample data
3. Configures Laravel
4. Uses docker-compose.dev.yml for all operations
5. Verifies all services are working
```

### **Key Changes Made**

#### **Before (Problematic):**
```bash
# Setup script created basic docker-compose.yml
cat > docker-compose.yml << 'EOF'
# Basic configuration without hot reload
EOF

# After setup used basic configuration
docker-compose exec laravel php artisan migrate
```

#### **After (Fixed):**
```bash
# Setup script uses enhanced configuration
docker-compose -f docker-compose.dev.yml build
docker-compose -f docker-compose.dev.yml up -d

# After setup uses enhanced configuration
docker-compose -f docker-compose.dev.yml exec laravel php artisan migrate
```

## 🚀 **Development Workflow**

### **Complete Development Cycle**

#### **1. Initial Setup**
```bash
# Create projects and start development environment
./scripts/setup.sh
./scripts/after_setup.sh
```

#### **2. Daily Development**
```bash
# Start development environment
./scripts/dev.sh

# Quick frontend restart
./scripts/quick-dev.sh

# Stop development environment
docker-compose -f docker-compose.dev.yml down
```

#### **3. Production Deployment**
```bash
# Start production environment
./scripts/prod.sh

# Stop production environment
docker-compose -f docker-compose.prod.yml down
```

## 📊 **Configuration Comparison**

| Feature | Dev Config | Prod Config | Base Config |
|---------|------------|-------------|-------------|
| **Hot Reload** | ✅ Enabled | ❌ Disabled | ❌ Disabled |
| **Volume Mounting** | ✅ Enabled | ❌ Disabled | ❌ Disabled |
| **Development Dockerfile** | ✅ Uses `.dev` | ❌ Uses `.prod` | ❌ Uses default |
| **Container Names** | `-dev` suffix | `-prod` suffix | Generic names |
| **Environment** | Development | Production | Basic |
| **Performance** | Fast iteration | Optimized builds | Standard |
| **Security** | Development | Hardened | Basic |

## 🔍 **Troubleshooting**

### **Common Issues and Solutions**

#### **Issue 1: "docker-compose.yml not found"**
```bash
# Solution: Use specific configuration file
docker-compose -f docker-compose.dev.yml up -d
```

#### **Issue 2: Setup script overwrites configuration**
```bash
# Solution: Updated scripts now use enhanced configurations
# No more basic docker-compose.yml creation
```

#### **Issue 3: Hot reload not working**
```bash
# Solution: Ensure using dev configuration
./scripts/dev.sh
# NOT: docker-compose up -d
```

#### **Issue 4: Production builds not optimized**
```bash
# Solution: Use production configuration
./scripts/prod.sh
# NOT: docker-compose up -d
```

## 📚 **Best Practices**

### **1. Always Use Scripts**
```bash
# ✅ Good: Use provided scripts
./scripts/dev.sh
./scripts/prod.sh

# ❌ Bad: Manual docker-compose commands
docker-compose up -d
```

### **2. Environment-Specific Commands**
```bash
# Development
docker-compose -f docker-compose.dev.yml [command]

# Production
docker-compose -f docker-compose.prod.yml [command]
```

### **3. Container Management**
```bash
# View logs
docker-compose -f docker-compose.dev.yml logs [service]

# Execute commands
docker-compose -f docker-compose.dev.yml exec [service] [command]

# Check status
docker-compose -f docker-compose.dev.yml ps
```

## 🎯 **Migration Guide**

### **From Basic to Enhanced Configuration**

If you have an existing basic `docker-compose.yml`:

#### **Step 1: Backup (Optional)**
```bash
cp docker-compose.yml docker-compose.yml.backup
```

#### **Step 2: Remove Basic File**
```bash
rm docker-compose.yml
```

#### **Step 3: Use Enhanced Configurations**
```bash
# Development
./scripts/dev.sh

# Production
./scripts/prod.sh
```

#### **Step 4: Update Your Workflow**
```bash
# Replace all instances of:
docker-compose [command]

# With:
docker-compose -f docker-compose.dev.yml [command]
# OR
docker-compose -f docker-compose.prod.yml [command]
```

## 🔗 **Related Documentation**

- **[Development Workflow](../../../DEVELOPMENT_WORKFLOW.md)** - Complete development guide
- **[Frontend Features](../frontend/README.md)** - Frontend implementation details
- **[API Documentation](../api/README.md)** - Backend API details
- **[Setup Guide](../../../SETUP_GUIDE.md)** - Complete setup instructions

## 🔗 **Related Files**

- `docker-compose.dev.yml` - Development configuration
- `docker-compose.prod.yml` - Production configuration
- `scripts/dev.sh` - Development environment script
- `scripts/prod.sh` - Production environment script
- `scripts/setup.sh` - Initial setup script (updated)
- `scripts/after_setup.sh` - Complete setup script (updated)

---

**Last Updated**: August 14, 2025  
**Status**: Complete - Setup scripts updated to use enhanced configurations  
**Next Steps**: Use development and production scripts for optimal workflow
