package com.nuvo.pool.domain.model;

import java.time.LocalDateTime;
import java.util.List;

public class Pool {
    private Long id;
    private String name;
    private String description;
    private Double interestRatePerDay;
    private Integer maxParticipants;
    private Boolean active;
    private LocalDateTime createdAt;
    private List<Investment> investments;

    public Pool() {
    }

    public Pool(Long id, String name, String description, Double interestRatePerDay, Integer maxParticipants,
            Boolean active, LocalDateTime createdAt, List<Investment> investments) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.interestRatePerDay = interestRatePerDay;
        this.maxParticipants = maxParticipants;
        this.active = active;
        this.createdAt = createdAt;
        this.investments = investments;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getInterestRatePerDay() {
        return interestRatePerDay;
    }

    public void setInterestRatePerDay(Double interestRatePerDay) {
        this.interestRatePerDay = interestRatePerDay;
    }

    public Integer getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(Integer maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public List<Investment> getInvestments() {
        return investments;
    }

    public void setInvestments(List<Investment> investments) {
        this.investments = investments;
    }

    public int getCurrentParticipantsCount() {
        if (investments == null) {
            return 0;
        }
        return (int) investments.stream()
                .filter(inv -> inv.getStatus() == InvestmentStatus.ACTIVE)
                .map(Investment::getUserId)
                .distinct()
                .count();
    }

    public boolean isFull() {
        return getCurrentParticipantsCount() >= maxParticipants;
    }

    public boolean canAcceptNewInvestor() {
        return Boolean.TRUE.equals(active) && !isFull();
    }
}
