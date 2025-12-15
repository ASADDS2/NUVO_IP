package com.nuvo.auth.infrastructure.exception;

/**
 * Exception thrown when authentication credentials are invalid
 */
public class InvalidCredentialsException extends RuntimeException {

    public InvalidCredentialsException(String message) {
        super(message);
    }

    public InvalidCredentialsException(String message, Throwable cause) {
        super(message, cause);
    }

    public static InvalidCredentialsException withEmail(String email) {
        return new InvalidCredentialsException("Invalid credentials for email: " + email);
    }
}
