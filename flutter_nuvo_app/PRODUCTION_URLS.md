# NUVO Mobile App - Production URLs Configuration

## Current Configuration Status
✅ **Updated**: December 15, 2025  
✅ **Environment**: Production (Render)  
✅ **Build**: Release APK compiled with production URLs

## Production API Endpoints

### 1. Auth Service
```
Base URL: https://nuvo-auth-service-vatj.onrender.com/api/v1
Service: nuvo-auth-service
```

**Endpoints:**
- `POST /auth/register` - User registration
- `POST /auth/authenticate` - User login
- `GET /auth/phone/{phone}` - Get user by phone number

### 2. Account Service
```
Base URL: https://nuvo-account-service-ogjc.onrender.com/api/v1
Service: nuvo-account-service
```

**Endpoints:**
- `GET /accounts/{userId}` - Get account details
- `POST /accounts` - Create new account

### 3. Transaction Service
```
Base URL: https://nuvo-transaction-service-81vq.onrender.com/api/v1
Service: nuvo-transaction-service
```

**Endpoints:**
- `GET /transactions/history/{userId}` - Transaction history
- `POST /transactions/deposit` - Deposit funds
- `POST /transactions/transfer` - Transfer funds

### 4. Loan Service
```
Base URL: https://nuvo-loan-service-a7fj.onrender.com/api/v1
Service: nuvo-loan-service
```

**Endpoints:**
- `POST /loans` - Request new loan
- `GET /loans/my-loans/{userId}` - Get user loans
- `POST /loans/{loanId}/pay` - Pay loan installment

### 5. Pool Service
```
Base URL: https://nuvo-pool-service-xl32.onrender.com/api/v1/pool
Pools URL: https://nuvo-pool-service-xl32.onrender.com/api/v1/pools
Service: nuvo-pool-service
```

**Endpoints:**
- `GET /pools/active` - Get active investment pools
- `GET /pools` - Get all pools with statistics
- `POST /pool/invest` - Invest in pool
- `GET /pool/my-investments/{userId}` - Get user investments
- `POST /pool/withdraw/{investmentId}` - Withdraw from pool
- `GET /pool/stats/{userId}` - Get investment statistics

## Configuration Location

The URLs are configured in:
```
File: lib/services/api_service.dart
Lines: 6-17
```

## Verification

All services have been verified as active and reachable on Render:
- ✅ Auth Service
- ✅ Account Service  
- ✅ Transaction Service
- ✅ Loan Service
- ✅ Pool Service

## Latest Build

**APK File**: `build/app/outputs/flutter-apk/app-release.apk`  
**Size**: 48 MB  
**Build Date**: December 15, 2025  
**Build Type**: Release (Production)  
**Optimization**: Tree-shaking enabled

## Important Notes

1. **Render Free Tier**: Services may experience cold starts (15-30 second delay on first request)
2. **Database**: All services share a single PostgreSQL database (nuvo-postgres)
3. **CORS**: Enabled for mobile app requests
4. **SSL**: All endpoints use HTTPS

## Testing Checklist

- [ ] User registration and login
- [ ] Account balance display
- [ ] Deposit functionality
- [ ] Transfer between users
- [ ] Loan request and approval
- [ ] Loan payment
- [ ] Pool investment
- [ ] Pool withdrawal
- [ ] Transaction history

## Support

For issues with production services:
1. Check Render dashboard: https://dashboard.render.com
2. Review service logs
3. Verify database connectivity
4. Check environment variables
