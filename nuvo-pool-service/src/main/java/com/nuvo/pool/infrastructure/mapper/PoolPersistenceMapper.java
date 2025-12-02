package com.nuvo.pool.infrastructure.mapper;

import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.infrastructure.entities.PoolEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PoolPersistenceMapper {
    PoolEntity toEntity(Pool domain);

    Pool toDomain(PoolEntity entity);
}
