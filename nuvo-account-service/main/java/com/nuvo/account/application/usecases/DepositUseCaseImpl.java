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
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("El monto del depósito debe ser mayor a cero");
        }

        // Find account
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cuenta no encontrada para userId: " + userId));

        // Update balance
        account.setBalance(account.getBalance().add(amount));

        // Save and return
        return accountRepository.save(account);
    }
}
