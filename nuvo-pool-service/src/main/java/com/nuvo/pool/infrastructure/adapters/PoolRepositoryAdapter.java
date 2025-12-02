package com.nuvo.pool.infrastructure.adapters;

import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.domain.ports.out.PoolRepositoryPort;
import com.nuvo.pool.infrastructure.entities.InvestmentEntity;
import com.nuvo.pool.infrastructure.entities.PoolEntity;
import com.nuvo.pool.infrastructure.mapper.PoolPersistenceMapper;
import com.nuvo.pool.infrastructure.repositories.JpaPoolRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class PoolRepositoryAdapter implements PoolRepositoryPort {

    private final JpaPoolRepository jpaPoolRepository;
    private final PoolPersistenceMapper poolMapper;

    @Override
    public Pool save(Pool pool) {
        PoolEntity entity = poolMapper.toEntity(pool);
        PoolEntity savedEntity = jpaPoolRepository.save(entity);
        return poolMapper.toDomain(savedEntity);
    }

    @Override
    public Optional<Pool> findById(Long id) {
        return jpaPoolRepository.findById(id).map(poolMapper::toDomain);
    }

    @Override
    public List<Pool> findByActiveTrue() {
        return jpaPoolRepository.findByActiveTrue().stream()
                .map(poolMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Pool> findByName(String name) {
        return jpaPoolRepository.findByName(name).map(poolMapper::toDomain);
    }

    @Override
    public boolean existsByName(String name) {
        return jpaPoolRepository.existsByName(name);
    }

    @Override
    public List<Pool> findAllWithActiveInvestments() {
        return jpaPoolRepository.findAllWithActiveInvestments().stream()
                .map(poolMapper::toDomain)
                .collect(Collectors.toList());
    }
}
