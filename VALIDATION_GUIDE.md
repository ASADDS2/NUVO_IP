# NUVO IP - Data Validation Guide

## 📋 Guía de Validaciones de Datos

Guía completa para agregar y usar validaciones en NUVO IP.

---

## 🎯 Bean Validation (Jakarta)

Todos los servicios ya incluyen Bean Validation. Solo necesitas agregar anotaciones.

### Dependencia (Ya incluida)
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

---

## 📝 Anotaciones Comunes

### Strings
```java
@NotNull(message = "Field cannot be null")
@NotBlank(message = "Field cannot be empty")
@NotEmpty(message = "Field cannot be empty")
@Size(min = 2, max = 50, message = "Must be between 2 and 50 characters")
@Email(message = "Invalid email format")
@Pattern(regexp = "^[0-9]{10}$", message = "Phone must be 10 digits")
```

### Numbers
```java
@NotNull
@Positive(message = "Must be positive")
@PositiveOrZero
@Min(value = 0, message = "Must be at least 0")
@Max(value = 100, message = "Must be at most 100")
@DecimalMin(value = "0.0", message = "Must be positive")
@Digits(integer = 10, fraction = 2, message = "Invalid format")
```

### Dates
```java
@Past(message = "Date must be in the past")
@PastOrPresent
@Future(message = "Date must be in the future")
@FutureOrPresent
```

---

## 💡 Ejemplos por Servicio

### Auth Service - RegisterRequest DTO

```java
package com.nuvo.auth.infrastructure.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class RegisterRequest {
    
    @NotBlank(message = "First name is required")
    @Size(min = 2, max = 50, message = "First name must be between 2-50 characters")
    private String firstname;
    
    @NotBlank(message = "Last name is required")
    @Size(min = 2, max = 50, message = "Last name must be between 2-50 characters")
    private String lastname;
    
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;
    
    @NotBlank(message = "Phone is required")
    @Pattern(regexp = "^[0-9]{10}$", message = "Phone must be 10 digits")
    private String phone;
    
    @NotBlank(message = "Password is required")
    @Size(min = 6, max = 100, message = "Password must be at least 6 characters")
    private String password;
}
```

### Account Service - CreateAccountRequest

```java
@Data
public class CreateAccountRequest {
    
    @NotNull(message = "User ID is required")
    @Positive(message = "User ID must be positive")
    private Long userId;
}
```

### Transaction Service - TransferRequest

```java
@Data
public class TransferRequest {
    
    @NotNull(message = "Source account is required")
    @Positive
    private Long sourceAccountId;
    
    @NotNull(message = "Target account is required")
    @Positive
    private Long targetAccountId;
    
    @NotNull(message = "Amount is required")
    @DecimalMin(value = "0.01", message = "Amount must be greater than 0")
    @Digits(integer = 10, fraction = 2, message = "Invalid amount format")
    private BigDecimal amount;
    
    @Size(max = 200, message = "Description too long")
    private String description;
}
```

### Loan Service - LoanRequest

```java
@Data
public class LoanRequest {
    
    @NotNull(message = "User ID is required")
    @Positive
    private Long userId;
    
    @NotNull(message = "Amount is required")
    @DecimalMin(value = "100.00", message = "Minimum loan amount is 100")
    @DecimalMax(value = "100000.00", message = "Maximum loan amount is 100,000")
    private BigDecimal amount;
    
    @NotNull(message = "Term is required")
    @Min(value = 1, message = "Minimum term is 1 month")
    @Max(value = 60, message = "Maximum term is 60 months")
    private Integer termMonths;
}
```

### Pool Service - InvestmentRequest

```java
@Data
public class InvestmentRequest {
    
    @NotNull(message = "User ID is required")
    @Positive
    private Long userId;
    
    @NotNull(message = "Pool ID is required")
    @Positive
    private Long poolId;
    
    @NotNull(message = "Amount is required")
    @DecimalMin(value = "100.00", message = "Minimum investment is 100")
    private BigDecimal amount;
}
```

---

## 🎮 Uso en Controllers

### Habilitar Validación con @Valid

```java
@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody RegisterRequest request) {
        // La validación ocurre automáticamente
        // Si falla, lanza MethodArgumentNotValidException
        return authService.register(request);
    }
}
```

### Validación de Path Variables

```java
@GetMapping("/{id}")
public ResponseEntity<?> getUser(
    @PathVariable @Positive(message = "ID must be positive") Long id
) {
    return userService.findById(id);
}
```

### Validación de Query Parameters

```java
@PostMapping("/deposit")
public ResponseEntity<?> deposit(
    @RequestParam @Positive Long userId,
    @RequestParam @DecimalMin("0.01") BigDecimal amount
) {
    return transactionService.deposit(userId, amount);
}
```

---

## ⚠️ Manejo de Errores de Validación

El GlobalExceptionHandler ya maneja estos errores:

```java
@ExceptionHandler(MethodArgumentNotValidException.class)
public ResponseEntity<ErrorResponse> handleValidationException(
        MethodArgumentNotValidException ex, HttpServletRequest request) {
    
    List<String> errors = ex.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .collect(Collectors.toList());
    
    ErrorResponse error = ErrorResponse.of(
            HttpStatus.BAD_REQUEST.value(),
            "Bad Request",
            "Validation failed",
            request.getRequestURI(),
            errors
    );
    
    return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
}
```

**Respuesta de Error:**
```json
{
  "timestamp": "2025-12-11T15:00:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "path": "/api/v1/auth/register",
  "errors": [
    "email: Invalid email format",
    "password: Password must be at least 6 characters"
  ]
}
```

---

## 🔍 Validaciones Personalizadas

### Crear Anotación Custom

```java
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PhoneValidator.class)
public @interface ValidPhone {
    String message() default "Invalid phone number";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

### Implementar Validator

```java
public class PhoneValidator implements ConstraintValidator<ValidPhone, String> {
    
    @Override
    public boolean isValid(String phone, ConstraintValidatorContext context) {
        if (phone == null) return true; // Use @NotNull separately
        return phone.matches("^[0-9]{10}$");
    }
}
```

### Usar

```java
@ValidPhone(message = "Phone must be 10 digits")
private String phone;
```

---

## ✅ Checklist de Implementación

Por cada DTO:
- [ ] Agregar anotaciones de validación
- [ ] Configurar mensajes personalizados
- [ ] Agregar @Valid en controller
- [ ] Probar en Swagger UI
- [ ] Verificar ErrorResponse

---

## 🧪 Testing Validaciones

```java
@Test
void shouldFailValidationForInvalidEmail() {
    RegisterRequest request = new RegisterRequest();
    request.setEmail("invalid-email");
    
    Set<ConstraintViolation<RegisterRequest>> violations = 
        validator.validate(request);
    
    assertThat(violations).isNotEmpty();
    assertThat(violations).anyMatch(v -> 
        v.getMessage().contains("Invalid email format"));
}
```

---

**Implementado:** GlobalExceptionHandler maneja validaciones  
**Pendiente:** Agregar anotaciones @Valid en DTOs y controllers

