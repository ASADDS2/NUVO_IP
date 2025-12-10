package com.nuvo.account.application.usecases;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.in.FindAllAccountsUseCase;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FindAllAccountsUseCaseImpl implements FindAllAccountsUseCase {

    private final AccountRepositoryPort accountRepository;

    @Override
    public List<Account> findAll() {
        return accountRepository.findAll();
    }
}
