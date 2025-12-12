package com.nuvo.account.application.usecases;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.in.FindAccountByUserIdUseCase;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FindAccountByUserIdUseCaseImpl implements FindAccountByUserIdUseCase {

    private final AccountRepositoryPort accountRepository;

    @Override
    public Account findByUserId(Integer userId) {
        return accountRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cuenta no encontrada para userId: " + userId));
    }
}
