package com.nuvo.auth.application.usecases;

import com.nuvo.auth.domain.ports.in.DeleteUserUseCase;
import com.nuvo.auth.domain.ports.out.UserRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class DeleteUserUseCaseImpl implements DeleteUserUseCase {

    private final UserRepositoryPort userRepositoryPort;

    @Override
    public void deleteById(Integer id) {
        userRepositoryPort.deleteById(id);
    }
}
