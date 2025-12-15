import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';
import Swal from 'sweetalert2';
import { forkJoin, map, of } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Component({
  selector: 'app-accounts',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './accounts.html',
})
export class AccountsComponent implements OnInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef); // ⚡

  accounts: any[] = [];
  isLoading = true;

  ngOnInit() {
    this.loadAccounts();
  }

  loadAccounts() {
    console.log('👥 Cargando Cuentas...');
    this.isLoading = true;

    this.dataService.getAllAccounts().subscribe({
      next: (data: any) => {
        console.log('✅ Cuentas recibidas:', data);

        let initialAccounts = [];
        if (Array.isArray(data)) {
          initialAccounts = data;
        } else {
          // Fallback por si viene envuelto en un objeto
          initialAccounts = data.content || [];
        }

        // Fetch user details for each account
        if (initialAccounts.length > 0) {
          const userRequests = initialAccounts.map((acc: any) =>
            this.dataService.getUserById(acc.userId).pipe(
              map((user: any) => ({
                ...acc,
                accountHolder: `${user.firstname} ${user.lastname}`,
                userPhone: user.phone
              })),
              catchError(() => of({ ...acc, accountHolder: 'Desconocido', userPhone: 'N/A' }))
            )
          );

          forkJoin(userRequests).subscribe({
            next: (updatedAccounts: any) => {
              this.accounts = updatedAccounts;
              this.isLoading = false;
              this.cdr.detectChanges();
              this.showSuccessToast();
            },
            error: (err) => {
              console.error('Error fetching user details', err);
              this.accounts = initialAccounts; // Fallback to accounts without names
              this.isLoading = false;
              this.cdr.detectChanges();
            }
          });
        } else {
          this.accounts = [];
          this.isLoading = false;
          this.cdr.detectChanges();
        }
      },
      error: (err: any) => {
        console.error(': ', err);
        this.isLoading = false;
        this.cdr.detectChanges();

        Swal.fire({
          title: 'Error',
          text: 'No se pudieron cargar las cuentas',
          icon: 'error',
          confirmButtonColor: '#ef4444',
          background: '#1f2937',
          color: '#fff'
        });
      }
    });
  }

  showSuccessToast() {
    if (this.accounts.length > 0) {
      Swal.fire({
        title: '!Cuentas Cargadas!',
        text: `Se cargaron ${this.accounts.length} cuenta(s) exitosamente`,
        icon: 'success',
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 2000,
        background: '#1f2937',
        color: '#fff'
      });
    }
  }

  // --- MODAL LOGIC ---
  showModal = false;
  selectedAccount: any = null;
  selectedUser: any = null; // 👤 Nuevo
  userLoans: any[] = [];
  isLoadingLoans = false;

  openModal(account: any) {
    this.selectedAccount = account;
    this.showModal = true;
    this.isLoadingLoans = true;
    this.userLoans = [];
    this.selectedUser = null; // Reset

    // 1. Cargar Préstamos
    this.dataService.getLoansByUserId(account.userId).subscribe({
      next: (loans: any[]) => {
        this.userLoans = loans;
        this.isLoadingLoans = false;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('Error fetching loans', err);
        this.isLoadingLoans = false;
        this.cdr.detectChanges();
      }
    });

    // 2. Cargar Datos del Usuario
    this.dataService.getUserById(account.userId).subscribe({
      next: (user: any) => {
        console.log('👤 Usuario cargado:', user);
        this.selectedUser = user;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('Error fetching user', err);
      }
    });
  }

  closeModal() {
    this.showModal = false;
    this.selectedAccount = null;
    this.selectedUser = null;
    this.userLoans = [];
  }

  // Métodos para estadísticas
  getActiveCounts(): number {
    return this.accounts.filter(acc => acc.balance > 0).length;
  }

  getTotalBalance(): number {
    return this.accounts.reduce((sum, acc) => sum + (acc.balance || 0), 0);
  }
}