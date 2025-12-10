package com.nuvo.auth.domain.ports.in;

import com.nuvo.auth.domain.model.User;

public interface RegisterUseCase {
    User register(User user);
}
