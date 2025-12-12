package com.nuvo.loan.exception;

/**
 * Exception thrown when attempting to process a loan that has already been
 * processed
 */
public class LoanAlreadyProcessedException extends RuntimeException {

    public LoanAlreadyProcessedException(String message) {
        super(message);
    }

    public static LoanAlreadyProcessedException withId(Long loanId, String status) {
        return new LoanAlreadyProcessedException(
                String.format("Loan %d has already been processed with status: %s", loanId, status));
    }
}
