package com.nuvo.loan.infrastructure.mapper;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.infrastructure.dto.LoanRequest;
import com.nuvo.loan.infrastructure.dto.LoanResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface LoanWebMapper {
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "approvedAt", ignore = true)
    @Mapping(target = "paidAmount", ignore = true)
    @Mapping(target = "interestRate", ignore = true)
    Loan toDomain(LoanRequest request);

    LoanResponse toResponse(Loan domain);
}
