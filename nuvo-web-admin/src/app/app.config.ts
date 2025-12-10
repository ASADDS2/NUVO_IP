import { ApplicationConfig, provideBrowserGlobalErrorListeners, provideZonelessChangeDetection, importProvidersFrom } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';
import { provideCharts, withDefaultRegisterables } from 'ng2-charts';
import { LucideAngularModule, CheckCircle, BarChart2, Users, Wallet, TrendingUp, PieChart, Shield, Mail, Phone, MapPin, ArrowRight } from 'lucide-angular';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideZonelessChangeDetection(),
    provideRouter(routes),
    provideHttpClient(),
    provideCharts(withDefaultRegisterables()),
    importProvidersFrom(LucideAngularModule.pick({ CheckCircle, BarChart2, Users, Wallet, TrendingUp, PieChart, Shield, Mail, Phone, MapPin, ArrowRight }))
  ]
};
