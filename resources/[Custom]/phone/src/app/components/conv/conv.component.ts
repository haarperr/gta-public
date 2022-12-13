import { HttpClient } from '@angular/common/http';
import { Component, HostListener, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import {Location} from '@angular/common';
import { MessageService } from '../../services/message.service';
import { SocketService } from '../../services/socket.service';
import { MatDialog } from '@angular/material/dialog';
import { ModalComponent } from '../modal/modal.component';

@Component({
  selector: 'app-conv',
  templateUrl: './conv.component.html',
  styleUrls: ['./conv.component.scss']
})
export class ConvComponent implements OnInit {

  messages: any
  name: any = "Someone";
  phoneNumber: number = 0;
  from: number;
  total: number = 0;
  lastFocusedIndex: number = 0;
  focusedIndex: number = 0;
  modal: boolean = false;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private http: HttpClient,
    private _location: Location,
    private msgService: MessageService,
    private srv: SocketService,
    public dialog: MatDialog,

  ) {
    this.phoneNumber = Number(localStorage.getItem("phone"))
    this.from = Number(this.route.snapshot.paramMap.get('id'))
    this.getConv();
    this.srv.listen('sendMsg'+this.phoneNumber).subscribe((res:any)=>{
      if(res.data){
        this.messages.push(res.data)
        this.msgService.setSeen(this.phoneNumber, this.from).subscribe(r=> {console.log('updated all message to seen');})
        if (res.data.from==this.phoneNumber) {
          this.focusedIndex = this.messages.length+1
          this.lastFocusedIndex = this.messages.length+1
          let el = document.getElementById(String(this.focusedIndex));
          el?.scrollIntoView({ behavior: 'auto', block: "center" });
        }
      }
    })
  }

  ngOnInit(): void {
  }

  getConv() {
    this.msgService.setSeen(this.phoneNumber, this.from).subscribe(r=> {console.log('updated all message to seen');})
    this.msgService.getAllFrom(this.phoneNumber,this.from).subscribe(res => {
      this.messages = res.messages
      this.name = res.contact
      if (this.messages.length>0) {
        this.focusedIndex = this.messages.length+1
        this.lastFocusedIndex = this.messages.length+1
        setTimeout(() => {
          let el = document.getElementById(String(this.messages.length-1));
          el?.scrollIntoView();
        }, 200);
      } else {
        this.focusedIndex = -9
      }

    })
  }

  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {    
    switch (event.code) {
      case "Backspace":
        if (!this.modal) {
          this._location.back();
          // this.router.navigate(['../..'], { relativeTo: this.route });
        }
        break
      case "ArrowUp":
        if (this.messages[0] && this.focusedIndex-1!=-1) {
          if (this.focusedIndex==this.messages.length+1) {
            this.lastFocusedIndex = this.messages.length-1
            this.focusedIndex = this.messages.length-1
          } else {
            this.lastFocusedIndex = this.focusedIndex
            this.focusedIndex = this.focusedIndex-1
            this.messages[this.lastFocusedIndex].focused = false
          }
          this.messages[this.focusedIndex].focused = true
          let el = document.getElementById(String(this.focusedIndex));
          el?.scrollIntoView({ behavior: 'auto', block: "center" });
        }
        break;
      case "PageUp":
        if (this.messages[0]) {
          if (this.focusedIndex!=this.messages.length+1) {
            this.lastFocusedIndex = this.focusedIndex
            this.messages[this.lastFocusedIndex].focused = false
          }
          this.focusedIndex = 0
          this.messages[this.focusedIndex].focused = true
          let elu = document.getElementById(String(this.focusedIndex));
          elu?.scrollIntoView({ behavior: 'auto', block: "center" });
        }
        break;
      case "ArrowDown":
        if (this.messages[0]) {
          if (this.focusedIndex+1<this.messages.length) {
              this.lastFocusedIndex = this.focusedIndex        
              this.focusedIndex++
              this.messages[this.lastFocusedIndex].focused = false
              this.messages[this.focusedIndex].focused = true
              let el = document.getElementById(String(this.focusedIndex));
              el?.scrollIntoView({ behavior: 'auto', block: "center" });
          } else {
            this.lastFocusedIndex = this.messages.length
            this.messages[this.lastFocusedIndex-1].focused = false
            this.focusedIndex = this.messages.length+1
          }
        }
        break;
      case "PageDown":
        if (this.messages[0] && this.focusedIndex!=this.messages.length+1) {
          this.lastFocusedIndex = this.focusedIndex
          this.focusedIndex = this.messages.length-1
          this.messages[this.lastFocusedIndex].focused = false
          this.messages[this.focusedIndex].focused = true
          let eld = document.getElementById(String(this.focusedIndex));
          eld?.scrollIntoView({ behavior: 'auto', block: "center" });
        }
        break;
      case "Enter":
        if (this.messages[0]) {
          if (this.focusedIndex === this.messages.length+1) {
            if (this.modal===false) {
              this.modal = true
              this.openDialog({maxLength: 1000})
            }
          }          
        } else {
          if (this.modal===false) {
            this.modal = true
            this.openDialog({maxLength: 1000})
          }
        }
        break
    }
  }

  openDialog(data: any): void {
    const dialogRef = this.dialog.open(ModalComponent, {
      data: data,
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) this.sendSms(result)
      setTimeout(async() => {
        this.modal = false
        await this.http.post('http://phone/inputs', JSON.stringify({
          enable: true
        })).toPromise();
      }, 100);
    });
  }

  sendSms(text: string){
    let sms = {
      from: this.phoneNumber,
      to: this.from,
      content: text
    }
    this.msgService.sendSms(sms).subscribe(sms => {
      this.getConv()
      setTimeout(() => {
        let el = document.getElementById(String(this.messages.length-1));
        el?.scrollIntoView({ behavior: 'auto', block: "center" });        
      }, 200);
    },
    (err) => {
      console.log(err);
    });
  }


}
