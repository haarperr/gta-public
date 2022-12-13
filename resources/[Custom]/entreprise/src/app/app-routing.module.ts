import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CatalogueComponent } from './components/catalogue/catalogue.component';
import { BasketComponent } from './components/basket/basket.component';
import { CommandeComponent } from './components/commande/commande.component';
import { CommandesComponent } from './components/commandes/commandes.component';
import { HomeComponent } from './components/home/home.component';
import { RecelComponent } from './components/recel/recel.component';
import { VolvoitureComponent } from './components/volvoiture/volvoiture.component';

const routes: Routes = [
  { path: '', redirectTo: '/home', pathMatch: 'full' },
  { path: 'home',  component: HomeComponent},
  { path: 'catalogue',  component: CatalogueComponent},
  { path: 'panier',  component: BasketComponent},
  { path: 'commandes/create',  component: CommandeComponent},
  { path: 'commandes/:id',  component: CommandeComponent},
  { path: 'commandes',  component: CommandesComponent},
  { path: 'recel',  component: RecelComponent},
  { path: 'voiture',  component: VolvoitureComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
