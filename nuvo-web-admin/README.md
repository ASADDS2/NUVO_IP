# NUVO Web Admin

Panel de administración para el sistema bancario NUVO, desarrollado con Angular 20 y TailwindCSS.

![NUVO Admin](https://img.shields.io/badge/Angular-20-red) ![TailwindCSS](https://img.shields.io/badge/TailwindCSS-3.x-blue) ![SweetAlert2](https://img.shields.io/badge/SweetAlert2-11.x-orange)

## 🚀 Características Implementadas

### 🎨 Diseño y UI/UX

- **Tema Oscuro Profesional**: Interfaz completamente rediseñada con paleta de colores oscura
  - Fondo principal: `#0D1117`
  - Tarjetas: `#161B22`
  - Bordes: `#30363D`
  - Acento verde: `#00E676`
  - Acento aqua: `#1ABC9C`

- **Animaciones Profesionales**:
  - `fadeInUp`: Entrada principal de componentes
  - `fadeIn`: Transiciones suaves
  - `slideInLeft`: Animación lateral
  - `scaleIn`: Para modales
  - `shimmer`: Efecto de carga skeleton
  - `stagger`: Animación escalonada en listas

- **Componentes Reutilizables**:
  - `.nuvo-card`: Tarjetas con hover effect
  - `.nuvo-badge`: Badges de estado (success, warning, info, danger)
  - `.nuvo-btn-primary`: Botones primarios
  - `.nuvo-table-row`: Filas de tabla con hover

### 📊 Dashboard

- Tarjetas de estadísticas en tiempo real:
  - Usuarios totales
  - Dinero custodiado
  - Préstamos activos
  - Pools activos
- Gráficas interactivas con Chart.js:
  - Crecimiento de usuarios (línea)
  - Estado de préstamos (barras horizontales)
  - Flujo de dinero (barras agrupadas)

### 👥 Gestión de Cuentas

- Vista de tabla con tema oscuro
- Tarjetas de resumen:
  - Total de cuentas
  - Cuentas activas
  - Balance total
- Columnas: ID Usuario, Número de Cuenta, Propietario, Saldo, Estado
- Modal de detalles con información del usuario y préstamos
- Carga dinámica de nombres de propietarios desde el servicio de auth

### 💳 Gestión de Préstamos

- Estadísticas en tiempo real:
  - Total prestado
  - Aprobados
  - Pendientes
  - Pagados
  - Rechazados
- Tabla con animaciones stagger
- **Acciones con SweetAlert2**:
  - Aprobar préstamo (confirmación verde)
  - Rechazar préstamo (confirmación roja)
  - Notificaciones de éxito/error
- Estados traducidos al español (PENDIENTE, APROBADO, PAGADO, RECHAZADO)
- Skeleton loading mientras carga

### 📈 Gestión de Pools de Inversión

- Estadísticas:
  - Total pools
  - Pools activos
  - Total inversores
- Tabla con información detallada:
  - Nombre e ID
  - Tasa diaria (%)
  - Barra de progreso de inversores
  - Total invertido y valor actual
  - Estado (ACTIVA/INACTIVA)
- **CRUD completo con SweetAlert2**:
  - Crear pool (modal oscuro)
  - Editar pool
  - Eliminar pool (con advertencia)
  - Activar/Desactivar pool
- Auto-refresh cada 10 segundos
- Todos los cambios se persisten en la base de datos

### 🔧 Servicios

- `DataService`: Comunicación con microservicios
  - Cuentas: `GET /api/v1/accounts`
  - Préstamos: `GET/PUT /api/v1/loans`
  - Pools: `GET/POST/PUT/DELETE /api/v1/pools`
  - Usuarios: `GET /api/v1/auth/{id}`
- Método `rejectLoan()` para rechazar préstamos

## 🛠️ Tecnologías

- **Angular 20** - Framework frontend
- **TailwindCSS 3** - Estilos utilitarios
- **SweetAlert2** - Modales y notificaciones
- **Chart.js + ng2-charts** - Gráficas
- **Lucide Angular** - Iconos

## 📦 Instalación

```bash
# Instalar dependencias
npm install --legacy-peer-deps

# Iniciar servidor de desarrollo
npm start
```

El servidor estará disponible en `http://localhost:4200`

## 🏗️ Estructura del Proyecto

```
src/
├── app/
│   ├── components/
│   │   └── layout/          # Sidebar y estructura principal
│   ├── pages/
│   │   ├── dashboard/       # Panel principal con gráficas
│   │   ├── accounts/        # Gestión de cuentas
│   │   ├── loans/           # Gestión de préstamos
│   │   ├── pool-management/ # CRUD de pools
│   │   ├── pool/            # Inversión en pools
│   │   ├── landing/         # Página de inicio
│   │   └── login/           # Autenticación
│   ├── services/
│   │   └── data.ts          # Servicio de comunicación con APIs
│   └── models/
│       └── pool.model.ts    # Interfaces de Pool
├── styles.css               # Estilos globales y animaciones
└── index.html
```

## 🔌 Microservicios Requeridos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| Auth Service | 8081 | Autenticación y usuarios |
| Account Service | 8082 | Gestión de cuentas |
| Transaction Service | 8083 | Transacciones |
| Loan Service | 8084 | Préstamos |
| Pool Service | 8085 | Pools de inversión |

## 📝 Scripts Disponibles

```bash
npm start       # Inicia servidor de desarrollo
npm run build   # Compila para producción
npm test        # Ejecuta tests unitarios
```

## 🎯 Próximas Mejoras

- [ ] Notificaciones en tiempo real
- [ ] Exportar reportes a PDF/Excel
- [ ] Modo claro/oscuro toggle
- [ ] Paginación en tablas
- [ ] Filtros avanzados

---

Desarrollado con ❤️ para NUVO Banking System
