package com.nuvo.auth.application.usecases;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.in.LoginUseCase;
import com.nuvo.auth.domain.ports.out.AuthenticationPort;
import com.nuvo.auth.domain.ports.out.UserRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LoginUseCaseImpl implements LoginUseCase {

    private final AuthenticationPort authenticationPort;
    private final UserRepositoryPort repository;

    @Override
    public User authenticate(String email, String password) {
        authenticationPort.authenticate(email, password);
        return repository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
}
