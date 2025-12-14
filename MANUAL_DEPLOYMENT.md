# NUVO IP - Deployment Instructions

## ✅ Docker Deployment (Recommended)

El problema de configuración de Docker ha sido resuelto.

**Status:** ✅ Funcionando correctamente

---

## 🐳 Paso 1: Iniciar Todo el Sistema con Docker

### Iniciar todos los servicios

```bash
# Iniciar PostgreSQL y todos los microservicios
docker-compose up -d --build

# Esperar a que los servicios inicien (unos 30 segundos)
sleep 30
```

Esto iniciará automáticamente:
- ✅ PostgreSQL (puerto 5444)
- ✅ Auth Service (puerto 8081)
- ✅ Account Service (puerto 8082)
- ✅ Transaction Service (puerto 8083)
- ✅ Loan Service (puerto 8084)
- ✅ Pool Service (puerto 8085)

### Verificar estado

```bash
docker ps
```

Todos los servicios deberían mostrar status "Up".

---

## 🌐 Paso 2: Iniciar Web Admin (Opcional)

```bash
cd nuvo-web-admin
npm install  # Solo la primera vez
npm start

# Acceder en: http://localhost:4200
```

---

## 📱  Paso 3: Iniciar App Móvil (Opcional)

```bash
cd flutter_nuvo_app

# Para Android
flutter run

# Para iOS
flutter run -d ios

# Para Web (preview)
flutter run -d chrome
```

---

## 🔍 Verificación

### 1. Verificar Servicios

```bash
# Ejecutar script de verificación
./verify-services.sh

# O manualmente:
curl http://localhost:8081/actuator/health
curl http://localhost:8082/actuator/health
curl http://localhost:8083/actuator/health
curl http://localhost:8084/actuator/health
curl http://localhost:8085/actuator/health
```

### 2. Verificar Swagger UI

Abrir en navegador:
- http://localhost:8081/swagger-ui.html
- http://localhost:8082/swagger-ui.html
- http://localhost:8083/swagger-ui.html
- http://localhost:8084/swagger-ui.html
- http://localhost:8085/swagger-ui.html

### 3. Generar Datos de Prueba

```bash
./generate-test-data.sh
```

---

## 📱 URLs de Acceso

| Servicio | URL | Puerto |
|----------|-----|--------|
| Auth API | http://localhost:8081 | 8081 |
| Account API | http://localhost:8082 | 8082 |
| Transaction API | http://localhost:8083 | 8083 |
| Loan API | http://localhost:8084 | 8084 |
| Pool API | http://localhost:8085 | 8085 |
| Web Admin | http://localhost:4200 | 4200 |
| PostgreSQL | localhost:5444 | 5444 |

---

## 🧪 Pruebas Rápidas

### 1. Test con cURL

```bash
# Login
curl -X POST http://localhost:8081/api/v1/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@test.com",
    "password": "password123"
  }'

# Ver balance (usar token del login)
TOKEN="tu-jwt-token"
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8082/api/v1/accounts/user/1
```

### 2. Test con Swagger

1. Abrir http://localhost:8081/swagger-ui.html
2. Hacer clic en "Authorize"
3. Ingresar JWT token
4. Probar endpoints

### 3. Test con Web Admin

1. Abrir http://localhost:4200
2. Login con admin@test.com / admin123
3. Ver dashboard

### 4. Test con Flutter App

1. Ejecutar `flutter run`
2. Registrar nuevo usuario
3. Hacer deposit
4. Ver balance

---

## 📋 Checklist de Deployment

- [ ] PostgreSQL corriendo (puerto 5444)
- [ ] Auth Service corriendo (puerto 8081)
- [ ] Account Service corriendo (puerto 8082)
- [ ] Transaction Service corriendo (puerto 8083)
- [ ] Loan Service corriendo (puerto 8084)
- [ ] Pool Service corriendo (puerto 8085)
- [ ] Web Admin corriendo (puerto 4200)
- [ ] Flutter App corriendo (emulador/device)
- [ ] Swagger UI accesible
- [ ] Datos de prueba generados

---

## 🐛 Troubleshooting

### Puerto ya en uso

```bash
# Ver qué usa el puerto
lsof -i :8081

# Matar proceso
kill -9 PID
```

### Base de datos no conecta

```bash
# Verificar PostgreSQL
docker ps | grep postgres

# Ver logs
docker logs nuvo_postgres

# Conectar manualmente
psql -h localhost -p 5444 -U postgres
```

### Servicio no inicia

```bash
# Ver logs en tiempo real
cd nuvo-auth-service
./mvnw spring-boot:run

# Verificar puerto libre
lsof -i :8081
```

---

## 💡 Recomendación

**Método recomendado:** `docker-compose` (¡ahora funciona correctamente!)

Ventajas:
1. ✅ Un solo comando para iniciar todo
2. ✅ Networking automático entre servicios
3. ✅ Fácil de detener/reiniciar
4. ✅ Configuración centralizada

```bash
# Iniciar
docker-compose up -d

# Detener
docker-compose down

# Ver logs
docker-compose logs -f
```

---

**Estado:** ✅ Docker deployment funcionando correctamente  
**Última actualización:** 2025-12-11  
**Comando:** `docker-compose up -d --build`
