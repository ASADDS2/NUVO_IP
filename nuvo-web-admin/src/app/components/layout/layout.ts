import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, RouterLinkActive, Router } from '@angular/router';
import { AuthService } from '../../services/auth';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './layout.html',
  styleUrls: ['./layout.css']
})
export class LayoutComponent {
  private authService = inject(AuthService);
  private router = inject(Router);

  onLogout() {
    Swal.fire({
      title: '¿Cerrar Sesión?',
      text: 'Se cerrará tu sesión actual',
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#ef4444',
      cancelButtonColor: '#6b7280',
      confirmButtonText: '✓ Cerrar Sesión',
      cancelButtonText: 'Cancelar',
      background: '#1f2937',
      color: '#fff',
      allowOutsideClick: false,
      allowEscapeKey: false
    }).then((result) => {
      if (result.isConfirmed) {
        // Mostrar animación de carga
        Swal.fire({
          title: 'Cerrando sesión...',
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
          this.authService.logout();
          
          Swal.fire({
            title: '¡Sesión Cerrada!',
            text: 'Hasta luego',
            icon: 'success',
            confirmButtonColor: '#10b981',
            background: '#1f2937',
            color: '#fff',
            allowOutsideClick: false,
            allowEscapeKey: false
          }).then(() => {
            this.router.navigate(['/login']);
          });
        }, 800);
      }
    });
  }
}