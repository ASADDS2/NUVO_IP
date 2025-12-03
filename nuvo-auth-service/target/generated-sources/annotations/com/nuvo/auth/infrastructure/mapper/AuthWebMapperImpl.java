package com.nuvo.auth.infrastructure.mapper;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.infrastructure.dto.RegisterRequest;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2025-12-02T18:38:14-0500",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 17.0.17 (Ubuntu)"
)
@Component
public class AuthWebMapperImpl implements AuthWebMapper {

    @Override
    public User toDomain(RegisterRequest request) {
        if ( request == null ) {
            return null;
        }

        User user = new User();

        user.setFirstname( request.getFirstname() );
        user.setLastname( request.getLastname() );
        user.setEmail( request.getEmail() );

        return user;
    }
}
