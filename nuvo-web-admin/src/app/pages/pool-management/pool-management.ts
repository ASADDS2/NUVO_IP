import { Component, OnInit, OnDestroy, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { DataService } from '../../services/data';
import { Pool, PoolStats, CreatePoolRequest } from '../../models/pool.model';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-pool-management',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './pool-management.html',
  styleUrl: './pool-management.css'
})
export class PoolManagementComponent implements OnInit, OnDestroy {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef);

  pools: PoolStats[] = [];
  isLoading = true;
  showForm = false;
  selectedPool: Pool | null = null;
  lastUpdate: Date = new Date();
  autoRefreshInterval: any;
  uiUpdateInterval: any;

  newPool: CreatePoolRequest = {
    name: '',
    description: '',
    interestRatePerDay: 0.01,
    maxParticipants: 50
  };

  ngOnInit() {
    this.loadPools();
    
    // Auto-refresh de datos cada 10 segundos
    this.autoRefreshInterval = setInterval(() => {
      this.loadPools(true);
    }, 10000);
    
    // Actualizar UI cada segundo para mostrar timestamp actualizado
    this.uiUpdateInterval = setInterval(() => {
      this.cdr.detectChanges();
    }, 1000);
  }

  ngOnDestroy() {
    if (this.autoRefreshInterval) {
      clearInterval(this.autoRefreshInterval);
    }
    if (this.uiUpdateInterval) {
      clearInterval(this.uiUpdateInterval);
    }
  }

  loadPools(silent: boolean = false) {
    console.log('⚙️ [PoolManagement] Iniciando carga de pools...');
    if (!silent) {
      this.isLoading = true;
    }
    
    this.dataService.getAllPools().subscribe({
      next: (data) => {
        console.log('✅ [PoolManagement] Pools recibidos:', data);
        console.log('📊 [PoolManagement] Total de pools:', data?.length || 0);
        this.pools = data;
        this.lastUpdate = new Date();
        if (!silent) {
          this.isLoading = false;
        }
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('❌ [PoolManagement] Error cargando pools:', err);
        console.error('❌ [PoolManagement] Status:', err.status);
        console.error('❌ [PoolManagement] Message:', err.message);
        if (!silent) {
          alert(`Error al cargar pools: ${err.message || 'Error desconocido'}`);
          this.isLoading = false;
        }
        this.cdr.detectChanges();
      }
    });
  }

  openCreateForm() {
    Swal.fire({
      title: 'Crear Nuevo Pool',
      html: `
        <div class="text-left space-y-4">
          <div>
            <label class="block text-sm font-semibold text-gray-300 mb-2">Nombre *</label>
            <input id="poolName" type="text" placeholder="Ej: Pool VIP" 
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-500 focus:outline-none">
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-300 mb-2">Descripción</label>
            <textarea id="poolDesc" placeholder="Descripción del pool" rows="3"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-500 focus:outline-none"></textarea>
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-300 mb-2">Tasa de Interés Diaria * (%)</label>
            <input id="poolRate" type="number" step="0.001" min="0" max="1" placeholder="0.01" value="0.01"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-500 focus:outline-none">
            <p class="text-xs text-gray-400 mt-1">Ejemplo: 0.01 = 1% diario</p>
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-300 mb-2">Máximo de Participantes *</label>
            <input id="poolMax" type="number" min="1" placeholder="50" value="50"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-500 focus:outline-none">
          </div>
        </div>
      `,
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#10b981',
      cancelButtonColor: '#6b7280',
      confirmButtonText: '✓ Crear Pool',
      cancelButtonText: 'Cancelar',
      background: '#1f2937',
      color: '#fff',
      didOpen: () => {
        const nameInput = document.getElementById('poolName') as HTMLInputElement;
        if (nameInput) nameInput.focus();
      }
    }).then((result) => {
      if (result.isConfirmed) {
        const name = (document.getElementById('poolName') as HTMLInputElement)?.value;
        const description = (document.getElementById('poolDesc') as HTMLTextAreaElement)?.value;
        const rate = parseFloat((document.getElementById('poolRate') as HTMLInputElement)?.value || '0.01');
        const maxParticipants = parseInt((document.getElementById('poolMax') as HTMLInputElement)?.value || '50');

        if (!name) {
          Swal.fire({
            title: 'Error',
            text: 'El nombre del pool es requerido',
            icon: 'error',
            confirmButtonColor: '#ef4444',
            background: '#1f2937',
            color: '#fff'
          });
          return;
        }

        this.newPool = {
          name,
          description,
          interestRatePerDay: rate,
          maxParticipants
        };
        this.createPool();
      }
    });
  }

  openEditForm(pool: Pool) {
    Swal.fire({
      title: 'Editar Pool',
      html: `
        <div class="text-left space-y-4">
          <div>
            <label class="block text-sm font-semibold text-gray-300 mb-2">Nombre *</label>
            <input id="poolName" type="text" placeholder="Ej: Pool VIP" value="${pool.name}"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-500 focus:outline-none">
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-300 mb-2">Descripción</label>
            <textarea id="poolDesc" placeholder="Descripción del pool" rows="3"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-500 focus:outline-none">${pool.description}</textarea>
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-300 mb-2">Tasa de Interés Diaria * (%)</label>
            <input id="poolRate" type="number" step="0.001" min="0" max="1" value="${pool.interestRatePerDay}"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-500 focus:outline-none">
            <p class="text-xs text-gray-400 mt-1">Ejemplo: 0.01 = 1% diario</p>
          </div>
          <div>
            <label class="block text-sm font-semibold text-gray-300 mb-2">Máximo de Participantes *</label>
            <input id="poolMax" type="number" min="1" value="${pool.maxParticipants}"
              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded text-white placeholder-gray-400 focus:border-green-500 focus:outline-none">
          </div>
        </div>
      `,
      icon: 'info',
      showCancelButton: true,
      confirmButtonColor: '#10b981',
      cancelButtonColor: '#6b7280',
      confirmButtonText: '✓ Actualizar',
      cancelButtonText: 'Cancelar',
      background: '#1f2937',
      color: '#fff',
      didOpen: () => {
        const nameInput = document.getElementById('poolName') as HTMLInputElement;
        if (nameInput) nameInput.focus();
      }
    }).then((result) => {
      if (result.isConfirmed) {
        const name = (document.getElementById('poolName') as HTMLInputElement)?.value;
        const description = (document.getElementById('poolDesc') as HTMLTextAreaElement)?.value;
        const rate = parseFloat((document.getElementById('poolRate') as HTMLInputElement)?.value || '0.01');
        const maxParticipants = parseInt((document.getElementById('poolMax') as HTMLInputElement)?.value || '50');

        if (!name) {
          Swal.fire({
            title: 'Error',
            text: 'El nombre del pool es requerido',
            icon: 'error',
            confirmButtonColor: '#ef4444',
            background: '#1f2937',
            color: '#fff'
          });
          return;
        }

        this.selectedPool = pool;
        this.newPool = {
          name,
          description,
          interestRatePerDay: rate,
          maxParticipants
        };
        this.updatePool();
      }
    });
  }

  closeForm() {
    this.showForm = false;
    this.selectedPool = null;
  }

  createPool() {
    if (!this.newPool.name) {
      Swal.fire({
        title: 'Error',
        text: 'El nombre del pool es requerido',
        icon: 'error',
        confirmButtonColor: '#ef4444',
        background: '#1f2937',
        color: '#fff'
      });
      return;
    }

    this.dataService.createPool(this.newPool).subscribe({
      next: () => {
        Swal.fire({
          title: '¡Éxito!',
          text: 'Pool creado exitosamente',
          icon: 'success',
          confirmButtonColor: '#10b981',
          background: '#1f2937',
          color: '#fff'
        }).then(() => {
          this.closeForm();
          this.loadPools();
        });
      },
      error: (err) => {
        console.error('Error creando pool:', err);
        Swal.fire({
          title: 'Error',
          text: err.error || 'Error al crear pool',
          icon: 'error',
          confirmButtonColor: '#ef4444',
          background: '#1f2937',
          color: '#fff'
        });
      }
    });
  }

  updatePool() {
    if (!this.selectedPool) return;

    this.dataService.updatePool(this.selectedPool.id, {
      name: this.newPool.name,
      description: this.newPool.description,
      maxParticipants: this.newPool.maxParticipants,
      interestRatePerDay: this.newPool.interestRatePerDay
    }).subscribe({
      next: () => {
        Swal.fire({
          title: '¡Actualizado!',
          text: 'Pool actualizado exitosamente',
          icon: 'success',
          confirmButtonColor: '#10b981',
          background: '#1f2937',
          color: '#fff'
        }).then(() => {
          this.closeForm();
          this.loadPools();
        });
      },
      error: (err) => {
        console.error('Error actualizando pool:', err);
        Swal.fire({
          title: 'Error',
          text: err.error || 'Error al actualizar pool',
          icon: 'error',
          confirmButtonColor: '#ef4444',
          background: '#1f2937',
          color: '#fff'
        });
      }
    });
  }

  deletePool(pool: Pool) {
    Swal.fire({
      title: '¿Eliminar Pool?',
      html: `<div class="text-left">
        <p><strong>Nombre:</strong> ${pool.name}</p>
        <p class="text-red-400 mt-2"><strong>⚠️ ATENCIÓN:</strong> Todas las inversiones activas serán retiradas automáticamente.</p>
      </div>`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#ef4444',
      cancelButtonColor: '#6b7280',
      confirmButtonText: '✗ Eliminar',
      cancelButtonText: 'Cancelar',
      background: '#1f2937',
      color: '#fff'
    }).then((result) => {
      if (result.isConfirmed) {
        this.dataService.deletePool(pool.id).subscribe({
          next: () => {
            Swal.fire({
              title: 'Eliminado',
              text: 'Pool eliminado exitosamente',
              icon: 'success',
              confirmButtonColor: '#10b981',
              background: '#1f2937',
              color: '#fff'
            }).then(() => this.loadPools());
          },
          error: (err) => {
            console.error('Error eliminando pool:', err);
            Swal.fire({
              title: 'Error',
              text: err.error || 'Error al eliminar pool',
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

  toggleStatus(pool: Pool) {
    const action = pool.active ? 'desactivar' : 'activar';
    Swal.fire({
      title: `¿${action.charAt(0).toUpperCase() + action.slice(1)} Pool?`,
      text: `${action.charAt(0).toUpperCase() + action.slice(1)} "${pool.name}"`,
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#10b981',
      cancelButtonColor: '#6b7280',
      confirmButtonText: 'Sí, ' + action,
      cancelButtonText: 'Cancelar',
      background: '#1f2937',
      color: '#fff'
    }).then((result) => {
      if (result.isConfirmed) {
        this.dataService.updatePool(pool.id, {
          active: !pool.active
        }).subscribe({
          next: () => {
            pool.active = !pool.active;
            Swal.fire({
              title: '¡Listo!',
              text: `Pool ${pool.active ? 'activado' : 'desactivado'}`,
              icon: 'success',
              confirmButtonColor: '#10b981',
              background: '#1f2937',
              color: '#fff'
            });
          },
          error: (err) => {
            console.error('Error actualizando estado:', err);
            Swal.fire({
              title: 'Error',
              text: 'Error al cambiar estado',
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

  getPercentageFilled(stats: PoolStats): number {
    return (stats.currentInvestors / stats.pool.maxParticipants) * 100;
  }

  getStatusColor(pool: Pool, percentage: number): string {
    if (!pool.active) return 'bg-gray-100 text-gray-600';
    if (percentage >= 100) return 'bg-red-100 text-red-700';
    if (percentage >= 80) return 'bg-yellow-100 text-yellow-700';
    return 'bg-green-100 text-green-700';
  }

  getInterestGain(stats: PoolStats): number {
    if (stats.totalInvested === 0) return 0;
    return ((stats.totalCurrentValue - stats.totalInvested) / stats.totalInvested) * 100;
  }

  getTimeSinceUpdate(): string {
    const seconds = Math.floor((new Date().getTime() - this.lastUpdate.getTime()) / 1000);
    if (seconds < 5) return 'ahora';
    return `hace ${seconds}s`;
  }

  // Métodos para estadísticas
  getTotalPools(): number {
    return this.pools.length;
  }

  getActivePools(): number {
    return this.pools.filter(p => p.pool.active).length;
  }

  getTotalInvestors(): number {
    return this.pools.reduce((sum, p) => sum + p.currentInvestors, 0);
  }

  getTotalInvested(): number {
    return this.pools.reduce((sum, p) => sum + p.totalInvested, 0);
  }

  getTotalCurrentValue(): number {
    return this.pools.reduce((sum, p) => sum + p.totalCurrentValue, 0);
  }
}
