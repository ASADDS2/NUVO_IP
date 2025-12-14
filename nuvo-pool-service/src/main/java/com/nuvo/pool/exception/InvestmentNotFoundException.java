package com.nuvo.pool.exception;

/**
 * Exception thrown when an investment is not found
 */
public class InvestmentNotFoundException extends RuntimeException {

    public InvestmentNotFoundException(String message) {
        super(message);
    }

    public static InvestmentNotFoundException byId(Long id) {
        return new InvestmentNotFoundException("Investment not found with id: " + id);
    }

    public static InvestmentNotFoundException byUserId(Long userId) {
        return new InvestmentNotFoundException("No active investments found for user id: " + userId);
    }
}
