package com.nuvo.loan.application.usecases;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.model.LoanStatus;
import com.nuvo.loan.domain.ports.in.PayLoanUseCase;
import com.nuvo.loan.domain.ports.out.AccountPort;
import com.nuvo.loan.domain.ports.out.LoanRepositoryPort;
import com.nuvo.loan.infrastructure.client.TransactionClient;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
@RequiredArgsConstructor
public class PayLoanUseCaseImpl implements PayLoanUseCase {

    private final LoanRepositoryPort loanRepositoryPort;
    private final AccountPort accountPort;
    private final TransactionClient transactionClient;

    @Override
    @Transactional
    public Loan payLoan(Long loanId, BigDecimal amount) {
        Loan loan = loanRepositoryPort.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found"));

        if (loan.getStatus() != LoanStatus.APPROVED) {
            throw new RuntimeException("Loan is not active (APPROVED)");
        }

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Amount must be positive");
        }

        // Calculate total to pay (Principal + Interest)
        // Simple interest for the whole term for simplicity in this MVP
        // Total = Amount * (1 + InterestRate)
        BigDecimal totalToPay = loan.getAmount().multiply(BigDecimal.ONE.add(loan.getInterestRate()));
        BigDecimal remaining = totalToPay.subtract(loan.getPaidAmount());

        if (amount.compareTo(remaining) > 0) {
            amount = remaining; // Cap payment to remaining amount
        }

        // Deduct from user account (will throw if insufficient funds)
        accountPort.deposit(loan.getUserId(), amount.negate());

        // Update loan
        loan.setPaidAmount(loan.getPaidAmount().add(amount));

        // Check if fully paid (allow small epsilon for float errors if needed, but
        // using BigDecimal)
        if (loan.getPaidAmount().compareTo(totalToPay) >= 0) {
            loan.setStatus(LoanStatus.PAID);
        }

        // Save loan changes first
        Loan savedLoan = loanRepositoryPort.save(loan);

        // Record transaction - this is critical, so we log and throw if it fails
        try {
            transactionClient.createTransaction(
                    TransactionClient.CreateTransactionRequest.builder()
                            .userId(loan.getUserId())
                            .amount(amount.negate()) // Expense
                            .type("LOAN_PAYMENT")
                            .description("Pago de Préstamo #" + loan.getId())
                            .build());
            System.out.println("✓ Transaction recorded successfully for loan payment: "
                    + loan.getId() + ", amount: " + amount);
        } catch (Exception e) {
            System.err.println("✗ ERROR: Failed to record transaction for loan payment!");
            System.err.println("   Loan ID: " + loan.getId());
            System.err.println("   Amount: " + amount);
            System.err.println("   Error: " + e.getMessage());
            e.printStackTrace();
            // Re-throw to make the failure visible
            throw new RuntimeException("Failed to record loan payment transaction", e);
        }

        return savedLoan;
    }
}
