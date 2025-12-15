package com.nuvo.pool.infrastructure.mapper;

import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.infrastructure.entities.PoolEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PoolPersistenceMapper {
    PoolEntity toEntity(Pool domain);

    Pool toDomain(PoolEntity entity);

    @org.mapstruct.Mapping(target = "pool", ignore = true)
    com.nuvo.pool.domain.model.Investment investmentEntityToInvestment(
            com.nuvo.pool.infrastructure.entities.InvestmentEntity entity);
}
