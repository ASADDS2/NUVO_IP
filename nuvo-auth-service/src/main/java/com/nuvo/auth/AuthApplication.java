package com.nuvo.auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@org.springframework.boot.autoconfigure.domain.EntityScan(basePackages = "com.nuvo.auth.infrastructure.entities")
@org.springframework.data.jpa.repository.config.EnableJpaRepositories(basePackages = "com.nuvo.auth.infrastructure.repositories")
public class AuthApplication {
    public static void main(String[] args) {
        SpringApplication.run(AuthApplication.class, args);
    }
}