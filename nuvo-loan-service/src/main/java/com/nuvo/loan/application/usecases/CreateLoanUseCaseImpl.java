package com.nuvo.loan.application.usecases;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.model.LoanStatus;
import com.nuvo.loan.domain.ports.in.CreateLoanUseCase;
import com.nuvo.loan.domain.ports.out.LoanRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class CreateLoanUseCaseImpl implements CreateLoanUseCase {

    private final LoanRepositoryPort loanRepositoryPort;

    @Override
    @Transactional
    public Loan createLoan(Loan loan) {
        loan.setInterestRate(new BigDecimal("0.05")); // 5% interest rate default
        loan.setStatus(LoanStatus.PENDING);
        loan.setCreatedAt(LocalDateTime.now());
        loan.setPaidAmount(BigDecimal.ZERO);

        return loanRepositoryPort.save(loan);
    }
}
