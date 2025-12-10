package com.nuvo.pool.infrastructure.adapters;

import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.model.InvestmentStatus;
import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.domain.ports.out.InvestmentRepositoryPort;
import com.nuvo.pool.infrastructure.entities.InvestmentEntity;
import com.nuvo.pool.infrastructure.entities.PoolEntity;
import com.nuvo.pool.infrastructure.mapper.InvestmentPersistenceMapper;
import com.nuvo.pool.infrastructure.repositories.JpaInvestmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class InvestmentRepositoryAdapter implements InvestmentRepositoryPort {

    private final JpaInvestmentRepository jpaInvestmentRepository;
    private final InvestmentPersistenceMapper investmentMapper;

    @Override
    public Investment save(Investment investment) {
        InvestmentEntity entity = investmentMapper.toEntity(investment);
        InvestmentEntity savedEntity = jpaInvestmentRepository.save(entity);
        return investmentMapper.toDomain(savedEntity);
    }

    @Override
    public List<Investment> findByUserIdAndStatus(Integer userId, InvestmentStatus status) {
        return jpaInvestmentRepository.findByUserIdAndStatus(userId, status).stream()
                .map(investmentMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByUserIdAndPoolIdAndStatus(Integer userId, Long poolId, InvestmentStatus status) {
        return jpaInvestmentRepository.existsByUserIdAndPoolIdAndStatus(userId, poolId, status);
    }

    @Override
    public List<Investment> findByPoolIdAndStatus(Long poolId, InvestmentStatus status) {
        return jpaInvestmentRepository.findByPoolIdAndStatus(poolId, status).stream()
                .map(investmentMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Investment> findAll() {
        return jpaInvestmentRepository.findAll().stream()
                .map(investmentMapper::toDomain)
                .collect(Collectors.toList());
    }
}
