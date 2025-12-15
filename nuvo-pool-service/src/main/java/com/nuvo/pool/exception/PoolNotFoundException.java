package com.nuvo.pool.exception;

/**
 * Exception thrown when a pool is not found
 */
public class PoolNotFoundException extends RuntimeException {

    public PoolNotFoundException(String message) {
        super(message);
    }

    public static PoolNotFoundException byId(Long id) {
        return new PoolNotFoundException("Pool not found with id: " + id);
    }
}
