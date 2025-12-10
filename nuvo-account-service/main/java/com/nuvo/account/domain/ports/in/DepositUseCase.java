package com.nuvo.account.domain.ports.in;

import com.nuvo.account.domain.model.Account;
import java.math.BigDecimal;

public interface DepositUseCase {
    Account deposit(Integer userId, BigDecimal amount);
}
