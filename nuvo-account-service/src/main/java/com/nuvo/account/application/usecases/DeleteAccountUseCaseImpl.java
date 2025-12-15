package com.nuvo.account.application.usecases;

import com.nuvo.account.domain.ports.in.DeleteAccountUseCase;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class DeleteAccountUseCaseImpl implements DeleteAccountUseCase {

    private final AccountRepositoryPort accountRepository;

    @Override
    public void deleteById(Long id) {
        accountRepository.deleteById(id);
    }
}
