# 🚀 NUVO - Technical Pitch & Team Roles

This document outlines the technical contributions and specialized roles of the engineering team behind the NUVO banking platform.

## 👥 The Team

### 👨‍💻 Jonathan - Backend Architect
**Role:** Core Systems & Security Specialist
**Technical Contributions:**
- **Microservices Architecture:** Designed the foundational architecture for the `Auth` and `Account` services using Spring Boot.
- **Security Implementation:** Implemented the JWT (JSON Web Token) authentication flow and Spring Security configurations to ensure robust data protection.
- **Transactional Integrity:** Engineered the atomic transaction handling in the `Transaction Service` to guarantee consistency in fund transfers and deposits.
- **API Gateway Design:** Defined the inter-service communication patterns using OpenFeign.

### 👨‍💻 Reinaldo Leal - Frontend Lead
**Role:** UI/UX & Cross-Platform Developer
**Technical Contributions:**
- **Web Admin Dashboard:** Built the comprehensive administrative interface using **Angular 17+**, implementing complex data visualization and state management with RxJS.
- **Mobile Application:** Developed the **Flutter** mobile app, ensuring a native-like experience on Android and iOS.
- **API Integration:** Orchestrated the consumption of RESTful APIs across both web and mobile platforms, handling error states and loading skeletons.
- **Responsive Design:** Implemented a fluid design system that adapts seamlessly to different screen sizes and devices.

### 👨‍💻 Sebastian Arnache - Backend Specialist
**Role:** Business Logic & Data Optimization
**Technical Contributions:**
- **Complex Business Logic:** Developed the `Loan Service` and `Pool Service`, implementing the algorithms for credit approval and compound interest calculations.
- **Database Optimization:** Designed efficient SQL schemas for PostgreSQL, optimizing queries for high-volume transaction history retrieval.
- **Scheduled Tasks:** Implemented Spring Scheduler jobs for automatic interest accrual and loan payment tracking.
- **Error Handling:** Standardized global exception handling across microservices to provide consistent API error responses.

### 👨‍💻 Felipe - Analytics & Data Strategy
**Role:** Data Analyst & Insights
**Technical Contributions:**
- **Data Modeling:** Designed the analytical data models to track user growth, transaction volumes, and system usage.
- **Financial Reporting:** Defined the logic for generating financial statements and balance sheets from raw transaction data.
- **Fraud Detection Logic:** Established the parameters and patterns for identifying suspicious transaction activities.
- **KPI Definition:** Defined Key Performance Indicators (KPIs) for the investment pool performance and loan default rates.

---

## 🎯 Project Technical Highlights

- **Architecture:** Event-driven Microservices
- **Backend:** Java 17, Spring Boot 3.2, Spring Cloud
- **Frontend:** Angular (Web), Flutter (Mobile)
- **Database:** PostgreSQL (Dockerized, Multi-schema)
- **Deployment:** Render (CI/CD Automated)
