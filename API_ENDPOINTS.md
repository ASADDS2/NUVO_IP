# NUVO IP - API Endpoints Reference

## 📖 Guía Completa de Endpoints

Documentación de todos los endpoints disponibles en los 5 microservicios.

---

## 🔐 Auth Service (Port 8081)

Base URL: `http://localhost:8081/api/v1/auth`

### POST /register
Registrar nuevo usuario

**Request:**
```json
{
  "firstname": "Juan",
  "lastname": "Pérez",
  "email": "juan@example.com",
  "phone": "1234567890",
  "password": "securePassword123",
  "role": "USER"
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### POST /authenticate
Login de usuario

**Request:**
```json
{
  "email": "juan@example.com",
  "password": "securePassword123"
}
```

**Response:** `200 OK`
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "id": 1,
  "email": "juan@example.com",
  "role": "USER"
}
```

**Errors:**
- `401 Unauthorized` - Credenciales inválidas
- `404 Not Found` - Usuario no existe

---

## 💰 Account Service (Port 8082)

Base URL: `http://localhost:8082/api/v1/accounts`

### POST /
Crear nueva cuenta

**Request:**
```json
{
  "userId": 1
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "userId": 1,
  "accountNumber": "ACC-1-001",
  "balance": 0.00,
  "createdAt": "2025-12-11T10:00:00"
}
```

### GET /{id}
Obtener cuenta por ID

**Response:** `200 OK`
```json
{
  "id": 1,
  "userId": 1,
  "accountNumber": "ACC-1-001",
  "balance": 1500.00,
  "createdAt": "2025-12-11T10:00:00"
}
```

**Errors:**
- `404 Not Found` - Cuenta no existe

### GET /user/{userId}
Obtener cuenta por User ID

**Response:** `200 OK`
```json
{
  "id": 1,
  "userId": 1,
  "accountNumber": "ACC-1-001",
  "balance": 1500.00
}
```

---

## 💸 Transaction Service (Port 8083)

Base URL: `http://localhost:8083/api/v1/transactions`

### POST /deposit
Realizar depósito

**Query Params:**
- `userId` - ID del usuario
- `amount` - Monto a depositar

**Request:**
```
POST /deposit?userId=1&amount=1000.00
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "sourceUserId": 1,
  "amount": 1000.00,
  "type": "DEPOSIT",
  "timestamp": "2025-12-11T10:30:00"
}
```

**Errors:**
- `400 Bad Request` - Monto inválido (negativo o cero)

### POST /transfer
Transferir entre cuentas

**Request:**
```json
{
  "sourceAccountId": 1,
  "targetAccountId": 2,
  "amount": 500.00
}
```

**Response:** `200 OK`
```json
{
  "id": 2,
  "sourceUserId": 1,
  "targetUserId": 2,
  "amount": 500.00,
  "type": "TRANSFER",
  "timestamp": "2025-12-11T10:35:00"
}
```

**Errors:**
- `400 Bad Request` - Fondos insuficientes
- `404 Not Found` - Cuenta no encontrada

### GET /history/{userId}
Obtener historial de transacciones

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "sourceUserId": 1,
    "amount": 1000.00,
    "type": "DEPOSIT",
    "timestamp": "2025-12-11T10:30:00"
  },
  {
    "id": 2,
    "sourceUserId": 1,
    "targetUserId": 2,
    "amount": 500.00,
    "type": "TRANSFER",
    "timestamp": "2025-12-11T10:35:00"
  }
]
```

---

## 🏦 Loan Service (Port 8084)

Base URL: `http://localhost:8084/api/v1/loans`

### POST /
Solicitar préstamo

**Request:**
```json
{
  "userId": 1,
  "amount": 5000.00,
  "termMonths": 12
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "userId": 1,
  "amount": 5000.00,
  "termMonths": 12,
  "interestRate": 5.5,
  "status": "PENDING",
  "paidAmount": 0.00,
  "createdAt": "2025-12-11T11:00:00"
}
```

### GET /{id}
Obtener préstamo por ID

**Response:** `200 OK`
```json
{
  "id": 1,
  "userId": 1,
  "amount": 5000.00,
  "termMonths": 12,
  "interestRate": 5.5,
  "status": "APPROVED",
  "paidAmount": 1000.00,
  "createdAt": "2025-12-11T11:00:00",
  "approvedAt": "2025-12-11T11:05:00"
}
```

