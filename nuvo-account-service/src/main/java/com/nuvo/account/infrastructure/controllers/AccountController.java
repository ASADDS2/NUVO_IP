package com.nuvo.account.infrastructure.controllers;

import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.in.CreateAccountUseCase;
import com.nuvo.account.domain.ports.in.DepositUseCase;
import com.nuvo.account.domain.ports.in.FindAccountByUserIdUseCase;
import com.nuvo.account.domain.ports.in.FindAllAccountsUseCase;
import com.nuvo.account.domain.ports.in.DeleteAccountUseCase;
import com.nuvo.account.infrastructure.dto.CreateAccountRequest;
import com.nuvo.account.infrastructure.mapper.AccountWebMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/v1/accounts")
@RequiredArgsConstructor
public class AccountController {

    private final CreateAccountUseCase createAccountUseCase;
    private final FindAccountByUserIdUseCase findAccountByUserIdUseCase;
    private final FindAllAccountsUseCase findAllAccountsUseCase;
    private final DepositUseCase depositUseCase;
    private final DeleteAccountUseCase deleteAccountUseCase;
    private final AccountWebMapper mapper;

    @PostMapping
    public ResponseEntity<Account> createAccount(@RequestBody CreateAccountRequest request) {
        Account account = mapper.toDomain(request);
        return ResponseEntity.ok(createAccountUseCase.createAccount(account));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<Account> getAccount(@PathVariable Integer userId) {
        return ResponseEntity.ok(findAccountByUserIdUseCase.findByUserId(userId));
    }

    @GetMapping
    public ResponseEntity<List<Account>> getAll() {
        return ResponseEntity.ok(findAllAccountsUseCase.findAll());
    }

    @PostMapping("/{userId}/deposit")
    public ResponseEntity<Account> deposit(@PathVariable Integer userId, @RequestParam BigDecimal amount) {
        return ResponseEntity.ok(depositUseCase.deposit(userId, amount));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAccount(@PathVariable Long id) {
        deleteAccountUseCase.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
