import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { BankComponent } from './components/bank/bank.component';
import { ContactComponent, ContactFormComponent } from './components/contact/contact.component';
import { ConvComponent } from './components/conv/conv.component';
import { HomeComponent } from './components/home/home.component';
import { MsgComponent } from './components/msg/msg.component';
import { PhonecallComponent } from './components/phonecall/phonecall.component';
import { TelComponent } from './components/tel/tel.component';
import { SettingsComponent } from './components/settings/settings.component';
import { MessagerieproComponent } from './components/messageriepro/messageriepro.component';
import { ServicesComponent } from './components/services/services.component';

const routes: Routes = [
  { path: 'home', component: HomeComponent },
  { path: 'tel', component: TelComponent},
  { path: 'appel/create/:phone', component: PhonecallComponent},
  { path: 'appel/receive/:phone', component: PhonecallComponent},
  { path: 'message', component: MsgComponent},
  { path: 'message/from/:id', component: ConvComponent},
  { path: 'contact', component: ContactComponent},
  { path: 'contact/add', component: ContactFormComponent},
  { path: 'contact/edit/:id', component: ContactFormComponent},
  { path: 'bank', component: BankComponent},
  { path: 'services', component: ServicesComponent},
  { path: 'messagerie-pro/:id', component: MessagerieproComponent},
  { path: 'settings', component: SettingsComponent},
  { path: '',   redirectTo: '/home', pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
