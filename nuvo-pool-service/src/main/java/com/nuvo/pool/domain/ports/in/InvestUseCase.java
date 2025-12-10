package com.nuvo.pool.domain.ports.in;

import com.nuvo.pool.infrastructure.dto.InvestRequest;
import com.nuvo.pool.domain.model.Investment;

public interface InvestUseCase {
    Investment invest(InvestRequest request);
}
