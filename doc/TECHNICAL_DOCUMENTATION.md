# TECHNICAL DOCUMENTATION - NUVO

**Team Name:** NUVO Team

## 1. General and Specific Objectives

### 1.1 General Objective
To develop a comprehensive and scalable banking system based on microservices architecture that facilitates the management of financial products (accounts, loans, investments) and transactions, providing a secure and efficient user experience through a modern web interface and mobile application.

### 1.2 Specific Objectives
- **Implement a Microservices Architecture:** Decompose the system into independent, loosely coupled services (Auth, Account, Transaction, Loan, Pool) to ensure scalability and maintainability.
- **Secure the Platform:** Implement robust authentication and authorization mechanisms using JWT (JSON Web Tokens) and Spring Security to protect user data and financial transactions.
- **Streamline Financial Operations:** Automate the processing of transfers, deposits, and loan management to reduce manual intervention and errors.
- **Enable Investment Opportunities:** Create a dynamic investment pool system that calculates compound interest in real-time, encouraging user savings and investment.
- **Provide Cross-Platform Access:** Deliver a consistent user experience across a responsive Angular web application and a Flutter mobile app.
- **Ensure Data Integrity:** Utilize transactional consistency patterns and isolated databases for each microservice to maintain accurate financial records.

## 2. Problem Statement and Scope

### 2.1 Problem Statement
Traditional monolithic banking systems often suffer from scalability issues, high maintenance costs, and slow deployment cycles. As user bases grow and feature requirements evolve, these systems become difficult to update and prone to single points of failure. Furthermore, users increasingly demand real-time financial services, secure access from multiple devices, and transparent investment options that traditional systems struggle to provide efficiently. There is a need for a modern, modular solution that can adapt to changing market demands while ensuring high security and performance.

### 2.2 Scope
The NUVO project encompasses the design, development, and deployment of a full-stack banking solution.
- **Backend:** A suite of Spring Boot microservices handling core business logic:
    - **Auth Service:** User registration, login, and token management.
    - **Account Service:** Bank account creation, balance tracking, and status management.
    - **Transaction Service:** Money transfers, deposits, and transaction history.
    - **Loan Service:** Loan application, approval workflows, and payment processing.
    - **Pool Service:** Investment portfolio management and interest calculation.
- **Frontend:** An Angular-based web administration panel for users and administrators to manage accounts and view statistics.
- **Mobile:** A Flutter mobile application for users to perform day-to-day banking operations.
- **Infrastructure:** Dockerized deployment with PostgreSQL databases and automated CI/CD pipelines (Render).

**Out of Scope:**
- Integration with external real-world banking networks (SWIFT, ACH).
- Physical card management.
- Third-party payment gateway integrations (e.g., Stripe, PayPal) beyond internal simulation.

## 3. User Stories

### 3.1 Authentication & Security
**US-01: User Registration**
*As a new user, I want to register with my personal details so that I can access the banking services.*
- **Acceptance Criteria:**
    - User provides name, email, and password.
    - Email must be unique.
    - Password must be encrypted.
    - Account is created with a default role (USER).

**US-02: Secure Login**
*As a registered user, I want to log in securely using my credentials so that I can access my account.*
- **Acceptance Criteria:**
    - User enters email and password.
    - System validates credentials.
    - On success, a JWT token is issued.
    - On failure, an appropriate error message is displayed.

### 3.2 Account Management
**US-03: View Account Balance**
*As a user, I want to see my current account balance so that I know my financial status.*
- **Acceptance Criteria:**
    - Balance is displayed on the dashboard.
    - Balance updates in real-time after transactions.

**US-04: Account History**
*As a user, I want to view a list of my past transactions so that I can track my spending.*
- **Acceptance Criteria:**
    - List shows date, type, amount, and counterparty.
    - Support for pagination or scrolling.

### 3.3 Transactions
**US-05: Fund Transfer**
*As a user, I want to transfer money to another user so that I can make payments.*
- **Acceptance Criteria:**
    - User specifies recipient email/ID and amount.
    - System checks for sufficient funds.
    - Transaction is atomic (deducted from sender, added to receiver).
    - Confirmation message upon success.

### 3.4 Loans
**US-06: Apply for Loan**
*As a user, I want to apply for a loan so that I can get financial assistance.*
- **Acceptance Criteria:**
    - User specifies amount and term.
    - Application status is set to PENDING.
    - Admin receives notification (or sees it in admin panel).

**US-07: Approve/Reject Loan (Admin)**
*As an administrator, I want to review loan applications so that I can manage risk.*
- **Acceptance Criteria:**
    - Admin sees list of pending loans.
    - Admin can approve or reject a loan.
    - Upon approval, funds are deposited to user account.

### 3.5 Investment Pool
**US-08: Invest Funds**
*As a user, I want to invest money in the pool so that I can earn interest.*
- **Acceptance Criteria:**
    - User selects amount to invest.
    - Funds are deducted from main account.
    - Investment becomes ACTIVE.

**US-09: Withdraw Investment**
*As a user, I want to withdraw my investment and earnings so that I can use my money.*
- **Acceptance Criteria:**
    - User sees total accumulated value.
    - User can request withdrawal.
    - Principal + Interest is credited back to main account.
