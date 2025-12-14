#!/bin/bash

# NUVO IP - Traffic Generator
# Simulates user activity to generate production-like data

echo "========================================="
echo "NUVO IP - Generating Traffic"
echo "========================================="
echo ""

# Base URLs
AUTH_URL="http://localhost:8081/api/v1/auth"
ACCOUNT_URL="http://localhost:8082/api/v1/accounts"
TRANSACTION_URL="http://localhost:8083/api/v1/transactions"
LOAN_URL="http://localhost:8084/api/v1/loans"
POOL_URL="http://localhost:8085/api/v1/pool"

# 1. Register Users
echo "1. Registering Users..."
curl -s -X POST "$AUTH_URL/register" -H "Content-Type: application/json" -d '{"firstname": "Juan", "lastname": "Pérez", "email": "juan@test.com", "phone": "1234567890", "password": "password123", "role": "USER"}' > /dev/null
curl -s -X POST "$AUTH_URL/register" -H "Content-Type: application/json" -d '{"firstname": "María", "lastname": "García", "email": "maria@test.com", "phone": "0987654321", "password": "password123", "role": "USER"}' > /dev/null
# New user for Loan test to avoid restrictions
TIMESTAMP=$(date +%s)
NEW_USER_EMAIL="carlos_$TIMESTAMP@test.com"
curl -s -X POST "$AUTH_URL/register" -H "Content-Type: application/json" -d "{\"firstname\": \"Carlos\", \"lastname\": \"Lopez\", \"email\": \"$NEW_USER_EMAIL\", \"phone\": \"5555555555\", \"password\": \"password123\", \"role\": \"USER\"}" > /dev/null

echo "✓ Users ensured (including new user $NEW_USER_EMAIL)"

# 2. Get User IDs
echo "2. Fetching User IDs..."
ACCOUNTS_JSON=$(curl -s "$ACCOUNT_URL")

# Extract IDs using python
USER1_ID=$(echo $ACCOUNTS_JSON | python3 -c "import sys, json; data=json.load(sys.stdin); print([a['userId'] for a in data if a['userId'] == 52][0]) if any(a['userId'] == 52 for a in data) else print(data[0]['userId'])")
# Just grab the last one for the new user
NEW_USER_ID=$(echo $ACCOUNTS_JSON | python3 -c "import sys, json; data=json.load(sys.stdin); print(data[-1]['userId'])")

echo "✓ User 1 ID: $USER1_ID"
echo "✓ New User ID: $NEW_USER_ID"

# 3. Deposits (Via Transaction Service to record history)
echo "3. Processing Deposits..."
# Deposit 5000 to User 1
curl -s -X POST "$TRANSACTION_URL/deposit?userId=$USER1_ID&amount=5000" > /dev/null
echo "✓ Deposited \$5000 to User 1"

# Deposit 3000 to New User
curl -s -X POST "$TRANSACTION_URL/deposit?userId=$NEW_USER_ID&amount=3000" > /dev/null
echo "✓ Deposited \$3000 to New User"

# 4. Transfers
echo "4. Processing Transfers..."
# User 1 transfers 500 to New User
curl -s -X POST "$TRANSACTION_URL/transfer" -H "Content-Type: application/json" -d "{\"sourceUserId\": $USER1_ID, \"targetUserId\": $NEW_USER_ID, \"amount\": 500}" > /dev/null
echo "✓ User 1 transferred \$500 to New User"

# 5. Investments
echo "5. Processing Investments..."
# Try to withdraw from Pool 1 first (blindly try investment ID 1, or just skip if fail)
# Actually, let's just invest in Pool 2 or 3.
# Or better, check if User 1 has investments and withdraw them.
INVESTMENTS_JSON=$(curl -s "$POOL_URL/my-investments/$USER1_ID")
INV_ID=$(echo $INVESTMENTS_JSON | python3 -c "import sys, json; data=json.load(sys.stdin); print(data[0]['id']) if len(data)>0 else print('')")

if [ ! -z "$INV_ID" ]; then
    echo "Found active investment #$INV_ID. Withdrawing..."
    curl -s -X POST "$POOL_URL/withdraw/$INV_ID" > /dev/null
    echo "✓ Withdrew investment #$INV_ID"
fi

# Now Invest
curl -s -X POST "$POOL_URL/invest" -H "Content-Type: application/json" -d "{\"userId\": $USER1_ID, \"poolId\": 1, \"amount\": 1000}" > /dev/null
echo "✓ User 1 invested \$1000 in Pool 1"

# 6. Loans
echo "6. Processing Loans..."
# New User requests a loan
LOAN_RESPONSE=$(curl -s -X POST "$LOAN_URL" -H "Content-Type: application/json" -d "{\"userId\": $NEW_USER_ID, \"amount\": 2000, \"termMonths\": 12}")
LOAN_ID=$(echo $LOAN_RESPONSE | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

if [ ! -z "$LOAN_ID" ]; then
    echo "✓ New User requested loan #$LOAN_ID of \$2000"
    
    # Approve Loan
    curl -s -X PUT "$LOAN_URL/$LOAN_ID/approve" > /dev/null
    echo "✓ Loan #$LOAN_ID approved"
else
    echo "⚠ Failed to request loan. Response: $LOAN_RESPONSE"
fi

echo ""
echo "Traffic generation complete!"
