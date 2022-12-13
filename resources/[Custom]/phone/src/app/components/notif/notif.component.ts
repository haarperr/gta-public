import { trigger, state, style, transition, animate } from '@angular/animations';
import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { AppelService } from 'src/app/services/appel.service';
import { SocketService } from '../../services/socket.service';

@Component({
  selector: 'app-notif',
  templateUrl: './notif.component.html',
  styleUrls: ['./notif.component.scss'],
  animations: [
    trigger('isVisibleChanged', [
      state('true' , style({ opacity: 1, transform: 'scale(1.0)' })),
      state('false', style({ opacity: 0, transform: 'scale(0.0)'  })),
      transition('1 => 0', animate('100ms')),
      transition('0 => 1', animate('40ms'))
    ])
  ],
})
export class NotifComponent implements OnInit {

  phoneNumber: number;
  organisationId?: number;
  isVisible : boolean = false;

  title? : string;
  message? : string;
  notifTimeout: any;
  icon?: string;

  constructor(
    private srv: SocketService,
    private appelService: AppelService,
    private http: HttpClient
  ) {
    this.phoneNumber = Number(localStorage.getItem("phone"))
    this.organisationId = Number(localStorage.getItem("organisationId"))
    // this.srv.listen('sendMsg'+this.phoneNumber).subscribe(async (res:any)=>{
    //   if(res.data){
    //     if (res.data.from!=this.phoneNumber) {
    //       this.displayNotif('sms', 'SMS - '+res.data.from.contact, res.data.content)
    //     }
    //   }
    // })
    // this.srv.listen('getCall'+this.phoneNumber).subscribe(async (res:any)=>{
    //   if(res.data){
    //     if (res.data.from!=this.phoneNumber) {
    //       if (this.appelService.getInCall().active && this.appelService.getInCall().with != res.data.from) {
    //         this.displayNotif('call', '555-'+res.data.from, 'APPEL MANQUÉ')         
    //       }
    //     }
    //   }
    // })
    // if (this.organisationId) {
    //   this.srv.listen('sendMsgOrga'+this.organisationId).subscribe(async (res:any)=>{
    //     if(res.data){
    //       this.displayNotif('domain', 'Message entreprise', 'Nouveau message')         
    //     }
    //   })
    // }
  }

  displayNotif(icon: string, title: string, content: string){
    if (this.isVisible) {
      this.isVisible = false
      clearTimeout(this.notifTimeout)
      setTimeout(() => {
        this.title = title
        this.icon = icon
        this.message = content
        this.isVisible = true
        this.notifTimeout = setTimeout(() => {
          this.isVisible = false
        }, 5000);
      }, 30);
    } else {
      this.title = title
      this.icon = icon
      this.message = content
      this.isVisible = true
      this.notifTimeout = setTimeout(() => {
        this.isVisible = false
      }, 5000);
      
    }
  }

  ngOnInit(): void {
  }

}
