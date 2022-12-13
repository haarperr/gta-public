import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MenuComponent } from './components/menu/menu.component';
import { HomeComponent } from './components/home/home.component';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { CommandesComponent } from './components/commandes/commandes.component';
import { MatIconModule } from '@angular/material/icon';
import { CommandeComponent } from './components/commande/commande.component';
import { CatalogueComponent } from './components/catalogue/catalogue.component';
import { MatInputModule } from '@angular/material/input'; 
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatButtonModule } from '@angular/material/button';
import { MatBadgeModule } from '@angular/material/badge';
import { BasketComponent } from './components/basket/basket.component';
import { MatStepperModule } from '@angular/material/stepper'; 
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner'; 
import { MatExpansionModule } from '@angular/material/expansion'; 
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { RecelComponent } from './components/recel/recel.component';
import { VolvoitureComponent } from './components/volvoiture/volvoiture.component';


@NgModule({
  declarations: [
    AppComponent,
    MenuComponent,
    HomeComponent,
    CommandesComponent,
    CommandeComponent,
    CatalogueComponent,
    BasketComponent,
    RecelComponent,
    VolvoitureComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    MatIconModule,
    MatInputModule,
    MatFormFieldModule,
    MatButtonModule,
    MatBadgeModule,
    MatStepperModule,
    MatProgressSpinnerModule,
    MatExpansionModule,
    MatSnackBarModule,
  ],
  providers: [
    
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
