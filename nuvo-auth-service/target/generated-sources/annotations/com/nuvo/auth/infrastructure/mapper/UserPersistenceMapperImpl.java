package com.nuvo.auth.infrastructure.mapper;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.infrastructure.entities.UserEntity;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2025-12-02T18:38:14-0500",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 17.0.17 (Ubuntu)"
)
@Component
public class UserPersistenceMapperImpl implements UserPersistenceMapper {

    @Override
    public UserEntity toEntity(User domain) {
        if ( domain == null ) {
            return null;
        }

        UserEntity.UserEntityBuilder userEntity = UserEntity.builder();

        userEntity.id( domain.getId() );
        userEntity.firstname( domain.getFirstname() );
        userEntity.lastname( domain.getLastname() );
        userEntity.email( domain.getEmail() );
        userEntity.password( domain.getPassword() );
        userEntity.role( domain.getRole() );

        return userEntity.build();
    }

    @Override
    public User toDomain(UserEntity entity) {
        if ( entity == null ) {
            return null;
        }

        User user = new User();

        user.setId( entity.getId() );
        user.setFirstname( entity.getFirstname() );
        user.setLastname( entity.getLastname() );
        user.setEmail( entity.getEmail() );
        user.setPassword( entity.getPassword() );
        user.setRole( entity.getRole() );

        return user;
    }
}
