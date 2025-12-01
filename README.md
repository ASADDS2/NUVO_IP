# NUVO Transaction Service

The **NUVO Transaction Service** is a critical microservice within the NUVO ecosystem, dedicated to the secure and efficient processing of financial transactions. It acts as the backbone for all monetary operations, ensuring data integrity, consistency, and reliability.

## 🚀 Overview

This service is designed to handle high volumes of transactions with low latency. It supports various transaction types, including peer-to-peer transfers, payments, and internal system adjustments.

## ✨ Key Features

-   **Transaction Processing**: Real-time processing of credits and debits.
-   **History & Auditing**: Comprehensive transaction logs for auditing and user history.
-   **Status Tracking**: Detailed tracking of transaction states (PENDING, COMPLETED, FAILED).
-   **Security**: Implements robust security measures to prevent fraud and unauthorized access.
-   **Idempotency**: Ensures that the same transaction is not processed multiple times.

## 🛠️ Technology Stack

-   **Java 17**: The core programming language.
-   **Spring Boot**: Framework for building the microservice.
-   **PostgreSQL**: Relational database for storing transaction data.
-   **Maven**: Dependency management and build tool.

## ⚙️ Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Ensure you have the following installed:

-   [Java Development Kit (JDK) 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
-   [Maven](https://maven.apache.org/)
-   [PostgreSQL](https://www.postgresql.org/)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/ASADDS2/NUVO_IP.git
    ```

2.  **Navigate to the service directory:**
    ```bash
    cd NUVO/nuvo-transaction-service
    ```

3.  **Configure the database:**
    Update `src/main/resources/application.yml` with your PostgreSQL credentials.

4.  **Build the project:**
    ```bash
    ./mvnw clean install
    ```

### Running the Service

To run the application locally:

```bash
./mvnw spring-boot:run
```

The service will start on the default port (usually `8080` or as configured).

## 📡 API Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/transactions` | Initiate a new transaction |
| `GET` | `/api/transactions/{id}` | Get transaction details by ID |
| `GET` | `/api/transactions/user/{userId}` | Get transaction history for a user |

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## 📧 Contact

For any inquiries, please contact the development team.
