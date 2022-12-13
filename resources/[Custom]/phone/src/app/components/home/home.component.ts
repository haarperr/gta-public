import { Component, HostListener, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { trigger, state, style, animate, transition, } from '@angular/animations';
import { PreviousRouteService } from 'src/services/previous-route.service';
import { MessageService } from '../../services/message.service';
import { AppelService } from 'src/app/services/appel.service';



@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
  animations: [
    // animation triggers go here
  ]
})
export class HomeComponent implements OnInit {
  lastFocusedIndex: number = 0;
  focusedIndex: number = 0;
  lastRoute: string;
  applis: any[] = [
    {
      name: 'Téléphone',
      icon: 'call',
      path: '/tel',
      focused: true
    },  
    {
      name: 'Message',
      icon: 'sms',
      path: '/message',
      focused: false
    }, 
    {
      name: 'Contact',
      icon: 'contacts',
      path: '/contact',
      focused: false
    }, 
    // {
    //   name: 'Camera',
    //   icon: 'photo_camera',
    //   path: '/camera',
    //   focused: false
    // }, 
    // {
    //   name: 'Photo',
    //   icon: 'image',
    //   path: '/photo',
    //   focused: false
    // }, 
    {
      name: 'Banque',
      icon: 'account_balance',
      path: '/bank',
      focused: false
    },
    {
      name: 'Services',
      icon: 'location_city',
      path: '/services',
      focused: false
    }
  ];
  today: number = Date.now();
  phoneNumber?: number;
  organisationId?: number;

  constructor(
    private route: ActivatedRoute,
    private previousRouteService: PreviousRouteService,
    private router: Router,
    private appelService: AppelService,
    private mService: MessageService,
  ) {
    setInterval(() => {this.today = Date.now()}, 1000);
    this.organisationId = Number(localStorage.getItem("organisationId"))
    this.phoneNumber = Number(localStorage.getItem("phone"))
    if (this.organisationId) {
      this.applis.push({
        name: 'Entreprise',
        icon: 'domain',
        path: '/messagerie-pro/'+this.organisationId,
        focused: false
      })
      this.mService.getUnseenEntreprise(this.organisationId).subscribe(count => {
        this.applis[5].notif = Number(count)
      })
    }
    this.applis.push({
      name: 'Paramètres',
      icon: 'settings',
      path: '/settings',
      focused: false
    })
    this.lastRoute = previousRouteService.getPreviousUrl()
    if (this.lastRoute!='/home') {
      for (let i = 0; i < this.applis.length; i++) {
        const ele = this.applis[i];
        if (ele.path===this.lastRoute) {
          ele.focused = true
          this.focusedIndex = i
          this.lastFocusedIndex = i
        } else {
          ele.focused = false
        }
      }
    } else {
      this.applis[0].focused = true
    }
    this.mService.getUnseen(this.phoneNumber).subscribe(count => {
      this.applis[1].notif = Number(count)
    })
    this.appelService.getSeen(this.phoneNumber).subscribe(count => {
      this.applis[0].notif = Number(count)
    })
  }

  ngOnInit(): void {
      
  }

  
  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "ArrowUp":
        this.changeFocus(-3)
        break;
      case "ArrowDown":
        this.changeFocus(3)
        break;
      case "ArrowRight":
        this.changeFocus(1)
        break;
      case "ArrowLeft":
        this.changeFocus(-1)
        break;
      case "Enter":
        this.changeRoute()
        break
    }
  }

  changeRoute(){
    for (let i = 0; i < this.applis.length; i++) {
      const element = this.applis[i];
      if (element.focused===true) {
        this.router.navigate([element.path], { relativeTo: this.route });
      }
    }
  }

  changeFocus(range: number){
    switch (range) {
      case 1:
        this.lastFocusedIndex = this.focusedIndex        
        this.focusedIndex++
        if (this.applis[this.focusedIndex]===undefined) {    
          this.focusedIndex = 0
        }
        break;
      case -1:
        this.lastFocusedIndex = this.focusedIndex        
        this.focusedIndex = this.focusedIndex-1
        if (this.applis[this.focusedIndex]===undefined) {       
          this.focusedIndex = this.applis.length-1
        }
        break;
      case 3:
        if (this.applis[this.focusedIndex+3]!=undefined) {
          this.lastFocusedIndex = this.focusedIndex        
          this.focusedIndex = this.focusedIndex+3
        }
        break;
      case -3:
        if (this.applis[this.focusedIndex-3]!=undefined) {
          this.lastFocusedIndex = this.focusedIndex         
          this.focusedIndex = this.focusedIndex-3
        }
        break;
    }
    this.applis[this.lastFocusedIndex].focused = false
    this.applis[this.focusedIndex].focused = true
  }
 
}
