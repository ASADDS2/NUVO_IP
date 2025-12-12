#!/bin/bash

# NUVO IP - Test Data Generator
# Genera datos de prueba para todos los servicios

echo "========================================="
echo "NUVO IP - Generating Test Data"
echo "========================================="
echo ""

# Base URLs
AUTH_URL="http://localhost:8081/api/v1/auth"
ACCOUNT_URL="http://localhost:8082/api/v1/accounts"
TRANSACTION_URL="http://localhost:8083/api/v1/transactions"
LOAN_URL="http://localhost:8084/api/v1/loans"
POOL_URL="http://localhost:8085/api/v1"

# Test users
echo "Creating test users..."

# User 1
curl -X POST "$AUTH_URL/register" \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "Juan",
    "lastname": "Pérez",
    "email": "juan@test.com",
    "phone": "1234567890",
    "password": "password123",
    "role": "USER"
  }' 2>/dev/null

echo "✓ User 1 created: juan@test.com"

# User 2
curl -X POST "$AUTH_URL/register" \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "María",
    "lastname": "García",
    "email": "maria@test.com",
    "phone": "0987654321",
    "password": "password123",
    "role": "USER"
  }' 2>/dev/null

echo "✓ User 2 created: maria@test.com"

# User 3 (Admin)
curl -X POST "$AUTH_URL/register" \
  -H "Content-Type: application/json" \
  -d '{
    "firstname": "Admin",
    "lastname": "System",
    "email": "admin@test.com",
    "phone": "1111111111",
    "password": "admin123",
    "role": "ADMIN"
  }' 2>/dev/null

echo "✓ User 3 created: admin@test.com (ADMIN)"

echo ""
echo "Test data generation complete!"
echo ""
echo "Test Credentials:"
echo "- juan@test.com / password123"
echo "- maria@test.com / password123"
echo "- admin@test.com / admin123 (ADMIN)"
echo ""
echo "Next steps:"
echo "1. Login with these credentials"

echo "3. Create transactions, loans, investments"
