package com.nuvo.loan.application.usecases;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.model.LoanStatus;
import com.nuvo.loan.domain.ports.in.RejectLoanUseCase;
import com.nuvo.loan.domain.ports.out.LoanRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class RejectLoanUseCaseImpl implements RejectLoanUseCase {

    private final LoanRepositoryPort loanRepositoryPort;

    @Override
    @Transactional
    public Loan rejectLoan(Long loanId) {
        Loan loan = loanRepositoryPort.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found"));

        if (loan.getStatus() != LoanStatus.PENDING) {
            throw new RuntimeException("Loan is not pending");
        }

        loan.setStatus(LoanStatus.REJECTED);

        return loanRepositoryPort.save(loan);
    }
}
