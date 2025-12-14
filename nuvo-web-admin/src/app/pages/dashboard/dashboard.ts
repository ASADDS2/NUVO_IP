import { ChangeDetectorRef, Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';
import { BaseChartDirective } from 'ng2-charts';
import { ChartConfiguration, ChartData } from 'chart.js';
import { forkJoin, of } from 'rxjs';
import { catchError } from 'rxjs/operators';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [
    CommonModule,
    BaseChartDirective
  ],
  templateUrl: './dashboard.html',
  styleUrls: ['./dashboard.css']
})
export class DashboardComponent implements OnInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef);

  // Datos reales
  totalUsers = 10;
  totalMoney = 3699300;
  activeLoans = 0;
  activePools = 0;
  isLoading = false;

  // Line Chart Configuration (Gráfico de Área)
  public lineChartData: ChartConfiguration<'line'>['data'] = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
    datasets: [
      {
        data: [2, 3, 4, 5, 6, 7, 8, 8, 9, 9, 10, 10],
        label: 'Usuarios',
        fill: true,
        tension: 0.4,
        borderColor: '#00E676',
        backgroundColor: 'rgba(0, 230, 118, 0.2)',
        pointBackgroundColor: '#00E676',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: '#00E676',
        pointRadius: 0,
        pointHoverRadius: 6,
        borderWidth: 3
      }
    ]
  };

  public lineChartOptions: ChartConfiguration<'line'>['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: 'rgba(0,0,0,0.8)',
        titleColor: '#fff',
        bodyColor: '#fff',
        padding: 12,
        cornerRadius: 8,
        displayColors: false,
        callbacks: {
          label: function (context) {
            return context.parsed.y + ' usuarios';
          }
        }
      }
    },
    scales: {
      x: {
        grid: {
          color: 'rgba(255,255,255,0.05)'
        },
        ticks: {
          color: '#9CA3AF',
          font: { size: 11 }
        }
      },
      y: {
        grid: {
          color: 'rgba(255,255,255,0.05)'
        },
        ticks: {
          color: '#9CA3AF',
          font: { size: 11 },
          stepSize: 1
        },
        beginAtZero: true
      }
    },
    interaction: {
      intersect: false,
      mode: 'index'
    }
  };

  // Bar Chart Configuration (Barras Horizontales)
  public barChartData: ChartData<'bar'> = {
    labels: ['Aprobados', 'Pendientes', 'Pagados', 'Rechazados'],
    datasets: [
      {
        data: [3, 2, 0, 0],
        backgroundColor: ['#00E676', '#EAB308', '#3B82F6', '#EF4444'],
        borderRadius: 8,
        barThickness: 20
      }
    ]
  };

  public barChartOptions: ChartConfiguration<'bar'>['options'] = {
    indexAxis: 'y',
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: 'rgba(0,0,0,0.8)',
        titleColor: '#fff',
        bodyColor: '#fff',
        padding: 12,
        cornerRadius: 8,
        displayColors: false
      }
    },
    scales: {
      x: {
        grid: {
          color: 'rgba(255,255,255,0.05)'
        },
        ticks: {
          color: '#9CA3AF',
          font: { size: 11 }
        }
      },
      y: {
        grid: {
          display: false
        },
        ticks: {
          color: '#9CA3AF',
          font: { size: 11 }
        }
      }
    }
  };

  // Money Flow Chart Configuration
  public moneyFlowChartData: ChartConfiguration<'line'>['data'] = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
    datasets: [
      {
        data: [150000, 200000, 250000, 300000, 350000, 400000, 450000, 500000, 550000, 600000, 650000, 700000],
        label: 'Ingresos',
        fill: false,
        tension: 0.4,
        borderColor: '#00E676',
        pointBackgroundColor: '#00E676',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: '#00E676',
        pointRadius: 4,
        pointHoverRadius: 6,
        borderWidth: 2
      },
      {
        data: [50000, 60000, 70000, 80000, 90000, 100000, 110000, 120000, 130000, 140000, 150000, 160000],
        label: 'Egresos',
        fill: false,
        tension: 0.4,
        borderColor: '#EF4444',
        pointBackgroundColor: '#EF4444',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: '#EF4444',
        pointRadius: 4,
        pointHoverRadius: 6,
        borderWidth: 2
      }
    ]
  };

  public moneyFlowChartOptions: ChartConfiguration<'line'>['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: true,
        position: 'top',
        labels: {
          color: '#9CA3AF',
          font: { size: 12 },
          usePointStyle: true,
          padding: 15
        }
      },
      tooltip: {
        backgroundColor: 'rgba(0,0,0,0.8)',
        titleColor: '#fff',
        bodyColor: '#fff',
        padding: 12,
        cornerRadius: 8,
        displayColors: true,
        callbacks: {
          label: function (context) {
            return context.dataset.label + ': $' + (context.parsed.y || 0).toLocaleString();
          }
        }
      }
    },
    scales: {
      x: {
        grid: {
          color: 'rgba(255,255,255,0.05)'
        },
        ticks: {
          color: '#9CA3AF',
          font: { size: 11 }
        }
      },
      y: {
        grid: {
          color: 'rgba(255,255,255,0.05)'
        },
        ticks: {
          color: '#9CA3AF',
          font: { size: 11 },
          callback: function (value) {
            return '$' + (value as number).toLocaleString();
          }
        },
        beginAtZero: true
      }
    },
    interaction: {
      intersect: false,
      mode: 'index'
    }
  };

  ngOnInit() {
    console.log('📊 Dashboard cargado con gráficos...');
    this.loadDashboardData();
  }

  private loadDashboardData() {
    // Cargar todos los datos en paralelo para mejor rendimiento
    forkJoin({
      accounts: this.dataService.getAllAccounts().pipe(
        catchError(err => {
          console.error('❌ Error loading accounts:', err);
          return of([]);
        })
      ),
      loans: this.dataService.getAllLoans().pipe(
        catchError(err => {
          console.error('❌ Error loading loans:', err);
          return of([]);
        })
      ),
      pools: this.dataService.getAllPools().pipe(
        catchError(err => {
          console.error('❌ Error loading pools:', err);
          return of([]);
        })
      )
    }).subscribe({
      next: (data) => {
        console.log('✅ Datos recibidos:', data);

        // Procesar cuentas
        if (Array.isArray(data.accounts)) {
          this.totalUsers = data.accounts.length;
          this.totalMoney = data.accounts.reduce((acc: number, curr: any) => acc + (curr.balance || 0), 0);

          // Actualizar gráfico de usuarios (simulando crecimiento mensual)
          this.updateUserGrowthChart(data.accounts);
        }

        // Procesar préstamos
        if (Array.isArray(data.loans)) {
          this.activeLoans = data.loans.filter((loan: any) => loan.status === 'APPROVED' || loan.status === 'PENDING').length;
          this.updateLoanStatusChart(data.loans);
        }

        // Procesar pools
        if (Array.isArray(data.pools)) {
          // Fix: PoolStats has a nested 'pool' object with 'active' boolean
          this.activePools = data.pools.filter((stats: any) => stats.pool && stats.pool.active === true).length;
          console.log('✅ Active Pools:', this.activePools);
        }

        console.log('✅ Active Loans:', this.activeLoans);

        this.isLoading = false;
        this.cdr.detectChanges(); // Force view update

        // Mostrar notificación de éxito
        Swal.fire({
          title: '¡Dashboard Actualizado!',
          html: `<div class="text-left">
            <p>✓ ${data.accounts?.length || 0} cuentas</p>
            <p>✓ ${data.loans?.length || 0} préstamos</p>
            <p>✓ ${data.pools?.length || 0} pools</p>
          </div>`,
          icon: 'success',
          toast: true,
          position: 'top-end',
          showConfirmButton: false,
          timer: 2500,
          background: '#1f2937',
          color: '#fff'
        });
      },
      error: (err) => {
        console.error('❌ Error cargando dashboard:', err);
        this.isLoading = false;

        Swal.fire({
          title: 'Error',
          text: 'No se pudieron cargar los datos del dashboard',
          icon: 'error',
          confirmButtonColor: '#ef4444',
          background: '#1f2937',
          color: '#fff'
        });
      }
    });
  }

  private updateUserGrowthChart(accounts: any[]) {
    // Simular crecimiento mensual basado en fechas de creación
    const monthlyData = new Array(12).fill(0);

    accounts.forEach(account => {
      if (account.createdAt) {
        const month = new Date(account.createdAt).getMonth();
        monthlyData[month]++;
      }
    });

    // Acumular para mostrar crecimiento
    for (let i = 1; i < monthlyData.length; i++) {
      monthlyData[i] += monthlyData[i - 1];
    }

    if (this.lineChartData.datasets && this.lineChartData.datasets[0]) {
      this.lineChartData.datasets[0].data = monthlyData;
    }
  }

  private updateLoanStatusChart(loans: any[]) {
    const statusCount = {
      APPROVED: 0,
      PENDING: 0,
      PAID: 0,
      REJECTED: 0
    };

    loans.forEach(loan => {
      if (loan.status && statusCount.hasOwnProperty(loan.status)) {
        statusCount[loan.status as keyof typeof statusCount]++;
      }
    });

    if (this.barChartData.datasets && this.barChartData.datasets[0]) {
      this.barChartData.datasets[0].data = [
        statusCount.APPROVED,
        statusCount.PENDING,
        statusCount.PAID,
        statusCount.REJECTED
      ];
    }
  }
}