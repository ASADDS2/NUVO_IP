package com.nuvo.account.domain.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Domain model representing an account in the system.
 * Pure POJO without framework dependencies following hexagonal architecture
 * principles.
 */
public class Account {
    private Long id;
    private Integer userId;
    private String accountNumber;
    private BigDecimal balance;
    private LocalDateTime createdAt;

    public Account() {
    }

    public Account(Long id, Integer userId, String accountNumber, BigDecimal balance, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.accountNumber = accountNumber;
        this.balance = balance;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
