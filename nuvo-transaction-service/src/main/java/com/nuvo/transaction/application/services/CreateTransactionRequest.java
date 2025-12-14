package com.nuvo.transaction.application.services;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class CreateTransactionRequest {
    private Integer userId;
    private BigDecimal amount;
    private String type;
    private String description;
}
