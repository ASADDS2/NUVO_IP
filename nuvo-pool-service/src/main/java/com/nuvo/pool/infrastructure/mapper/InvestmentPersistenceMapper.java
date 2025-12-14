package com.nuvo.pool.infrastructure.mapper;

import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.infrastructure.entities.InvestmentEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface InvestmentPersistenceMapper {
    InvestmentEntity toEntity(Investment domain);

    Investment toDomain(InvestmentEntity entity);

    @org.mapstruct.Mapping(target = "investments", ignore = true)
    com.nuvo.pool.domain.model.Pool poolEntityToPool(com.nuvo.pool.infrastructure.entities.PoolEntity entity);
}
