package com.nuvo.pool.domain.ports.in;

import com.nuvo.pool.infrastructure.dto.PoolStats;
import com.nuvo.pool.domain.model.Investment;
import java.util.List;

public interface GetInvestmentsUseCase {
    List<Investment> getMyInvestments(Integer userId);

    PoolStats getStats(Integer userId);

    List<Investment> getAllInvestments();
}
