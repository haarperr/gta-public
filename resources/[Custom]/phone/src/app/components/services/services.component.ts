import { Component, HostListener, OnInit } from '@angular/core';
import {Location} from '@angular/common';
import { MatDialog } from '@angular/material/dialog';
import { ModalComponent } from '../modal/modal.component';
import { HttpClient } from '@angular/common/http';
import { MessageService } from 'src/app/services/message.service';

@Component({
  selector: 'app-services',
  templateUrl: './services.component.html',
  styleUrls: ['./services.component.scss']
})
export class ServicesComponent implements OnInit {

  services: any[] = []
  modal: boolean = false
  menuAction: boolean = false
  action: number = 0
  focusedIndex: number = 0
  lastFocusedIndex: number = 0
  phoneNumber: number

  constructor(
    public dialog: MatDialog,
    private http: HttpClient,
    private _location: Location,
    private msgService: MessageService,
  ) {
    this.services = [
      {
        name: "LSPD",
        icon: "local_police",
        phone: 1000,
        focused: true
      }, 
      {
        name: "EMS",
        icon: "emergency",
        phone: 1001,
        focused: false
      }, 
      {
        name: "LS Custom",
        icon: "construction",
        phone: 1002,
        focused: false
      }, 
      {
        name: "LS Taxi",
        icon: "local_taxi",
        phone: 1003,
        focused: false
      },
    ]
    this.phoneNumber = Number(localStorage.getItem("phone"))
  }

  ngOnInit(): void {
  }


  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Backspace":
        if (this.menuAction && !this.modal) {
          this.menuAction = false
        } else if (!this.modal) {
          this._location.back();
        }
        break
      case "ArrowUp":
        if (!this.menuAction) {
          if (this.services) {
            if (this.services[0] && this.focusedIndex!=-1) {
              if (this.focusedIndex!=0) {
                this.lastFocusedIndex = this.focusedIndex        
                this.focusedIndex = this.focusedIndex-1
                this.services[this.lastFocusedIndex].focused = false
                this.services[this.focusedIndex].focused = true
                let el = document.getElementById(String(this.focusedIndex));
                el?.scrollIntoView({ behavior: 'auto', block: "center" });
              }
            }
          }
        } else {
          if (this.action!=0) {
            this.action = this.action - 1
          }
        }
        break;
      case "ArrowDown":
        if (!this.menuAction) {
          if (this.services) {
            if (this.services[0] && this.focusedIndex+1!=this.services.length) {
              this.lastFocusedIndex = this.focusedIndex        
              this.focusedIndex++
              this.services[this.lastFocusedIndex].focused = false
              this.services[this.focusedIndex].focused = true
              let el = document.getElementById(String(this.focusedIndex));
              el?.scrollIntoView({ behavior: 'auto', block: "center" });
            }
          }
        } else {
          if (this.action!=2) {
            this.action ++
          }
        }
        break;
      case "Enter":
        if (this.focusedIndex>-1 && !this.menuAction) {
          this.menuAction = true
        } else if (this.menuAction && !this.modal) {
          this.openDialog({maxLength: 500})
          
        }
        break
    }
  }

  openDialog(data: any): void {
    this.modal = true
    const dialogRef = this.dialog.open(ModalComponent, {
      data: data,
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        let from
        if (this.action != 2) { // MSG PAS ANONYME
          from = this.phoneNumber
        } else { // MSG ANONYME
          from = 9999
        }

        let sms: any = {}
        sms.from = from
        sms.to = this.services[this.focusedIndex].phone
        sms.content = result
        sms.unseen = 1

        if (this.action === 1) { // MSG AVEC POS
          // sms.pos 
        }

        this.msgService.sendSms(sms).subscribe(res => {
          if(res){
            // await this.http.post('http://phone/notifynui', "Message envoyé").toPromise();
          }
        })
        
      }
      setTimeout(async() => {
        this.modal = false
        
        // await this.http.post('http://phone/inputs', JSON.stringify({
        //   enable: true
        // })).toPromise();
      }, 200);
    });
  }

}
