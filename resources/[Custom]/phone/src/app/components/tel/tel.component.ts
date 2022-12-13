import { HttpClient } from '@angular/common/http';
import { Component, HostListener, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import {Location} from '@angular/common';
import { AppelService } from 'src/app/services/appel.service';
import { ModalComponent } from '../modal/modal.component';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-tel',
  templateUrl: './tel.component.html',
  styleUrls: ['./tel.component.scss']
})
export class TelComponent implements OnInit {
  phoneNumber: number;
  appels: any;
  focusedIndex: number = 0;
  lastFocusedIndex: number = 0;
  loading: boolean = false;

  actions : any[] = []
  menuAction: boolean = false
  modal: boolean = false;
  
  constructor(
    private route: ActivatedRoute,
    private router: Router,
    public dialog: MatDialog,
    private _location: Location,
    private appelService: AppelService,
    private http: HttpClient
  ) {
    this.phoneNumber = Number(localStorage.getItem("phone"))
    this.loading = true
    this.appelService.getAll(this.phoneNumber).subscribe(a => {
      if (a[0]) {
        this.appelService.setSeen(this.phoneNumber).subscribe(r=> {console.log('updated all call to seen');})
        for (let o = 0; o < a.length; o++) {
          a[o].focused = false;          
        }
        a[0].focused = true
        this.appels = a
      } else {
        this.focusedIndex = -1
      }
      this.loading = false
    })
  }

  ngOnInit(): void {
  }


  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Backspace":
        if (this.menuAction) {
          this.menuAction = false 
        } else {
          this._location.back();
        }
        break
      case "ArrowUp":
        
        if (this.menuAction) {
          if(this.actions[0].focused) {
            this.actions[0].focused = false 
            this.actions[1].focused = true 
          } else {
            this.actions[0].focused = true
            this.actions[1].focused = false
          }
        } else {
          if(this.focusedIndex-1!=-2){
            if (this.appels[0] && this.focusedIndex==0) {
              this.appels[0].focused = false
              this.focusedIndex = -1
            } else {
              this.lastFocusedIndex = this.focusedIndex        
              this.focusedIndex = this.focusedIndex-1
              this.appels[this.lastFocusedIndex].focused = false
              this.appels[this.focusedIndex].focused = true
              let el = document.getElementById(String(this.focusedIndex));
              el?.scrollIntoView({ behavior: 'auto', block: "center" });
            }
          }
        }
        break;
      case "ArrowDown":
        
        if (this.menuAction) {
          if(this.actions[0].focused) {
            this.actions[0].focused = false 
            this.actions[1].focused = true 
          } else {
            this.actions[0].focused = true
            this.actions[1].focused = false
          }
        } else if(!this.menuAction && this.appels) {
          if (this.appels[0] && this.focusedIndex+1!=this.appels.length) {
            if (this.focusedIndex==-1) {
              this.focusedIndex=0
              this.lastFocusedIndex=0
              this.appels[this.focusedIndex].focused = true
            } else {
              this.lastFocusedIndex = this.focusedIndex        
              this.focusedIndex++
              this.appels[this.lastFocusedIndex].focused = false
              this.appels[this.focusedIndex].focused = true
              let el = document.getElementById(String(this.focusedIndex));
              el?.scrollIntoView({ behavior: 'auto', block: "center" });
            }
          }
        }
        break;
      case "Enter":
        if (this.focusedIndex>=0) {
          let call
          this.appels[this.focusedIndex].from.phone === this.phoneNumber ? call = this.appels[this.focusedIndex].to.phone : call = this.appels[this.focusedIndex].from.phone
          this.router.navigate(['/appel/create/'+call], { relativeTo: this.route });
        } else if(this.focusedIndex===-1 && !this.menuAction){
          this.menuAction = true
          this.actions = [{focused: true, text: "Depuis contact"}, {focused: false, text: "Depuis numéro"}]
        } else if(this.menuAction){
          if (this.actions[0].focused) {
            this.router.navigate(['/contact'], { relativeTo: this.route });
          } else if (this.actions[1].focused && !this.modal) {
            this.modal = true
            this.openDialog({maxLength: 4})
          }
        }
        break 
    }
  }


  openDialog(data: any): void {
    const dialogRef = this.dialog.open(ModalComponent, {
      data: data,
    });

    dialogRef.afterClosed().subscribe(async result => {
      if (result) {
        if (!isNaN(parseFloat(result)) && !isNaN(result - 0) && result.length == 4 && result > 999) {
          setTimeout(async() => {
            this.modal = false
            this.router.navigate(['/appel/create/'+result], { relativeTo: this.route });
            
            await this.http.post('http://phone/inputs', JSON.stringify({
              enable: true
            })).toPromise();
          }, 200);
        } else {
          await this.http.post('http://phone/inputs', JSON.stringify({
            enable: true
          })).toPromise();
          this.modal = false
        }
      }
    });
  }




}
