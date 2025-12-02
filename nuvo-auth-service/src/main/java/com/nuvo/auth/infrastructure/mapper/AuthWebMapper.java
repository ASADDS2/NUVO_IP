package com.nuvo.auth.infrastructure.mapper;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.infrastructure.dto.AuthenticationResponse;
import com.nuvo.auth.infrastructure.dto.RegisterRequest;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

/**
 * Web mapper to convert between DTOs and domain models.
 * Part of the infrastructure layer following hexagonal architecture.
 */
@Mapper(componentModel = "spring")
public interface AuthWebMapper {

    /**
     * Convert RegisterRequest DTO to domain User
     * Password encoding and role assignment should be done in use case
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true) // Will be set after encoding
    @Mapping(target = "role", ignore = true) // Will be set in use case
    User toDomain(RegisterRequest request);

    /**
     * Build AuthenticationResponse from user and token
     */
    default AuthenticationResponse toAuthResponse(User user, String token) {
        return AuthenticationResponse.builder()
                .token(token)
                .id(user.getId())
                .role(user.getRole().name())
                .build();
    }
}
