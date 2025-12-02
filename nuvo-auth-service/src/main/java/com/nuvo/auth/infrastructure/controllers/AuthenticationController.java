package com.nuvo.auth.infrastructure.controllers;

import com.nuvo.auth.domain.model.Role;
import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.in.LoginUseCase;
import com.nuvo.auth.domain.ports.in.RegisterUseCase;
import com.nuvo.auth.domain.ports.in.RetrieveUserUseCase;
import com.nuvo.auth.domain.ports.out.JwtPort;
import com.nuvo.auth.domain.ports.out.PasswordEncoderPort;
import com.nuvo.auth.infrastructure.dto.AuthenticationRequest;
import com.nuvo.auth.infrastructure.dto.AuthenticationResponse;
import com.nuvo.auth.infrastructure.dto.RegisterRequest;
import com.nuvo.auth.infrastructure.mapper.AuthWebMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthenticationController {

    private final RegisterUseCase registerUseCase;
    private final LoginUseCase loginUseCase;
    private final RetrieveUserUseCase retrieveUserUseCase;
    private final AuthWebMapper mapper;
    private final JwtPort jwtPort;
    private final PasswordEncoderPort passwordEncoder;

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody RegisterRequest request) {
        // Convert DTO to Domain via mapper
        User user = mapper.toDomain(request);
        // Set password and role (not handled by mapper)
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(Role.USER);

        // Call use case
        User savedUser = registerUseCase.register(user);

        // Generate JWT and build response
        String token = jwtPort.generateToken(savedUser);
        return ResponseEntity.ok(mapper.toAuthResponse(savedUser, token));
    }

    @PostMapping("/authenticate")
    public ResponseEntity<AuthenticationResponse> authenticate(@RequestBody AuthenticationRequest request) {
        // Call use case with primitives
        User user = loginUseCase.authenticate(request.getEmail(), request.getPassword());

        // Generate JWT and build response
        String token = jwtPort.generateToken(user);
        return ResponseEntity.ok(mapper.toAuthResponse(user, token));
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Integer id) {
        return ResponseEntity.ok(retrieveUserUseCase.getUserById(id));
    }
}
