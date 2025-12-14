package com.nuvo.transaction.exception;

import java.math.BigDecimal;

/**
 * Exception thrown when an invalid amount is provided for a transaction
 */
public class InvalidAmountException extends RuntimeException {

    public InvalidAmountException(String message) {
        super(message);
    }

    public static InvalidAmountException negative() {
        return new InvalidAmountException("Transaction amount must be positive");
    }

    public static InvalidAmountException zero() {
        return new InvalidAmountException("Transaction amount must be greater than zero");
    }
}
