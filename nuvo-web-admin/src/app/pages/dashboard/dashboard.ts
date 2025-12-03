import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';
import { LucideAngularModule } from 'lucide-angular';
import { BaseChartDirective } from 'ng2-charts';
import { ChartConfiguration, ChartData } from 'chart.js';

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

  totalUsers = 0;
  totalMoney = 0;
  isLoading = true;

  // Line Chart Configuration (Gráfico de Área)
  public lineChartData: ChartConfiguration<'line'>['data'] = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
    datasets: [
      {
        data: [3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 12, 12],
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
          stepSize: 3
        },
        beginAtZero: true,
        max: 12
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
        data: [3, 0.75, 2.25, 0.5],
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
        },
        max: 4
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
    console.log('📊 Cargando Dashboard...');

    this.dataService.getAllAccounts().subscribe({
      next: (data: any) => {
        console.log('✅ Dashboard recibió datos:', data);

        if (Array.isArray(data)) {
          this.totalUsers = data.length;
          this.totalMoney = data.reduce((acc: number, curr: any) => acc + (curr.balance || 0), 0);
        }

        this.isLoading = false;
      },
      error: (err: any) => {
        console.error('❌ Error en Dashboard:', err);
        this.isLoading = false;
      }
    });
  }
}