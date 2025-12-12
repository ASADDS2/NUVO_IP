package com.nuvo.account.application.usecases;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.in.CreateAccountUseCase;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class CreateAccountUseCaseImpl implements CreateAccountUseCase {

    private final AccountRepositoryPort accountRepository;

    @Override
    public Account createAccount(Account account) {
        // Business logic: generate account number, set initial balance and timestamps
        account.setAccountNumber(generateAccountNumber());
        account.setBalance(BigDecimal.ZERO);
        account.setCreatedAt(LocalDateTime.now());
        return accountRepository.save(account);
    }

    private String generateAccountNumber() {
        return "ACC" + System.currentTimeMillis() + new Random().nextInt(1000);
    }
}
