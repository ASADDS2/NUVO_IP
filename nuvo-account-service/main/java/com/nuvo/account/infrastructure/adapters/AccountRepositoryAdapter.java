package com.nuvo.account.infrastructure.adapters;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import com.nuvo.account.infrastructure.entities.AccountEntity;
import com.nuvo.account.infrastructure.mapper.AccountPersistenceMapper;
import com.nuvo.account.infrastructure.repositories.JpaAccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class AccountRepositoryAdapter implements AccountRepositoryPort {

    private final JpaAccountRepository repository;
    private final AccountPersistenceMapper mapper;

    @Override
    public Account save(Account account) {
        AccountEntity entity = mapper.toEntity(account);
        AccountEntity saved = repository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Account> findByUserId(Integer userId) {
        return repository.findByUserId(userId).map(mapper::toDomain);
    }

    @Override
    public List<Account> findAll() {
        return repository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
