package com.nuvo.account.application.usecases;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.in.DepositUseCase;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class DepositUseCaseImpl implements DepositUseCase {

    private final AccountRepositoryPort accountRepository;

    @Override
    public Account deposit(Integer userId, BigDecimal amount) {
        // Business logic: validate amount
        // Allow negative amounts for withdrawals (used by other services)
        // If amount is negative, check if balance is sufficient
        if (amount.compareTo(BigDecimal.ZERO) < 0) {
            // We need to fetch the account first to check balance, so we move this check
            // after fetching account
        } else if (amount.compareTo(BigDecimal.ZERO) == 0) {
            throw new IllegalArgumentException("El monto debe ser diferente de cero");
        }

        // Find account
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cuenta no encontrada para userId: " + userId));

        if (amount.compareTo(BigDecimal.ZERO) < 0 && account.getBalance().add(amount).compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Fondos insuficientes");
        }

        // Update balance
        account.setBalance(account.getBalance().add(amount));

        // Save and return
        return accountRepository.save(account);
    }
}
