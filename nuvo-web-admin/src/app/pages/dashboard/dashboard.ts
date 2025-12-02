import { Component, OnInit, inject, ChangeDetectorRef, ViewChildren, QueryList, AfterViewInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';
import { LucideAngularModule } from 'lucide-angular';
import { BaseChartDirective } from 'ng2-charts';
import { ChartConfiguration, ChartData, ChartType, Chart } from 'chart.js';
import { registerables } from 'chart.js';

// Register Chart.js components manually to ensure they load
Chart.register(...registerables);

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
export class DashboardComponent implements OnInit, AfterViewInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef);

  @ViewChildren(BaseChartDirective) charts?: QueryList<BaseChartDirective>;

  totalUsers = 0;
  totalMoney = 0;
  isLoading = true;

  // Vibrant Neon Colors
  private colors = {
    neonGreen: '#00FF88',
    neonBlue: '#00CCFF',
    neonPurple: '#D946EF',
    neonYellow: '#FACC15',
    neonRed: '#FF3366',
    darkBg: '#161B2E',
    gridColor: 'rgba(255, 255, 255, 0.05)'
  };

  // 1. User Growth Chart (Gradient Line)
  public lineChartData: ChartConfiguration['data'] = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
    datasets: [
      {
        data: [2, 4, 6, 8, 10, 12, 15, 18, 20, 22, 25, 28],
        label: 'Usuarios Activos',
        fill: true,
        tension: 0.4,
        borderColor: this.colors.neonGreen,
        backgroundColor: (context) => {
          const ctx = context.chart.ctx;
          const gradient = ctx.createLinearGradient(0, 0, 0, 300);
          gradient.addColorStop(0, 'rgba(0, 255, 136, 0.5)');
          gradient.addColorStop(1, 'rgba(0, 255, 136, 0.0)');
          return gradient;
        },
        pointBackgroundColor: '#000',
        pointBorderColor: this.colors.neonGreen,
        pointBorderWidth: 2,
        pointRadius: 0, // Hidden points by default like the image
        pointHoverRadius: 6,
        borderWidth: 3
      }
    ]
  };

  public lineChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: 'rgba(22, 27, 46, 0.9)',
        titleColor: '#fff',
        bodyColor: '#fff',
        borderColor: this.colors.neonGreen,
        borderWidth: 1,
        padding: 12,
        displayColors: false,
        intersect: false,
        mode: 'index',
      }
    },
    scales: {
      x: {
        grid: { display: false },
        ticks: { color: '#6B7280', font: { size: 11 } }
      },
      y: {
        grid: { color: this.colors.gridColor, tickLength: 0 },
        ticks: { color: '#6B7280', font: { size: 11 }, stepSize: 3 },
        beginAtZero: true
      }
    }
  };

  // 2. Loan Status Chart (Horizontal Bar)
  public loanStatusChartData: ChartConfiguration['data'] = {
    labels: ['Aprobados', 'Pendientes', 'Pagados', 'Rechazados'],
    datasets: [
      {
        data: [57, 15, 20, 8],
        backgroundColor: [
          this.colors.neonGreen,
          this.colors.neonYellow,
          this.colors.neonBlue,
          this.colors.neonRed
        ],
        borderRadius: 4,
        barPercentage: 0.5,
        categoryPercentage: 0.8
      }
    ]
  };

  public loanStatusChartOptions: ChartConfiguration['options'] = {
    indexAxis: 'y', // Horizontal Bar Chart
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: 'rgba(22, 27, 46, 0.9)',
        bodyColor: '#fff',
        borderColor: 'rgba(255,255,255,0.1)',
        borderWidth: 1,
        padding: 12
      }
    },
    scales: {
      x: {
        grid: { display: false },
        ticks: { display: false } // Hide x-axis numbers
      },
      y: {
        grid: { display: false },
        ticks: { color: '#9CA3AF', font: { size: 12 } }
      }
    }
  };

  // 3. Money Flow Chart (Dual Line)
  public moneyFlowChartData: ChartConfiguration['data'] = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
    datasets: [
      {
        data: [65000, 72000, 68000, 85000, 92000, 88000, 125000, 115000, 140000, 160000, 180000, 200000],
        label: 'Ingresos',
        borderColor: this.colors.neonGreen,
        backgroundColor: this.colors.neonGreen,
        pointBackgroundColor: '#000',
        pointBorderColor: this.colors.neonGreen,
        pointBorderWidth: 2,
        pointRadius: 4,
        tension: 0.4,
        borderWidth: 3,
        fill: false
      },
      {
        data: [28000, 35000, 30000, 45000, 55000, 52000, 60000, 58000, 75000, 82000, 95000, 110000],
        label: 'Egresos',
        borderColor: this.colors.neonRed,
        backgroundColor: this.colors.neonRed,
        pointBackgroundColor: '#000',
        pointBorderColor: this.colors.neonRed,
        pointBorderWidth: 2,
        pointRadius: 4,
        tension: 0.4,
        borderWidth: 3,
        fill: false
      }
    ]
  };

  public moneyFlowChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: true,
        align: 'end',
        labels: { color: '#9CA3AF', usePointStyle: true, boxWidth: 8 }
      },
      tooltip: {
        backgroundColor: 'rgba(22, 27, 46, 0.9)',
        titleColor: '#fff',
        bodyColor: '#fff',
        borderColor: 'rgba(255,255,255,0.1)',
        borderWidth: 1,
        padding: 12,
        mode: 'index',
        intersect: false,
        callbacks: {
          label: (context) => {
            let label = context.dataset.label || '';
            if (label) {
              label += ': ';
            }
            if (context.parsed.y !== null) {
              label += new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', maximumSignificantDigits: 3 }).format(context.parsed.y);
            }
            return label;
          }
        }
      }
    },
    scales: {
      x: {
        grid: { color: this.colors.gridColor, tickLength: 0 },
        ticks: { color: '#6B7280', font: { size: 11 } }
      },
      y: {
        grid: { color: this.colors.gridColor, tickLength: 0 },
        ticks: {
          color: '#6B7280',
          font: { size: 11 },
          callback: (value) => {
            if (typeof value === 'number') {
              return '$' + (value / 1000) + 'k';
            }
            return value;
          }
        },
        beginAtZero: true
      }
    }
  };

  constructor() { }

  ngOnInit() {
    console.log('📊 Cargando Dashboard con nuevas gráficas...');

    this.dataService.getAllAccounts().subscribe({
      next: (data: any) => {
        console.log('✅ Dashboard recibió datos:', data);

        if (Array.isArray(data)) {
          this.totalUsers = data.length;
          this.totalMoney = data.reduce((acc: number, curr: any) => acc + (curr.balance || 0), 0);
        }

        this.isLoading = false;
        this.cdr.detectChanges();

        // Force update when data arrives
        setTimeout(() => {
          this.charts?.forEach(chart => chart.update());
        }, 100);
      },
      error: (err: any) => {
        console.error('❌ Error en Dashboard:', err);
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }

  ngAfterViewInit() {
    // Force chart update after view initialization
    setTimeout(() => {
      console.log('🔄 Forzando actualización de gráficos...');
      this.charts?.forEach(chart => {
        chart.update();
        console.log('📈 Gráfico actualizado');
      });
    }, 500);
  }
}