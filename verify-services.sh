#!/bin/bash

# NUVO IP - Service Verification Script
# Verifica que todos los servicios estén corriendo correctamente

echo "========================================="
echo "NUVO IP - Service Verification"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check service
check_service() {
    local service_name=$1
    local port=$2
    local endpoint=$3
    
    echo -n "Checking $service_name (port $port)... "
    
    if curl -s -o /dev/null -w "%{http_code}" "http://localhost:$port$endpoint" | grep -q "200\|401\|404"; then
        echo -e "${GREEN}✓ OK${NC}"
        return 0
    else
        echo -e "${RED}✗ FAILED${NC}"
        return 1
    fi
}

# Check Docker
echo "Step 1: Checking Docker..."
if ! docker ps &> /dev/null; then
    echo -e "${RED}✗ Docker not running${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker is running${NC}"
echo ""

# Check services
echo "Step 2: Checking Microservices..."
check_service "Auth Service" "8081" "/actuator/health"
check_service "Account Service" "8082" "/actuator/health"
check_service "Transaction Service" "8083" "/actuator/health"
check_service "Loan Service" "8084" "/actuator/health"
check_service "Pool Service" "8085" "/actuator/health"
echo ""



# Check Database
echo "Step 4: Checking PostgreSQL..."
if docker ps | grep -q postgres; then
    echo -e "${GREEN}✓ PostgreSQL container running${NC}"
else
    echo -e "${RED}✗ PostgreSQL container not running${NC}"
fi
echo ""

# Summary
echo "========================================="
echo "Verification Complete!"
echo "========================================="
echo ""
echo "URLs to test:"

