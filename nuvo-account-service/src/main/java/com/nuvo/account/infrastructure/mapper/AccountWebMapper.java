package com.nuvo.account.infrastructure.mapper;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.infrastructure.dto.CreateAccountRequest;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

/**
 * Web mapper to convert between DTOs and domain models.
 */
@Mapper(componentModel = "spring")
public interface AccountWebMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "accountNumber", ignore = true)
    @Mapping(target = "balance", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    Account toDomain(CreateAccountRequest request);
}
