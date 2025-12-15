package com.nuvo.loan.domain.ports.in;

import com.nuvo.loan.domain.model.Loan;

public interface RejectLoanUseCase {
    Loan rejectLoan(Long loanId);
}
