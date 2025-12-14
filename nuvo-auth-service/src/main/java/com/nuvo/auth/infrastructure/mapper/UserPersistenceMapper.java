package com.nuvo.auth.infrastructure.mapper;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.infrastructure.entities.UserEntity;
import org.mapstruct.Mapper;

/**
 * Persistence mapper to convert between domain User and persistence UserEntity.
 * Part of the infrastructure layer following hexagonal architecture.
 */
@Mapper(componentModel = "spring")
public interface UserPersistenceMapper {

    /**
     * Convert domain User to persistence UserEntity
     */
    UserEntity toEntity(User domain);

    /**
     * Convert persistence UserEntity to domain User
     */
    User toDomain(UserEntity entity);
}
