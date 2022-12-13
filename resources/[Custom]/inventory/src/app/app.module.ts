import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { AppComponent } from './app.component';
import { ModalComponent } from './modal/modal.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import {DragDropModule} from '@angular/cdk/drag-drop';
import {MatMenuModule} from '@angular/material/menu';
import {MatDialogModule} from '@angular/material/dialog'; 
import { MatFormFieldModule } from '@angular/material/form-field'; 
import { MatInputModule } from '@angular/material/input'; 
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { ObjectSortPipe, SortPipe } from 'src/pipes/orderby.pipe';
import { EnvServiceProvider } from 'src/services/env.service.provider';
import {MatSnackBarModule} from '@angular/material/snack-bar'; 
@NgModule({
  declarations: [
    AppComponent,
    ModalComponent,
    ObjectSortPipe,
    SortPipe,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    DragDropModule,
    HttpClientModule,
    FormsModule,
    MatMenuModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    ReactiveFormsModule,
    MatSnackBarModule,
  ],
  providers: [
    EnvServiceProvider,
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
