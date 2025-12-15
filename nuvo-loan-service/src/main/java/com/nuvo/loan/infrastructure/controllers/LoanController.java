package com.nuvo.loan.infrastructure.controllers;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.ports.in.ApproveLoanUseCase;
import com.nuvo.loan.domain.ports.in.CreateLoanUseCase;
import com.nuvo.loan.domain.ports.in.GetLoansUseCase;
import com.nuvo.loan.infrastructure.dto.LoanRequest;
import com.nuvo.loan.infrastructure.dto.LoanResponse;
import com.nuvo.loan.infrastructure.mapper.LoanWebMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/loans")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class LoanController {

    private final CreateLoanUseCase createLoanUseCase;
    private final ApproveLoanUseCase approveLoanUseCase;
    private final GetLoansUseCase getLoansUseCase;
    private final LoanWebMapper loanMapper;

    private final com.nuvo.loan.domain.ports.in.PayLoanUseCase payLoanUseCase;

    @PostMapping
    public ResponseEntity<LoanResponse> createLoan(@RequestBody LoanRequest request) {
        Loan loan = loanMapper.toDomain(request);
        Loan createdLoan = createLoanUseCase.createLoan(loan);
        return ResponseEntity.ok(loanMapper.toResponse(createdLoan));
    }

    @PutMapping("/{loanId}/approve")
    public ResponseEntity<LoanResponse> approveLoan(@PathVariable Long loanId) {
        Loan approvedLoan = approveLoanUseCase.approveLoan(loanId);
        return ResponseEntity.ok(loanMapper.toResponse(approvedLoan));
    }

    @PostMapping("/{loanId}/pay")
    public ResponseEntity<LoanResponse> payLoan(@PathVariable Long loanId, @RequestParam java.math.BigDecimal amount) {
        Loan paidLoan = payLoanUseCase.payLoan(loanId, amount);
        return ResponseEntity.ok(loanMapper.toResponse(paidLoan));
    }

    @GetMapping
    public ResponseEntity<List<LoanResponse>> getAllLoans() {
        List<Loan> loans = getLoansUseCase.getAllLoans();
        List<LoanResponse> response = loans.stream()
                .map(loanMapper::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/my-loans/{userId}")
    public ResponseEntity<List<LoanResponse>> getMyLoans(@PathVariable Integer userId) {
        List<Loan> loans = getLoansUseCase.getLoansByUserId(userId);
        List<LoanResponse> response = loans.stream()
                .map(loanMapper::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{loanId}")
    public ResponseEntity<LoanResponse> getLoanById(@PathVariable Long loanId) {
        Loan loan = getLoansUseCase.getLoanById(loanId);
        return ResponseEntity.ok(loanMapper.toResponse(loan));
    }
}
