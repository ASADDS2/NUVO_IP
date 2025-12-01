# NUVO Pool Service

The **NUVO Pool Service** is a core microservice within the NUVO ecosystem, dedicated to the efficient management of investment pools and liquidity. It facilitates the creation, monitoring, and administration of various pools, ensuring optimal asset allocation and tracking.

## 🚀 Overview

This service provides a robust platform for managing investment pools. It handles the lifecycle of pools, tracks user investments, and calculates returns, serving as the central hub for all pool-related activities.

## ✨ Key Features

-   **Pool Management**: Create, update, and delete investment pools.
-   **Investment Tracking**: Monitor user investments and pool performance in real-time.
-   **Liquidity Management**: Tools for managing pool liquidity and asset distribution.
-   **Status Monitoring**: Track the operational status of each pool (ACTIVE, CLOSED, PAUSED).
-   **Integration**: Seamlessly integrates with Account and Transaction services.

## 🛠️ Technology Stack

-   **Java 17**: The core programming language.
-   **Spring Boot**: Framework for building the microservice.
-   **PostgreSQL**: Relational database for storing pool and investment data.
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
    cd NUVO/nuvo-pool-service
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

The service will start on the default port (usually `8081` or as configured).

## 📡 API Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/pools` | Create a new pool |
| `GET` | `/api/pools` | List all available pools |
| `GET` | `/api/pools/{id}` | Get pool details by ID |
| `POST` | `/api/investments` | Create a new investment |

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## 📧 Contact

For any inquiries, please contact the development team.