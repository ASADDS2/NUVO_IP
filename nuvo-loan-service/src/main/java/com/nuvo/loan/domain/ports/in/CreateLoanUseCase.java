package com.nuvo.loan.domain.ports.in;

import com.nuvo.loan.domain.model.Loan;

public interface CreateLoanUseCase {
    Loan createLoan(Loan loan);
}
