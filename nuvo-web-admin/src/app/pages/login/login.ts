import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink, Router } from '@angular/router';
import { AuthService } from '../../services/auth';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './login.html',
})
export class LoginComponent {
  private authService = inject(AuthService);
  private router = inject(Router);

  email = '';
  password = '';
  isLoading = false;
  errorMessage = '';
  showPassword = false;
  rememberMe = false;

  togglePassword() {
    this.showPassword = !this.showPassword;
  }

  onLogin() {
    // Validar que los campos no estén vacíos
    if (!this.email || !this.password) {
      Swal.fire({
        title: 'Campos Requeridos',
        text: 'Por favor ingresa tu correo y contraseña',
        icon: 'warning',
        confirmButtonColor: '#10b981',
        background: '#1f2937',
        color: '#fff'
      });
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    this.authService.login(this.email, this.password).subscribe({
      next: () => {
        this.isLoading = false;
        
        // Mostrar animación de carga
        Swal.fire({
          title: 'Iniciando sesión...',
          icon: 'info',
          background: '#1f2937',
          color: '#fff',
          allowOutsideClick: false,
          allowEscapeKey: false,
          didOpen: () => {
            Swal.showLoading();
          }
        });

        // Simular pequeño delay para animación
        setTimeout(() => {
          Swal.fire({
            title: '¡Bienvenido!',
            text: 'Sesión iniciada exitosamente',
            icon: 'success',
            confirmButtonColor: '#10b981',
            background: '#1f2937',
            color: '#fff',
            allowOutsideClick: false,
            allowEscapeKey: false
          }).then(() => {
            this.router.navigate(['/app/dashboard']);
          });
        }, 800);
      },
      error: (err) => {
        this.isLoading = false;
        console.error(err);
        this.errorMessage = 'Credenciales incorrectas o error de conexión.';

        Swal.fire({
          title: '❌ Credenciales Incorrectas',
          html: `<div class="text-left">
            <p class="mb-3">El correo o contraseña que ingresaste son incorrectos.</p>
            <p class="text-sm text-gray-400">Por favor intenta de nuevo.</p>
          </div>`,
          icon: 'error',
          showCancelButton: true,
          confirmButtonColor: '#10b981',
          cancelButtonColor: '#6b7280',
          confirmButtonText: '🔄 Intentar de Nuevo',
          cancelButtonText: 'Cancelar',
          background: '#1f2937',
          color: '#fff',
          allowOutsideClick: false,
          allowEscapeKey: false
        }).then((result) => {
          if (result.isConfirmed) {
            // Limpiar los campos para que el usuario pueda reintentar
            this.email = '';
            this.password = '';
            this.errorMessage = '';
            
            // Mostrar alerta para reintentar
            Swal.fire({
              title: 'Intenta de Nuevo',
              text: 'Ingresa tus credenciales correctas',
              icon: 'info',
              confirmButtonColor: '#10b981',
              background: '#1f2937',
              color: '#fff'
            });
          }
        });
      }
    });
  }
}