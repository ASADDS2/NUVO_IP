# NUVO IP - Docker Setup

Este documento explica cómo iniciar todos los microservicios usando Docker Compose.

## Requisitos Previos

- Docker instalado (version 20.10+)
- Docker Compose instalado (version 2.0+)
- Al menos 4GB de RAM disponible

## Iniciar Todos los Servicios

Para iniciar la base de datos y todos los microservicios con un solo comando:

```bash
docker-compose up -d
```

Este comando:
- Construye las imágenes Docker para cada microservicio (primera vez)
- Inicia PostgreSQL en el puerto 5444
- Inicia los 5 microservicios:
  - **nuvo-auth-service** → `http://localhost:8081`
  - **nuvo-account-service** → `http://localhost:8082`
  - **nuvo-transaction-service** → `http://localhost:8083`
  - **nuvo-loan-service** → `http://localhost:8084`
  - **nuvo-pool-service** → `http://localhost:8085`

## Ver Logs de los Servicios

Para ver los logs de todos los servicios:

```bash
docker-compose logs -f
```

Para ver logs de un servicio específico:

```bash
docker-compose logs -f nuvo-pool-service
```

## Detener los Servicios

Para detener todos los servicios:

```bash
docker-compose down
```

Para detener y eliminar los volúmenes (base de datos):

```bash
docker-compose down -v
```

## Rebuild de Servicios

Si realizas cambios en el código de algún microservicio, reconstruye su imagen:

```bash
# Rebuild de un servicio específico
docker-compose up -d --build nuvo-pool-service

# Rebuild de todos los servicios
docker-compose up -d --build
```

## Verificar Estado de los Servicios

```bash
docker-compose ps
```

## Health Checks

PostgreSQL tiene un health check configurado. Los microservicios solo se iniciarán cuando la base de datos esté lista.

## Troubleshooting

### Los servicios no inician

1. Verifica que los puertos no estén en uso:
```bash
lsof -i :8081,8082,8083,8084,8085,5444
```

2. Verifica los logs:
```bash
docker-compose logs
```

3. Rebuild las imágenes:
```bash
docker-compose up -d --build
```

### Error de conexión a base de datos

Espera unos segundos adicionales para que PostgreSQL termine de inicializar:

```bash
docker-compose logs postgres
```

### Liberar espacio en disco

Para limpiar imágenes y contenedores no utilizados:

```bash
docker system prune -a
```

## Arquitectura de Servicios

```
┌─────────────────────────────────────────┐
│         Flutter Mobile App              │
│        (localhost:flutter run)          │
└─────────────────┬───────────────────────┘
                  │
      ┌───────────┴───────────┐
      │                       │
      ▼                       ▼
┌───────────┐         ┌──────────────┐
│   Auth    │         │    Pool      │
│  Service  │         │   Service    │
│  :8081    │         │   :8085      │
└─────┬─────┘         └──────┬───────┘
      │                      │
      ▼                      ▼
┌───────────┐         ┌──────────────┐
│ Account   │         │ Transaction  │
│ Service   │         │   Service    │
│  :8082    │         │   :8083      │
└─────┬─────┘         └──────┬───────┘
      │                      │
      ▼                      ▼
┌───────────────────────────────────┐
│         PostgreSQL                │
│          :5444                    │
│  (5 databases: auth, account,     │
│   transaction, loan, pool)        │
└───────────────────────────────────┘
```

## Variables de Entorno

Cada microservicio está configurado con las siguientes variables de entorno:

- `SPRING_DATASOURCE_URL`: URL de conexión a PostgreSQL
- `SPRING_DATASOURCE_USERNAME`: Usuario de la base de datos
- `SPRING_DATASOURCE_PASSWORD`: Contraseña de la base de datos  
- `SPRING_JPA_HIBERNATE_DDL_AUTO`: Modo de actualización del schema (update)
- `SERVER_PORT`: Puerto en el que corre el servicio

Puedes modificar estas variables en el archivo `docker-compose.yml`.

## Acceso a la Base de Datos

Para conectarte a PostgreSQL desde tu máquina local:

```bash
psql -h localhost -p 5444 -U postgres
```

Password: `1234`

Para ver las bases de datos:

```sql
\l
```

Para conectarte a una base específica:

```sql
\c nuvo_pool
```

## Performance

La primera vez que ejecutes `docker-compose up` tomará varios minutos porque:
1. Descarga las imágenes base (Maven, OpenJDK)
2. Compila cada microservicio con Maven
3. Crea las imágenes Docker

Las ejecuciones posteriores serán mucho más rápidas (segundos) a menos que hayas cambiado el código.

## Production Note

> **⚠️ IMPORTANTE**: Esta configuración es para desarrollo local únicamente. Para producción, considera:
> - Usar imágenes pre-compiladas en un registry
> - Configurar variables de entorno sensibles de forma segura
> - Implementar health checks robustos
> - Configurar límites de recursos
> - Usar orquestadores como Kubernetes
