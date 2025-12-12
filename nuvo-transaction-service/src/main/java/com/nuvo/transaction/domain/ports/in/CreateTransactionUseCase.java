package com.nuvo.transaction.domain.ports.in;

import com.nuvo.transaction.application.services.CreateTransactionRequest;

public interface CreateTransactionUseCase {
    void createTransaction(CreateTransactionRequest request);
}
