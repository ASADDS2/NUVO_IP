package com.nuvo.pool.infrastructure.mapper;

import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.infrastructure.dto.CreatePoolRequest;
import com.nuvo.pool.infrastructure.dto.UpdatePoolRequest;
import com.nuvo.pool.infrastructure.dto.PoolWithStatsDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface PoolWebMapper {
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "active", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "investments", ignore = true)
    Pool toDomain(CreatePoolRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "active", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "investments", ignore = true)
    Pool toDomain(UpdatePoolRequest request);

    PoolWithStatsDTO toDto(Pool domain);
}
