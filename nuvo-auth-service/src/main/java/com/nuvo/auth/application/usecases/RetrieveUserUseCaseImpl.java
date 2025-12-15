package com.nuvo.auth.application.usecases;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.in.RetrieveUserUseCase;
import com.nuvo.auth.domain.ports.out.UserRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.nuvo.auth.infrastructure.exception.UserNotFoundException;

@Service
@RequiredArgsConstructor
public class RetrieveUserUseCaseImpl implements RetrieveUserUseCase {

    private final UserRepositoryPort repository;

    @Override
    public User getUserById(Integer id) {
        return repository.findById(id).orElseThrow();
    }

    @Override
    public User getUserByPhone(String phone) {
        return repository.findByPhone(phone)
                .orElseThrow(() -> new UserNotFoundException("User not found with phone: " + phone));
    }
}
