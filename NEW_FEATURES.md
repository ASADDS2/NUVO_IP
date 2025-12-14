# NUVO IP - Guía de Características Nuevas

## 🆕 Características Implementadas (2025-12-11)

### 1. Swagger/OpenAPI Documentation 📚

Todos los microservicios ahora incluyen documentación interactiva de API con Swagger UI.

**URLs de Acceso:**
```
Auth Service:        http://localhost:8081/swagger-ui.html
Account Service:     http://localhost:8082/swagger-ui.html
Transaction Service: http://localhost:8083/swagger-ui.html
Loan Service:        http://localhost:8084/swagger-ui.html
Pool Service:        http://localhost:8085/swagger-ui.html
```

**Características:**
- ✅ Documentación auto-generada
- ✅ Pruebas de endpoints en vivo
- ✅ JWT authentication integrado
- ✅ Esquemas de request/response
- ✅ Código de ejemplo

**Uso Rápido:**
1. Iniciar servicios
2. Navegar a la URL Swagger
3. Hacer clic en "Authorize" e ingresar JWT token
4. Probar endpoints directamente

---

### 2. Global Error Handling 🛡️

Manejo centralizado de errores con respuestas consistentes en todos los servicios.

**Formato de Respuesta:**
```json
{
  "timestamp": "2025-12-11T14:30:00",
  "status": 404,
  "error": "Not Found",
  "message": "User not found with id: 123",
  "path": "/api/v1/users/123",
  "errors": ["field1: validation message"]
}
```

**Excepciones Personalizadas:**

| Servicio | Excepciones |
|----------|-------------|
| Auth | UserNotFoundException, InvalidCredentialsException |
| Account | AccountNotFoundException, InsufficientFundsException |
| Transaction | TransactionFailedException, InvalidAmountException |
| Loan | LoanNotFoundException, LoanAlreadyProcessedException |
| Pool | PoolNotFoundException, InvestmentNotFoundException |

**Códigos HTTP:**
- `400` - Bad Request (validación, datos inválidos)
- `401` - Unauthorized (credenciales inválidas)
- `404` - Not Found (recurso no encontrado)
- `409` - Conflict (operación conflictiva)
- `500` - Internal Server Error (error inesperado)

---

### 3. CORS Configuration 🌐

Configuración CORS completa para Flutter y Angular frontends.

**Orígenes Permitidos:**
- `http://localhost:*` (desarrollo local)
- `http://127.0.0.1:*` (localhost alternativo)
- `http://10.0.2.2:*` (Android emulator)

**Métodos Permitidos:**
- GET, POST, PUT, PATCH, DELETE, OPTIONS

**Headers:**
- Authorization headers habilitados
- Content-Type y Accept permitidos
- Credentials soportados

**Beneficios:**
- ✅ Flutter mobile app puede conectarse
- ✅ Angular web admin funciona sin CORS errors
- ✅ Testing desde diferentes puertos
- ✅ Android emulator soportado

---

### 4. Unit Testing Framework 🧪

Framework de tests unitarios con JUnit 5 y Mockito.

**Estadísticas:**
- 38 tests unitarios
- 7 clases de test
- Cobertura ~40% lógica de negocio

**Tests por Servicio:**
- Auth: 9 tests (user management, autenticación)
- Account: 7 tests (operaciones de cuenta)
- Transaction: 6 tests (transferencias, validaciones)
- Loan: 8 tests (ciclo de vida de préstamos)
- Pool: 9 tests (inversiones, retornos)

**Ejecutar Tests:**
```bash
# Un servicio
cd nuvoauth-service
./mvnw test

# Con coverage
./mvnw test jacoco:report
# Ver: target/site/jacoco/index.html
```

---

### 5. Configuraciones Estandarizadas ⚙️

Todas las configuraciones `application.yml` están estandarizadas.

**Incluye:**
- ✅ SpringDoc OpenAPI paths
- ✅ Swagger UI habilitado
- ✅ Configuración JPA consistente
- ✅ Datasources uniformes

---

## 📖 Guías Rápidas

### Quick Start con Swagger

Ver [SWAGGER_QUICKSTART.md](./SWAGGER_QUICKSTART.md) para:
- Cómo acceder a Swagger UI
- Autenticarse con JWT
- Probar endpoints
- Generar clientes API

### Flutter Integration

Ver walkthrough para:
- 18 escenarios de prueba
- Checklist de verificación
- Endpoints configurados
- Troubleshooting

### Testing

Ver walkthroughs para:
- Patrones de testing
- Ejemplos de tests
- Mocking con Mockito
- AssertJ assertions

---

## 🔧 Comandos Útiles

### Iniciar Todos los Servicios

```bash
# Docker
docker-compose up -d

# Con script (incluye limpieza de redes)
./restart-services-with-swagger.sh
```

### Ver Logs

```bash
# Todos los servicios
docker-compose logs -f

# Un servicio específico
docker-compose logs -f nuvo-auth-service
```

### Rebuild

```bash
# Rebuild específico
docker-compose up -d --no-deps --build nuvo-auth-service

# Rebuild todo
docker-compose up -d --build
```

---

## 📝 Notas de Desarrollo

### Para Producción

Antes de deployment:
- [ ] Cambiar CORS origins a dominios específicos
- [ ] Usar variables de entorno para DB credentials
- [ ] Habilitar HTTPS
- [ ] Configurar rate limiting
- [ ] Agregar monitoring (Prometheus + Grafana)

### Known Issues

**Docker iptables:**
- Issue conocido con iptables chains
- Workaround: limpiar redes Docker periódicamente
- No afecta funcionalidad del código

---

## 🎯 Próximas Mejoras Sugeridas

1. **API Gateway** - Centralizar routing
2. **Service Discovery** - Eureka para descubrimiento
3. **Circuit Breaker** - Resilience4j para tolerancia a fallos
4. **Rate Limiting** - Protección contra abuse
5. **CI/CD** - GitHub Actions para deployment automático

---

**Última Actualización:** 2025-12-11  
**Versión:** 2.0 (con Swagger, Error Handling, CORS, Tests)
