package com.nuvo.pool.domain.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Investment {
    private Long id;
    private Integer userId;
    private BigDecimal investedAmount;
    private LocalDateTime investedAt;
    private InvestmentStatus status;
    private Pool pool;

    public Investment() {
    }

    public Investment(Long id, Integer userId, BigDecimal investedAmount, LocalDateTime investedAt,
            InvestmentStatus status, Pool pool) {
        this.id = id;
        this.userId = userId;
        this.investedAmount = investedAmount;
        this.investedAt = investedAt;
        this.status = status;
        this.pool = pool;
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

    public BigDecimal getInvestedAmount() {
        return investedAmount;
    }

    public void setInvestedAmount(BigDecimal investedAmount) {
        this.investedAmount = investedAmount;
    }

    public LocalDateTime getInvestedAt() {
        return investedAt;
    }

    public void setInvestedAt(LocalDateTime investedAt) {
        this.investedAt = investedAt;
    }

    public InvestmentStatus getStatus() {
        return status;
    }

    public void setStatus(InvestmentStatus status) {
        this.status = status;
    }

    public Pool getPool() {
        return pool;
    }

    public void setPool(Pool pool) {
        this.pool = pool;
    }
}
