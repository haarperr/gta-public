import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatListModule } from '@angular/material/list';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatIconModule } from '@angular/material/icon';
import { A11yModule } from '@angular/cdk/a11y';
import { ScrollingModule } from '@angular/cdk/scrolling';
import { HttpClientModule } from '@angular/common/http';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import {MatDialogModule} from '@angular/material/dialog'; 
import { MatFormFieldModule } from '@angular/material/form-field'; 
import { MatInputModule } from '@angular/material/input'; 
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {MatSliderModule} from '@angular/material/slider';


import { HomeComponent } from './components/home/home.component';
import { MsgComponent } from './components/msg/msg.component'; 
import { TelComponent } from './components/tel/tel.component';
import { ContactComponent, ContactFormComponent } from './components/contact/contact.component';
import { ConvComponent } from './components/conv/conv.component';
import { NotifComponent } from './components/notif/notif.component';
import { ModalComponent } from './components/modal/modal.component';
import { BankComponent } from './components/bank/bank.component';
import { PhonecallComponent } from './components/phonecall/phonecall.component';
import { SettingsComponent } from './components/settings/settings.component';
import { MessagerieproComponent } from './components/messageriepro/messageriepro.component';
import { ServicesComponent } from './components/services/services.component';





@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    MsgComponent,
    TelComponent,
    ContactComponent,
    ContactFormComponent,
    ConvComponent,
    NotifComponent,
    ModalComponent,
    BankComponent,
    PhonecallComponent,
    SettingsComponent,
    MessagerieproComponent,
    ServicesComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    A11yModule,
    MatListModule,
    MatGridListModule,
    MatIconModule,
    HttpClientModule,
    ScrollingModule,
    MatProgressSpinnerModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    FormsModule,
    ReactiveFormsModule,
    MatSliderModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
