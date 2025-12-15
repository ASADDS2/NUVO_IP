package com.nuvo.pool.infrastructure.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import java.math.BigDecimal;
import lombok.Data;
import lombok.Builder;

@FeignClient(name = "transaction-service", url = "${transaction.service.url:http://localhost:8083}")
public interface TransactionClient {

    @PostMapping("/api/v1/transactions/create")
    void createTransaction(@RequestBody CreateTransactionRequest request);

    @Data
    @Builder
    class CreateTransactionRequest {
        private Integer userId;
        private BigDecimal amount;
        private String type;
        private String description;
    }
}
