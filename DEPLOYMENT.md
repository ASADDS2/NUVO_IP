# NUVO IP - Deployment Guide

## 📦 Guía de Deployment

Esta guía cubre el deployment del sistema NUVO IP en diferentes entornos.

---

## 🚀 Quick Start (Development)

### Opción 1: Docker Compose (Recomendado)

```bash
# 1. Clonar repositorio
git clone https://github.com/ASADDS2/NUVO_IP.git
cd NUVO_IP-develop

# 2. Configurar variables de entorno (opcional)
cp .env.example .env

# 3. Iniciar servicios
docker-compose up -d

# 4. Verificar estado
docker-compose ps

# 5. Ver logs
docker-compose logs -f
```

**URLs de Verificación:**
- Swagger Auth: http://localhost:8081/swagger-ui.html
- Swagger Account: http://localhost:8082/swagger-ui.html
- Swagger Transaction: http://localhost:8083/swagger-ui.html
- Swagger Loan: http://localhost:8084/swagger-ui.html
- Swagger Pool: http://localhost:8085/swagger-ui.html
- PostgreSQL: localhost:5444

---

## 🔧 Configuración por Entorno

### Development

**application.yml:**
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5444/nuvo_xxx_db
    username: postgres
    password: 1234
  jpa:
    show-sql: true
    hibernate:
      ddl-auto: update
```

### Production

**application-prod.yml:**
```yaml
spring:
  datasource:
    url: ${DATABASE_URL}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  jpa:
    show-sql: false
    hibernate:
      ddl-auto: none
logging:
  level:
    root: WARN
    com.nuvo: INFO
```

---

## ⚠️ Troubleshooting

### Docker iptables Error
```bash
docker-compose down
docker network prune -f
sudo systemctl restart docker
docker-compose up -d
```

### Port Already in Use
```bash
lsof -i :8081
kill -9 PID
```

---

## ✅ Checklist de Deployment

### Pre-Deployment
- [ ] Tests pasan
- [ ] Build exitoso  
- [ ] Variables de entorno configuradas
- [ ] Secrets seguros

### Post-Deployment
- [ ] Verificar logs
- [ ] Probar endpoints
- [ ] Verificar Swagger UI

---

**Versión:** 2.0
