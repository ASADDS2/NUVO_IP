package com.nuvo.loan.infrastructure.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LoanRequest {
    private Integer userId;
    private BigDecimal amount;
    private Integer termMonths;
}
