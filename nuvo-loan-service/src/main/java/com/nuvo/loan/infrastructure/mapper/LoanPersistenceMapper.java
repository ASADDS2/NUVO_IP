package com.nuvo.loan.infrastructure.mapper;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.infrastructure.entities.LoanEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface LoanPersistenceMapper {
    LoanEntity toEntity(Loan domain);

    Loan toDomain(LoanEntity entity);
}
