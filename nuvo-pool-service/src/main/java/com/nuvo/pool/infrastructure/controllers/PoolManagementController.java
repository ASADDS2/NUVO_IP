package com.nuvo.pool.infrastructure.controllers;

import com.nuvo.pool.infrastructure.dto.CreatePoolRequest;
import com.nuvo.pool.infrastructure.dto.PoolWithStatsDTO;
import com.nuvo.pool.infrastructure.dto.UpdatePoolRequest;
import com.nuvo.pool.domain.model.Pool;
import com.nuvo.pool.domain.ports.in.ManagePoolUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/pools")
@RequiredArgsConstructor
public class PoolManagementController {

    private final ManagePoolUseCase managePoolUseCase;

    @PostMapping
    public ResponseEntity<Pool> createPool(@RequestBody CreatePoolRequest request) {
        return ResponseEntity.ok(managePoolUseCase.createPool(request));
    }

    @GetMapping
    public ResponseEntity<List<PoolWithStatsDTO>> getAllPools() {
        return ResponseEntity.ok(managePoolUseCase.getAllPools());
    }

    @GetMapping("/active")
    public ResponseEntity<List<Pool>> getActivePools() {
        return ResponseEntity.ok(managePoolUseCase.getActivePools());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Pool> getPoolById(@PathVariable Long id) {
        return ResponseEntity.ok(managePoolUseCase.getPoolById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Pool> updatePool(@PathVariable Long id,
            @RequestBody UpdatePoolRequest request) {
        return ResponseEntity.ok(managePoolUseCase.updatePool(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePool(@PathVariable Long id) {
        managePoolUseCase.deletePool(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{id}/stats")
    public ResponseEntity<PoolWithStatsDTO> getPoolStats(@PathVariable Long id) {
        return ResponseEntity.ok(managePoolUseCase.getPoolStats(id));
    }
}
