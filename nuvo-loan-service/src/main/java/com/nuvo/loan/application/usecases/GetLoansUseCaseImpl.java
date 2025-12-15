package com.nuvo.loan.application.usecases;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.ports.in.GetLoansUseCase;
import com.nuvo.loan.domain.ports.out.LoanRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GetLoansUseCaseImpl implements GetLoansUseCase {

    private final LoanRepositoryPort loanRepositoryPort;

    @Override
    public List<Loan> getAllLoans() {
        return loanRepositoryPort.findAll();
    }

    @Override
    public List<Loan> getLoansByUserId(Integer userId) {
        return loanRepositoryPort.findByUserId(userId);
    }

    @Override
    public Loan getLoanById(Long loanId) {
        return loanRepositoryPort.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found"));
    }
}
