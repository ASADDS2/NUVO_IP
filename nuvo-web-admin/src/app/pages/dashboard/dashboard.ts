import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';
import { LucideAngularModule } from 'lucide-angular';
import { BaseChartDirective } from 'ng2-charts';
import { ChartConfiguration, ChartData } from 'chart.js';
import { forkJoin } from 'rxjs';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [
    CommonModule,
    LucideAngularModule,
    BaseChartDirective
  ],
  templateUrl: './dashboard.html',
  styleUrls: ['./dashboard.css']
})
export class DashboardComponent implements OnInit {
  private dataService = inject(DataService);

  // Datos reales
  totalUsers = 0;
  totalMoney = 0;
  activeLoans = 0;
  activePools = 0;
  isLoading = false;

  // Line Chart Configuration (Gráfico de Área)
  public lineChartData: ChartConfiguration<'line'>['data'] = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
    datasets: [
      {
        data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
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
        data: [0, 0, 0, 0],
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

  ngOnInit() {
    console.log('📊 Cargando Dashboard con datos reales...');
    this.loadDashboardData();
  }

  private loadDashboardData() {
    // Cargar todos los datos en paralelo para mejor rendimiento
    forkJoin({
      accounts: this.dataService.getAllAccounts(),
      loans: this.dataService.getAllLoans(),
      pools: this.dataService.getAllPools()
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
          this.activePools = data.pools.filter((pool: any) => pool.status === 'ACTIVE').length;
        }

        this.isLoading = false;
      },
      error: (err) => {
        console.error('❌ Error cargando dashboard:', err);
        this.isLoading = false;
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