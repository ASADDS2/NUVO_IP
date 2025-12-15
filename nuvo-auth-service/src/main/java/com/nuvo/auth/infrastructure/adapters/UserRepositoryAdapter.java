package com.nuvo.auth.infrastructure.adapters;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.out.UserRepositoryPort;
import com.nuvo.auth.infrastructure.entities.UserEntity;
import com.nuvo.auth.infrastructure.mapper.UserPersistenceMapper;
import com.nuvo.auth.infrastructure.repositories.JpaUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@RequiredArgsConstructor
public class UserRepositoryAdapter implements UserRepositoryPort {

    private final JpaUserRepository jpaUserRepository;
    private final UserPersistenceMapper mapper;

    @Override
    public User save(User user) {
        UserEntity entity = mapper.toEntity(user);
        UserEntity savedEntity = jpaUserRepository.save(entity);
        return mapper.toDomain(savedEntity);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return jpaUserRepository.findByEmail(email).map(mapper::toDomain);
    }

    @Override
    public Optional<User> findByEmailOrPhone(String email, String phone) {
        return jpaUserRepository.findByEmailOrPhone(email, phone).map(mapper::toDomain);
    }

    @Override
    public Optional<User> findByPhone(String phone) {
        return jpaUserRepository.findFirstByPhone(phone).map(mapper::toDomain);
    }

    @Override
    public Optional<User> findById(Integer id) {
        return jpaUserRepository.findById(id).map(mapper::toDomain);
    }

    @Override
    public void deleteById(Integer id) {
        jpaUserRepository.deleteById(id);
    }
}
