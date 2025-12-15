package com.nuvo.loan.exception;

/**
 * Exception thrown when a loan is not found
 */
public class LoanNotFoundException extends RuntimeException {

    public LoanNotFoundException(String message) {
        super(message);
    }

    public static LoanNotFoundException byId(Long id) {
        return new LoanNotFoundException("Loan not found with id: " + id);
    }

    public static LoanNotFoundException byUserId(Long userId) {
        return new LoanNotFoundException("No loans found for user id: " + userId);
    }
}
