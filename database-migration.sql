-- NUVO IP - Database Migration Script
-- Creates all necessary tables if they don't exist

-- ============================================
-- AUTH DATABASE
-- ============================================
\c nuvo_auth_db;

CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- ============================================
-- ACCOUNT DATABASE
-- ============================================
\c nuvo_account_db;

CREATE TABLE IF NOT EXISTS accounts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    account_number VARCHAR(50) UNIQUE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_accounts_number ON accounts(account_number);

-- ============================================
-- TRANSACTION DATABASE
-- ============================================
\c nuvo_transaction_db;

CREATE TABLE IF NOT EXISTS transactions (
    id BIGSERIAL PRIMARY KEY,
    source_user_id BIGINT,
    target_user_id BIGINT,
    amount DECIMAL(15,2) NOT NULL,
    type VARCHAR(20) NOT NULL,
    description TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_transactions_source ON transactions(source_user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_target ON transactions(target_user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_timestamp ON transactions(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type);

-- ============================================
-- LOAN DATABASE
-- ============================================
\c nuvo_loan_db;

CREATE TABLE IF NOT EXISTS loans (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    term_months INTEGER NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    paid_amount DECIMAL(15,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP,
    rejected_at TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_loans_user_id ON loans(user_id);
CREATE INDEX IF NOT EXISTS idx_loans_status ON loans(status);
CREATE INDEX IF NOT EXISTS idx_loans_created ON loans(created_at DESC);

-- ============================================
-- POOL DATABASE
-- ============================================
\c nuvo_pool_db;

CREATE TABLE IF NOT EXISTS pools (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    interest_rate_per_day DECIMAL(10,6) NOT NULL,
    max_participants INTEGER DEFAULT 100,
    current_participants INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS investments (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    pool_id BIGINT NOT NULL REFERENCES pools(id),
    invested_amount DECIMAL(15,2) NOT NULL,
    current_value DECIMAL(15,2),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    invested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    withdrawn_at TIMESTAMP,
    CONSTRAINT fk_pool FOREIGN KEY (pool_id) REFERENCES pools(id)
);

CREATE INDEX IF NOT EXISTS idx_investments_user_id ON investments(user_id);
CREATE INDEX IF NOT EXISTS idx_investments_pool_id ON investments(pool_id);
CREATE INDEX IF NOT EXISTS idx_investments_status ON investments(status);

-- ============================================
-- SAMPLE POOLS DATA
-- ============================================
INSERT INTO pools (name, description, interest_rate_per_day, max_participants, active)
VALUES 
    ('Standard Pool', 'Pool de inversión estándar con rendimiento moderado', 0.001, 100, TRUE),
    ('Premium Pool', 'Pool premium con mayor rendimiento', 0.0015, 50, TRUE),
    ('Conservative Pool', 'Pool conservador con bajo riesgo', 0.0005, 200, TRUE)
ON CONFLICT DO NOTHING;

-- ============================================
-- GRANTS (if needed)
-- ============================================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
