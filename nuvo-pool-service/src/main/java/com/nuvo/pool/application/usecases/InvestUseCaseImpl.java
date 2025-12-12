package com.nuvo.pool.application.usecases;

import com.nuvo.pool.infrastructure.dto.InvestRequest;
import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.model.InvestmentStatus;
import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.domain.ports.in.InvestUseCase;
import com.nuvo.pool.domain.ports.out.AccountPort;
import com.nuvo.pool.domain.ports.out.InvestmentRepositoryPort;
import com.nuvo.pool.domain.ports.out.PoolRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class InvestUseCaseImpl implements InvestUseCase {

    private final InvestmentRepositoryPort investmentRepository;
    private final PoolRepositoryPort poolRepository;
    private final AccountPort accountPort;
    private final com.nuvo.pool.infrastructure.client.TransactionClient transactionClient;

    @Transactional
    @Override
    public Investment invest(InvestRequest request) {
        if (request.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("El monto debe ser positivo");
        }

        Pool pool = null;
        if (request.getPoolId() != null) {
            pool = poolRepository.findById(request.getPoolId())
                    .orElseThrow(() -> new RuntimeException("Pool no encontrado"));

            if (!Boolean.TRUE.equals(pool.getActive())) {
                throw new RuntimeException("El pool está inactivo");
            }

            if (pool.isFull()) {
                throw new RuntimeException("Pool lleno. Máximo de participantes: " + pool.getMaxParticipants());
            }

            boolean alreadyInvested = investmentRepository.existsByUserIdAndPoolIdAndStatus(
                    request.getUserId(),
                    pool.getId(),
                    InvestmentStatus.ACTIVE);

            if (alreadyInvested) {
                throw new RuntimeException("Ya tienes una inversión activa en este pool");
            }
        }

        accountPort.updateBalance(request.getUserId(), request.getAmount().negate());

        // Record transaction
        try {
            transactionClient.createTransaction(
                    com.nuvo.pool.infrastructure.client.TransactionClient.CreateTransactionRequest.builder()
                            .userId(request.getUserId())
                            .amount(request.getAmount()) // Send positive amount, let viewer determine sign based on
                                                         // type/source
                            .type("INVESTMENT")
                            .description("Inversión en Piscina " + (pool != null ? pool.getName() : "General"))
                            .build());
        } catch (Exception e) {
            // Log error but don't fail investment? Or fail?
            // Ideally distributed transaction, but for now log.
            System.err.println("Error recording transaction: " + e.getMessage());
        }

        Investment investment = new Investment();
        investment.setUserId(request.getUserId());
        investment.setInvestedAmount(request.getAmount());
        investment.setStatus(InvestmentStatus.ACTIVE);
        investment.setPool(pool);
        investment.setInvestedAt(LocalDateTime.now());

        return investmentRepository.save(investment);
    }
}
