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
        // Check for existing loans
        java.util.List<Loan> userLoans = loanRepositoryPort.findByUserId(loan.getUserId());

        for (Loan existing : userLoans) {
            if (existing.getStatus() == LoanStatus.PENDING || existing.getStatus() == LoanStatus.APPROVED) {
                throw new RuntimeException("Usuario ya tiene un préstamo activo o pendiente");
            }
            if (existing.getStatus() == LoanStatus.REJECTED) {
                if (existing.getCreatedAt().isAfter(LocalDateTime.now().minusMinutes(10))) {
                    throw new RuntimeException(
                            "Debe esperar 10 minutos después de un rechazo para solicitar otro préstamo");
                }
            }
        }

        loan.setInterestRate(new BigDecimal("0.05")); // 5% interest rate default
        loan.setStatus(LoanStatus.PENDING);
        loan.setCreatedAt(LocalDateTime.now());
        loan.setPaidAmount(BigDecimal.ZERO);

        return loanRepositoryPort.save(loan);
    }
}
