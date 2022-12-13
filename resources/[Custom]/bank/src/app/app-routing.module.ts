import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AtmComponent } from './components/atm/atm.component';
import { HomeComponent } from './components/home/home.component';

const routes: Routes = [
  // { path: '', redirectTo: '/atm', pathMatch: 'full' },
  { path: 'home',  component: HomeComponent},
  { path: 'atm',  component: AtmComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
