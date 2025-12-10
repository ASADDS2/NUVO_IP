package com.nuvo.auth.application.usecases;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.in.RegisterUseCase;
import com.nuvo.auth.domain.ports.out.UserRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RegisterUseCaseImpl implements RegisterUseCase {

    private final UserRepositoryPort repository;

    @Override
    public User register(User user) {
        return repository.save(user);
    }
}
