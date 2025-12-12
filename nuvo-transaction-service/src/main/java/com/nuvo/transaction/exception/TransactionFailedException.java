package com.nuvo.transaction.exception;

/**
 * Exception thrown when a transaction fails
 */
public class TransactionFailedException extends RuntimeException {

    public TransactionFailedException(String message) {
        super(message);
    }

    public TransactionFailedException(String message, Throwable cause) {
        super(message, cause);
    }
}
