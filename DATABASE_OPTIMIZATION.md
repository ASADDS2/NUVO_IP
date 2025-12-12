# NUVO IP - Database Optimization Guide

## 🚀 Guía de Optimización de Base de Datos

Estrategias para mejorar el performance de las consultas en NUVO IP.

---

## 📊 Índices Recomendados

### Índices ya creados en migration script:
- ✅ users(email) - Para login rápido
- ✅ accounts(user_id) - Join con users
- ✅ transactions(source_user_id, target_user_id) - Historial
- ✅ transactions(timestamp DESC) - Orden cronológico
- ✅ loans(user_id, status) - Filtros comunes
- ✅ investments(user_id, pool_id, status)

### Índices adicionales si es necesario:

```sql
-- Para búsquedas de cuenta por número
CREATE INDEX idx_account_number ON accounts(account_number);

-- Para reportes de transacciones por tipo
CREATE INDEX idx_transaction_type_timestamp ON transactions(type, timestamp DESC);

-- Para dashboard de préstamos
CREATE INDEX idx_loans_status_created ON loans(status, created_at DESC);
```

---

## 🔍 Query Optimization

### ❌ Evitar N+1 Queries

**Mal:**
```java
// Controller trae usuarios
List<User> users = userRepository.findAll();

// Para cada usuario, trae su cuenta (N queries!)
users.forEach(user -> {
    Account account = accountRepository.findByUserId(user.getId());
});
```

**Bien:**
```java
// Una sola query con JOIN
@Query("SELECT u, a FROM User u LEFT JOIN Account a ON a.userId = u.id")
List<Object[]> findUsersWithAccounts();
```

### ✅ Usar Paginación

**Mal:**
```java
List<Transaction> findAll(); // Trae TODAS las transacciones
```

**Bien:**
```java
Page<Transaction> findAll(Pageable pageable);

// En controller
Pageable pageable = PageRequest.of(0, 20, Sort.by("timestamp").descending());
Page<Transaction> transactions = repository.findAll(pageable);
```

### ✅ Projection para columnas específicas

**Mal:**
```java
// Trae TODO el objeto loan completo
@Query("SELECT l FROM Loan l WHERE l.userId = :userId")
List<Loan> findByUserId(Long userId);
```

**Bien (si solo necesitas ciertos campos):**
```java
// Solo ID y amount
@Query("SELECT new map(l.id as id, l.amount as amount) FROM Loan l WHERE l.userId = :userId")
List<Map> findLoanSummary(Long userId);
```

---

## 💾 Caching con Spring Cache

### 1. Agregar Dependencia

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

### 2. Habilitar Cache

```java
@SpringBootApplication
@EnableCaching
public class Application {
    // ...
}
```

### 3. Usar en Servicios

```java
@Service
public class PoolService {
    
    @Cacheable(value = "pools", key = "#id")
    public Pool findById(Long id) {
        return poolRepository.findById(id)
            .orElseThrow(() -> PoolNotFoundException.byId(id));
    }
    
    @Cacheable(value = "activePools")
    public List<Pool> getActivePools() {
        return poolRepository.findByActive(true);
    }
    
    @CacheEvict(value = "pools", key = "#id")
    public Pool updatePool(Long id, Pool pool) {
        // Cache se limpia automáticamente
        return poolRepository.save(pool);
    }
}
```

---

## 📈 Connection Pooling

### HikariCP (Ya incluido en Spring Boot)

**application.yml:**
```yaml
spring:
  datasource:
    type: com.zaxxer.hikari.HikariDataSource
    hikari:
      maximum-pool-size: 10
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
      pool-name: NuvoHikariPool
```

**Recomendaciones:**
- `maximum-pool-size`: Número de CPUs * 2
- `minimum-idle`: maximum-pool-size / 2
- Para desarrollo: 5-10 conexiones
- Para producción: 20-50 conexiones

---

## 🎯 Lazy vs Eager Loading

### Configuración en Entities

```java
@Entity
public class User {
    @OneToOne(fetch = FetchType.LAZY) // No cargar automáticamente
    private Account account;
    
    @OneToMany(fetch = FetchType.LAZY) // Cargar solo cuando se necesite
    private List<Transaction> transactions;
}
```

**Regla:** Usar LAZY por defecto, EAGER solo si SIEMPRE necesitas la relación.

---

## 📊 Monitoring de Performance

### 1. Habilitar SQL Logging

**application.yml (Development):**
```yaml
spring:
  jpa:
    show-sql: true
    properties:
      hibernate:
        format_sql: true
        use_sql_comments: true

logging:
  level:
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
```

### 2. Analizar Queries Lentas

Para PostgreSQL:
```sql
-- Habilitar log de queries lentas
ALTER SYSTEM SET log_min_duration_statement = '1000'; -- 1 segundo

-- Ver queries más lentas
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;
```

### 3. Métricas con Actuator

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,metrics,prometheus
  metrics:
    enable:
      jvm: true
      process: true
      hikaricp: true
```

Endpoint: `/actuator/metrics/hikaricp.connections.active`

---

## ✅ Checklist de Optimización

### Base de Datos
- [x] Índices en foreign keys
- [x] Índices en columnas de búsqueda frecuente
- [x] Índices compuestos para filtros comunes
- [ ] Particionamiento si tablas > 10M registros

### Queries
- [ ] Evitar SELECT *
- [ ] Usar paginación en listados
- [ ] Projection para campos específicos
- [ ] Batch inserts para múltiples registros

### Application
- [ ] Implementar caching (Redis/Hazelcast)
- [ ] Lazy loading configurado
- [ ] Connection pool optimizado
- [ ] Queries lentas monitoreadas

### Monitoreo
- [ ] Log de SQL en desarrollo
- [ ] Queries lentas identificadas
- [ ] Métricas de conexiones
- [ ] APM tool configurado (opcional)

---

## 🔧 Herramientas Útiles

### pgAdmin
Gestión visual de PostgreSQL
- Ver explain plans
- Analizar índices
- Monitorear queries

### IntelliJ Profiler
- Identificar queries N+1
- Ver stack traces de queries
- Performance profiling

### Hibernate Statistics
```java
@Bean
public SessionFactory sessionFactory(EntityManagerFactory emf) {
    SessionFactoryImpl sf = emf.unwrap(SessionFactoryImpl.class);
    sf.getStatistics().setStatisticsEnabled(true);
    return sf;
}
```

---

## 📝 Mejoras Implementadas

- ✅ Índices creados en migration script
- ✅ HikariCP configurado
- ⚠️ Caching pendiente (opcional)
- ⚠️ Monitoring avanzado pendiente

**Estado:** Optimizaciones básicas implementadas, avanzadas opcionales.
