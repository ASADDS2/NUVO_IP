package com.nuvo.account.domain.ports.in;

import com.nuvo.account.domain.model.Account;
import java.util.List;

public interface FindAllAccountsUseCase {
    List<Account> findAll();
}
