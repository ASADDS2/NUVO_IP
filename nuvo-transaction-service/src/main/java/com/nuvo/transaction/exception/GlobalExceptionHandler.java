package com.nuvo.transaction.exception;

import com.nuvo.transaction.dto.ErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Global exception handler for transaction-service
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

        @ExceptionHandler(TransactionFailedException.class)
        public ResponseEntity<ErrorResponse> handleTransactionFailedException(
                        TransactionFailedException ex, HttpServletRequest request) {

                log.error("Transaction failed: {}", ex.getMessage());

                ErrorResponse error = ErrorResponse.of(
                                HttpStatus.BAD_REQUEST.value(),
                                "Bad Request",
                                ex.getMessage(),
                                request.getRequestURI());

                return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
        }

        @ExceptionHandler(InvalidAmountException.class)
        public ResponseEntity<ErrorResponse> handleInvalidAmountException(
                        InvalidAmountException ex, HttpServletRequest request) {

                log.error("Invalid amount: {}", ex.getMessage());

                ErrorResponse error = ErrorResponse.of(
                                HttpStatus.BAD_REQUEST.value(),
                                "Bad Request",
                                ex.getMessage(),
                                request.getRequestURI());

                return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
        }

        @ExceptionHandler(MethodArgumentNotValidException.class)
        public ResponseEntity<ErrorResponse> handleValidationException(
                        MethodArgumentNotValidException ex, HttpServletRequest request) {

                List<String> errors = ex.getBindingResult()
                                .getFieldErrors()
                                .stream()
                                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                                .collect(Collectors.toList());

                log.error("Validation failed: {}", errors);

                ErrorResponse error = ErrorResponse.of(
                                HttpStatus.BAD_REQUEST.value(),
                                "Bad Request",
                                "Validation failed",
                                request.getRequestURI(),
                                errors);

                return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
        }

        @ExceptionHandler(IllegalArgumentException.class)
        public ResponseEntity<ErrorResponse> handleIllegalArgumentException(
                        IllegalArgumentException ex, HttpServletRequest request) {

                log.error("Illegal argument: {}", ex.getMessage());

                ErrorResponse error = ErrorResponse.of(
                                HttpStatus.BAD_REQUEST.value(),
                                "Bad Request",
                                ex.getMessage(),
                                request.getRequestURI());

                return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
        }

        @ExceptionHandler(Exception.class)
        public ResponseEntity<ErrorResponse> handleGenericException(
                        Exception ex, HttpServletRequest request) {

                log.error("Unexpected error occurred", ex);

                ErrorResponse error = ErrorResponse.of(
                                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                                "Internal Server Error",
                                "An unexpected error occurred: " + ex.getMessage(),
                                request.getRequestURI());

                return new ResponseEntity<>(error, HttpStatus.INTERNAL_SERVER_ERROR);
        }

        @ExceptionHandler(feign.FeignException.class)
        public ResponseEntity<ErrorResponse> handleFeignException(
                        feign.FeignException ex, HttpServletRequest request) {

                log.error("Feign error: {}", ex.getMessage());

                String message = ex.contentUTF8();
                if (message == null || message.isEmpty()) {
                        message = ex.getMessage();
                }

                ErrorResponse error = ErrorResponse.of(
                                ex.status(),
                                "External Service Error",
                                message,
                                request.getRequestURI());

                return new ResponseEntity<>(error, HttpStatus.valueOf(ex.status()));
        }
}
