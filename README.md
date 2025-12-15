# 🏦 NUVO - Microservices Banking System

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.3-green.svg)](https://spring.io/projects/spring-boot)
[![Angular](https://img.shields.io/badge/Angular-20.3.6-red.svg)](https://angular.io/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A modern banking system built with microservices architecture, designed to provide complete financial services including account management, transactions, loans, and investments.

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Technologies](#-technologies)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [API Endpoints](#-api-endpoints)
- [Database](#-database)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### 🔐 Authentication & Security
- JWT-based authentication
- User roles (ADMIN, USER)
- End-to-end security with Spring Security

### 💰 Account Management
- Creation and administration of bank accounts
- Real-time balance inquiry
- Transaction history

### 💸 Transactions
- Transfers between users
- Deposits
- Complete transaction history
- Balance validations

### 🏦 Loans
- Loan applications
- Loan approval/rejection
- Payment tracking
- Automatic interest calculation
- Statuses: PENDING, APPROVED, REJECTED, PAID

### 📈 Investment Pool
- Investment system with profitability
- Compound interest calculated per minute
- Withdrawal of investments with earnings
- Tracking of active investments

## 🏗️ Architecture

The system is composed of 5 independent microservices and an Angular frontend:

```
┌─────────────────────────────────────────────────────────────┐
│                     Angular Frontend                         │
│                   (Port 4200)                                │
└────────────┬────────────────────────────────────────────────┘
             │
             ├──────────────────────────────────────┐
             │                                      │
   ┌─────────▼──────────┐              ┌──────────▼─────────┐
   │  Auth Service      │              │  Account Service   │
   │   (Port 8091)      │              │   (Port 8082)      │
   └─────────┬──────────┘              └──────────┬─────────┘
             │                                    │
   ┌─────────▼──────────┐              ┌─────────▼──────────┐
   │Transaction Service │              │   Loan Service     │
   │   (Port 8086)      │              │   (Port 8084)      │
   └────────────────────┘              └────────────────────┘
                         ┌──────────────────┐
                         │  Pool Service    │
                         │  (Port 8085)     │
                         └──────────────────┘
```

### Microservices

| Service | Port | Database | Description |
|---------|------|----------|-------------|
| **auth-service** | 8091 | nuvo_auth_db | Authentication and user management |
| **account-service** | 8082 | nuvo_account_db | Bank account management |
| **transaction-service** | 8086 | nuvo_transaction_db | Transaction processing |
| **loan-service** | 8084 | nuvo_loan_db | Loan management |
| **pool-service** | 8085 | nuvo_pool_db | Investment system |
| **nuvo-web-admin** | 4200 | - | Angular User Interface |

## 🛠️ Technologies

### Backend
- **Java 17**
- **Spring Boot 3.2.3**
- **Spring Security** - Security and authentication
- **Spring Data JPA** - Persistence
- **Hibernate** - ORM
- **SpringDoc OpenAPI 2.3.0** - API Documentation (Swagger)
- **JUnit 5 + Mockito** - Unit testing
- **Bean Validation** - Data validation
- **JWT** - JSON Web Tokens
- **OpenFeign** - Declarative HTTP client
- **Lombok** - Boilerplate code reduction
- **Maven** - Dependency management

### Frontend
- **Angular 20.3.6**
- **TypeScript**
- **RxJS**
- **Angular Material** (optional)

### Database
- **MySQL/MariaDB 10.6+** or **PostgreSQL**
- Multi-database architecture (one database per microservice)

## 📦 Prerequisites

Before starting, ensure you have installed:

- ☕ **Java JDK 17** or higher
- 📦 **Maven 3.6+**
- 🗄️ **PostgreSQL** (via Docker recommended)
- 🟢 **Node.js 18+** and **npm**
- 📱 **Angular CLI** (`npm install -g @angular/cli`)
- 🐳 **Docker**

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/ASADDS2/NUVO_IP.git
cd NUVO_IP
```

### 2. Configure the Database

The project uses Docker for the database.

```bash
# Start PostgreSQL container
docker run -d --name nuvo_postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=1234 -v postgres_data:/var/lib/postgresql/data -p 5444:5432 postgres:16-alpine
```

### 3. Build the Microservices

```bash
# Build all microservices
cd nuvo-auth-service && ./mvnw clean install -DskipTests && cd ..
cd nuvo-account-service && ./mvnw clean install -DskipTests && cd ..
cd nuvo-transaction-service && ./mvnw clean install -DskipTests && cd ..
cd nuvo-loan-service && ./mvnw clean install -DskipTests && cd ..
cd nuvo-pool-service && ./mvnw clean install -DskipTests && cd ..
```

### 4. Install Frontend Dependencies

```bash
cd nuvo-web-admin
npm install
cd ..
```

## 🎯 Usage

### Start All Services

We have provided a script to start all services automatically:

```bash
chmod +x start-all.sh
./start-all.sh
```

### Access the Application

Once all services are running:

🌐 **Frontend**: http://localhost:4200
📱 **Flutter App**: http://localhost:5000 (if running)

## 🔑 Test Users

| Email | Password | Role |
|-------|----------|------|
| **bruno@nuvo.com** | `password` | **ADMIN** |
| elena@nuvo.com | `password` | USER |
| juan@nuvo.com | `password` | USER |
| sofia@nuvo.com | `password` | USER |

## 📡 API Endpoints

### Auth Service (8091)

```
POST   /api/v1/auth/register  - Register new user
POST   /api/v1/auth/login     - Login
POST   /api/v1/auth/refresh   - Refresh token
```

### Account Service (8082)

```
GET    /api/v1/accounts                 - List all accounts
GET    /api/v1/accounts/{id}            - Get account by ID
GET    /api/v1/accounts/user/{userId}   - Get account by user
POST   /api/v1/accounts                 - Create new account
PUT    /api/v1/accounts/{id}            - Update account
DELETE /api/v1/accounts/{id}            - Delete account
POST   /api/v1/accounts/{userId}/deposit - Deposit/Withdraw
```

### Transaction Service (8086)

```
GET    /api/v1/transactions              - List all transactions
GET    /api/v1/transactions/{id}         - Get transaction by ID
GET    /api/v1/transactions/user/{userId} - User transactions
POST   /api/v1/transactions/transfer     - Make transfer
POST   /api/v1/transactions/deposit      - Make deposit
```

### Loan Service (8084)

```
GET    /api/v1/loans                 - List all loans
GET    /api/v1/loans/{id}            - Get loan by ID
GET    /api/v1/loans/user/{userId}   - User loans
POST   /api/v1/loans                 - Apply for loan
PUT    /api/v1/loans/{id}/approve    - Approve loan
PUT    /api/v1/loans/{id}/reject     - Reject loan
PUT    /api/v1/loans/{id}/pay        - Make payment
```

### Pool Service (8085)

```
GET    /api/v1/pool                      - List all investments
GET    /api/v1/pool/my-investments/{userId} - User investments
GET    /api/v1/pool/stats/{userId}       - Investment stats
POST   /api/v1/pool/invest               - Make investment
POST   /api/v1/pool/withdraw/{id}        - Withdraw investment
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
