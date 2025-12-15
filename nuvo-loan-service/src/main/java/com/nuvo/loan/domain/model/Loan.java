package com.nuvo.loan.domain.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Loan {
    private Long id;
    private Integer userId;
    private BigDecimal amount;
    private Integer termMonths;
    private BigDecimal interestRate;
    private LoanStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;
    private BigDecimal paidAmount;

    public Loan() {
    }

    public Loan(Long id, Integer userId, BigDecimal amount, Integer termMonths, BigDecimal interestRate,
            LoanStatus status, LocalDateTime createdAt, LocalDateTime approvedAt, BigDecimal paidAmount) {
        this.id = id;
        this.userId = userId;
        this.amount = amount;
        this.termMonths = termMonths;
        this.interestRate = interestRate;
        this.status = status;
        this.createdAt = createdAt;
        this.approvedAt = approvedAt;
        this.paidAmount = paidAmount;
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

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Integer getTermMonths() {
        return termMonths;
    }

    public void setTermMonths(Integer termMonths) {
        this.termMonths = termMonths;
    }

    public BigDecimal getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(BigDecimal interestRate) {
        this.interestRate = interestRate;
    }

    public LoanStatus getStatus() {
        return status;
    }

    public void setStatus(LoanStatus status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(LocalDateTime approvedAt) {
        this.approvedAt = approvedAt;
    }

    public BigDecimal getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount;
    }
}
