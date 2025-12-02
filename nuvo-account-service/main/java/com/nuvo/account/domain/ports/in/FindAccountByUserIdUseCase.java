package com.nuvo.account.domain.ports.in;

import com.nuvo.account.domain.model.Account;

public interface FindAccountByUserIdUseCase {
    Account findByUserId(Integer userId);
}
