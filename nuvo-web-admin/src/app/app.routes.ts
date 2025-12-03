import { Routes } from '@angular/router';
import { LoginComponent } from './pages/login/login';
import { LandingComponent } from './pages/landing/landing';
import { LayoutComponent } from './components/layout/layout';
import { DashboardComponent } from './pages/dashboard/dashboard';
import { AccountsComponent } from './pages/accounts/accounts';
import { LoansComponent } from './pages/loans/loans';
import { PoolComponent } from './pages/pool/pool';
import { PoolManagementComponent } from './pages/pool-management/pool-management';

export const routes: Routes = [
    // Página de login
    { path: 'login', component: LoginComponent },

    // Rutas protegidas (dentro del Layout)
    {
        path: '',
        component: LayoutComponent,
        children: [
            { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
            { path: 'dashboard', component: DashboardComponent },
            { path: 'accounts', component: AccountsComponent },
            { path: 'loans', component: LoansComponent },
            { path: 'pool/invest', component: PoolComponent },
            { path: 'pool/manage', component: PoolManagementComponent },
            { path: 'pool', redirectTo: 'pool/invest', pathMatch: 'full' }
        ]
    },

    // Landing page (sin layout)
    { path: 'landing', component: LandingComponent },

    // Cualquier otra ruta redirige al dashboard
    { path: '**', redirectTo: 'dashboard' }
];