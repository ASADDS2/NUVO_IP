package com.nuvo.loan.domain.ports.in;

import com.nuvo.loan.domain.model.Loan;
import java.math.BigDecimal;

public interface PayLoanUseCase {
    Loan payLoan(Long loanId, BigDecimal amount);
}
