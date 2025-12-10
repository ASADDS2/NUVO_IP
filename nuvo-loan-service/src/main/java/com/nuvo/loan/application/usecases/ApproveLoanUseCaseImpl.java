package com.nuvo.loan.application.usecases;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.model.LoanStatus;
import com.nuvo.loan.domain.ports.in.ApproveLoanUseCase;
import com.nuvo.loan.domain.ports.out.AccountPort;
import com.nuvo.loan.domain.ports.out.LoanRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ApproveLoanUseCaseImpl implements ApproveLoanUseCase {

    private final LoanRepositoryPort loanRepositoryPort;
    private final AccountPort accountPort;

    @Override
    @Transactional
    public Loan approveLoan(Long loanId) {
        Loan loan = loanRepositoryPort.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found"));

        if (loan.getStatus() != LoanStatus.PENDING) {
            throw new RuntimeException("Loan is not pending");
        }

        loan.setStatus(LoanStatus.APPROVED);
        loan.setApprovedAt(LocalDateTime.now());

        // Deposit money to user account
        accountPort.deposit(loan.getUserId(), loan.getAmount());

        return loanRepositoryPort.save(loan);
    }
}
