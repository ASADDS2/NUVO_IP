package com.nuvo.account.infrastructure.mapper;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.infrastructure.entities.AccountEntity;
import org.mapstruct.Mapper;

/**
 * Persistence mapper to convert between domain Account and persistence
 * AccountEntity.
 */
@Mapper(componentModel = "spring")
public interface AccountPersistenceMapper {

    AccountEntity toEntity(Account domain);

    Account toDomain(AccountEntity entity);
}