### PUT /{id}/approve
Aprobar préstamo (Admin)

**Response:** `200 OK`
```json
{
  "id": 1,
  "status": "APPROVED",
  "approvedAt": "2025-12-11T11:05:00"
}
```

**Errors:**
- `409 Conflict` - Préstamo ya procesado

### PUT /{id}/reject
Rechazar préstamo (Admin)

**Response:** `200 OK`
```json
{
  "id": 1,
  "status": "REJECTED"
}
```

### POST /{id}/payment
Realizar pago de préstamo

**Request:**
```json
{
  "amount": 500.00
}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "paidAmount": 1500.00,
  "remainingAmount": 3500.00
}
```

### GET /user/{userId}
Obtener préstamos del usuario

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "amount": 5000.00,
    "status": "APPROVED",
    "paidAmount": 1500.00
  }
]
```

---

## 📈 Pool Service (Port 8085)

Base URL: `http://localhost:8085/api/v1`

### GET /pools
Obtener todos los pools

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "name": "Standard Pool",
    "description": "Pool de inversión estándar",
    "interestRatePerDay": 0.001,
    "maxParticipants": 100,
    "currentParticipants": 45,
    "active": true
  }
]
```

### GET /pools/active
Obtener pools activos

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "name": "Standard Pool",
    "interestRatePerDay": 0.001,
    "active": true
  }
]
```

### POST /pool/invest
Invertir en pool

**Request:**
```json
{
  "userId": 1,
  "poolId": 1,
  "amount": 2000.00
}
```

**Response:** `201 Created`
```json
{
  "id": 1,
  "userId": 1,
  "poolId": 1,
  "investedAmount": 2000.00,
  "currentValue": 2000.00,
  "status": "ACTIVE",
  "investedAt": "2025-12-11T12:00:00"
}
```

### GET /pool/my-investments/{userId}
Obtener inversiones del usuario

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "poolName": "Standard Pool",
    "investedAmount": 2000.00,
    "currentValue": 2045.30,
    "profit": 45.30,
    "status": "ACTIVE",
    "investedAt": "2025-12-11T12:00:00"
  }
]
```

### POST /pool/withdraw/{investmentId}
Retirar inversión

**Response:** `200 OK`
```json
{
  "id": 1,
  "status": "WITHDRAWN",
  "finalAmount": 2045.30,
  "profit": 45.30,
  "withdrawnAt": "2025-12-11T14:00:00"
}
```

### GET /pool/stats/{userId}
Obtener estadísticas de inversiones

**Response:** `200 OK`
```json
{
  "totalInvested": 2000.00,
  "currentProfit": 45.30,
  "totalProjected": 2045.30,
  "activeInvestments": 1
}
```

---

## 🔒 Autenticación

Todos los endpoints (excepto `/auth/register` y `/auth/authenticate`) requieren JWT token.

**Header:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Obtener Token:**
1. Registrarse con `/auth/register` o
2. Login con `/auth/authenticate`
3. Usar el token en header Authorization

---

## 📊 Códigos de Estado HTTP

| Código | Significado | Uso |
|--------|-------------|-----|
| 200 | OK | Operación exitosa |
| 201 | Created | Recurso creado |
| 400 | Bad Request | Datos inválidos |
| 401 | Unauthorized | No autenticado |
| 404 | Not Found | Recurso no encontrado |
| 409 | Conflict | Operación conflictiva |
| 500 | Server Error | Error interno |

---

## 🧪 Pruebas con Swagger

La forma más fácil de probar estos endpoints es con Swagger UI:

1. Abrir Swagger: `http://localhost:808X/swagger-ui.html`
2. Click en "Authorize"
3. Ingresar token JWT
4. Probar endpoints directamente

---

## 📝 Ejemplos de Uso

### Flujo Completo de Usuario

```bash
# 1. Registrarse
POST /auth/register
{
  "firstname": "Juan",
  "email": "juan@test.com",
  "password": "pass123"
}

# 2. Login
POST /auth/authenticate
{
  "email": "juan@test.com",
  "password": "pass123"
}
# Guardar token

# 3. Depositar
POST /transactions/deposit?userId=1&amount=1000

# 4. Ver balance
GET /accounts/user/1

# 5. Invertir
POST /pool/invest
{
  "userId": 1,
  "poolId": 1,
  "amount": 500
}
```

---

**Versión:** 2.0  
**Última actualización:** 2025-12-11
