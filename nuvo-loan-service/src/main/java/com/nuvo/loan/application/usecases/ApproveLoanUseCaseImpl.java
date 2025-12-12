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
    private final com.nuvo.loan.infrastructure.client.TransactionClient transactionClient;

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

        // Record transaction
        try {
            transactionClient.createTransaction(
                    com.nuvo.loan.infrastructure.client.TransactionClient.CreateTransactionRequest.builder()
                            .userId(loan.getUserId())
                            .amount(loan.getAmount())
                            .type("LOAN_DISBURSEMENT")
                            .description("Desembolso de Préstamo #" + loan.getId())
                            .build());
        } catch (Exception e) {
            System.err.println("Error recording transaction: " + e.getMessage());
        }

        return loanRepositoryPort.save(loan);
    }
}
