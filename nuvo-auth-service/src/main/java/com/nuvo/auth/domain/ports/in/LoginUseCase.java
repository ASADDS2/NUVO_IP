package com.nuvo.auth.domain.ports.in;

import com.nuvo.auth.domain.model.User;

public interface LoginUseCase {
    User authenticate(String email, String password);
}
