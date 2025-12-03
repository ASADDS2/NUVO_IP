import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-loans',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './loans.html',
})
export class LoansComponent implements OnInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef); // ⚡

  loans: any[] = [];
  isLoading = true;

  ngOnInit() {
    this.loadLoans();
  }

  loadLoans() {
    console.log('💸 Cargando Préstamos...');
    this.isLoading = true;

    this.dataService.getAllLoans().subscribe({
      next: (data: any) => {
        console.log('✅ Préstamos recibidos:', data);
        
        if (Array.isArray(data)) {
          this.loans = data;
        } else {
          this.loans = data.content || [];
        }

        this.isLoading = false;
        this.cdr.detectChanges(); // ⚡
      },
      error: (err: any) => {
        console.error('❌ Error cargando préstamos:', err);
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }

  onApprove(loan: any) {
    Swal.fire({
      title: '¿Aprobar Préstamo?',
      html: `<div class="text-left">
        <p><strong>ID Cliente:</strong> #${loan.userId}</p>
        <p><strong>Monto:</strong> $${loan.amount.toLocaleString()}</p>
        <p><strong>Plazo:</strong> ${loan.termMonths} meses</p>
        <p><strong>Interés:</strong> ${(loan.interestRate * 100).toFixed(2)}%</p>
      </div>`,
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#10b981',
      cancelButtonColor: '#6b7280',
      confirmButtonText: '✓ Aprobar',
      cancelButtonText: 'Cancelar',
      background: '#1f2937',
      color: '#fff'
    }).then((result) => {
      if (result.isConfirmed) {
        this.dataService.approveLoan(loan.id).subscribe({
          next: (res: any) => {
            Swal.fire({
              title: '¡Aprobado!',
              text: 'El préstamo ha sido aprobado exitosamente',
              icon: 'success',
              confirmButtonColor: '#10b981',
              background: '#1f2937',
              color: '#fff'
            }).then(() => this.loadLoans());
          },
          error: (err: any) => {
            Swal.fire({
              title: 'Error',
              text: 'No se pudo aprobar el préstamo',
              icon: 'error',
              confirmButtonColor: '#ef4444',
              background: '#1f2937',
              color: '#fff'
            });
          }
        });
      }
    });
  }

  onReject(loan: any) {
    Swal.fire({
      title: '¿Rechazar Préstamo?',
      html: `<div class="text-left">
        <p><strong>ID Cliente:</strong> #${loan.userId}</p>
        <p><strong>Monto:</strong> $${loan.amount.toLocaleString()}</p>
        <p><strong>Plazo:</strong> ${loan.termMonths} meses</p>
        <p><strong>Interés:</strong> ${(loan.interestRate * 100).toFixed(2)}%</p>
      </div>`,
      input: 'textarea',
      inputPlaceholder: 'Motivo del rechazo (opcional)',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#ef4444',
      cancelButtonColor: '#6b7280',
      confirmButtonText: '✗ Rechazar',
      cancelButtonText: 'Cancelar',
      background: '#1f2937',
      color: '#fff'
    }).then((result) => {
      if (result.isConfirmed) {
        this.dataService.rejectLoan(loan.id).subscribe({
          next: (res: any) => {
            Swal.fire({
              title: 'Rechazado',
              text: 'El préstamo ha sido rechazado',
              icon: 'info',
              confirmButtonColor: '#ef4444',
              background: '#1f2937',
              color: '#fff'
            }).then(() => this.loadLoans());
          },
          error: (err: any) => {
            Swal.fire({
              title: 'Error',
              text: 'No se pudo rechazar el préstamo',
              icon: 'error',
              confirmButtonColor: '#ef4444',
              background: '#1f2937',
              color: '#fff'
            });
          }
        });
      }
    });
  }

  // Métodos para estadísticas
  getTotalLoans(): number {
    return this.loans.length;
  }

  getApprovedLoans(): number {
    return this.loans.filter(l => l.status === 'APPROVED').length;
  }

  getPendingLoans(): number {
    return this.loans.filter(l => l.status === 'PENDING').length;
  }

  getRejectedLoans(): number {
    return this.loans.filter(l => l.status === 'REJECTED').length;
  }

  getTotalAmount(): number {
    return this.loans.reduce((sum, l) => sum + (l.amount || 0), 0);
  }
}