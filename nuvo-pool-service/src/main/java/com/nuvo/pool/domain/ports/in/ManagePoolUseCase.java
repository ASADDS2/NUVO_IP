package com.nuvo.pool.domain.ports.in;

import com.nuvo.pool.infrastructure.dto.CreatePoolRequest;
import com.nuvo.pool.infrastructure.dto.PoolWithStatsDTO;
import com.nuvo.pool.infrastructure.dto.UpdatePoolRequest;
import com.nuvo.pool.domain.model.Pool;
import java.util.List;

public interface ManagePoolUseCase {
    Pool createPool(CreatePoolRequest request);

    List<PoolWithStatsDTO> getAllPools();

    List<Pool> getActivePools();

    Pool getPoolById(Long id);

    Pool updatePool(Long id, UpdatePoolRequest request);

    void deletePool(Long id);

    PoolWithStatsDTO getPoolStats(Long poolId);
}
