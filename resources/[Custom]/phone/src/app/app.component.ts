import { Component, HostListener } from '@angular/core';
import { ActivatedRoute, Router, RouterOutlet } from '@angular/router';
import {Location} from '@angular/common';
import { slideInAnimation } from './animations';
import { HttpClient } from '@angular/common/http';
import { state, style, trigger } from '@angular/animations';
import { PreviousRouteService } from '../services/previous-route.service';
import { SocketService } from './services/socket.service';
import { AppelService } from './services/appel.service';
import { CharacterService } from './services/character.service';
import { SoundService } from './services/sound.service';
import { MessageService } from './services/message.service';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  animations: [
    slideInAnimation,
    // animation triggers go here
    
  ]
})
export class AppComponent {
  title = 'phone';
  today: number = Date.now();
  showApp: boolean = false;
  phoneNumber: number;
  organisationId?: number;
  inCall: boolean = false;
  disable: boolean = true;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private http: HttpClient,
    private srv: SocketService,
    private appelService: AppelService,
    private _location: Location,
    private cService: CharacterService,
    private soundSystem: SoundService,
    private msgService: MessageService,
  ){
    setInterval(() => {this.today = Date.now()}, 1000);
    // localStorage.setItem("phone", "8021")
    // localStorage.setItem("cid", "1")
    // localStorage.setItem("organisationId", "1")
    this.phoneNumber = Number(localStorage.getItem("phone"))
    this.organisationId = Number(localStorage.getItem("organisationId"))
    // this.addOrgaListener()
    this.disable = Boolean(localStorage.getItem("disable"))
  }

  async ngOnInit(){    
    this.srv.listen('sendMsg'+this.phoneNumber).subscribe(async (res:any)=>{
      if(res.data && !this.disable){
        if (res.data.from!=this.phoneNumber) {
          this.soundSystem.playSound('sms')
          await this.http.post('http://phone/notify', JSON.stringify({
            message: "Nouveau message de 555-"+res.data.from.contact
          })).toPromise();
        }
      }
    })
    this.srv.listen('getCall'+this.phoneNumber).subscribe(async (res:any)=>{
      if(res.data && !this.disable){
        if (res.data.from!=this.phoneNumber) {
          if (!this.appelService.getInCall().active) {
            this.soundSystem.playSound('appel')
            this.router.navigate(['/appel/receive/'+res.data.from], { relativeTo: this.route });            
          }
        }
      }
    })
    this.srv.listen('setCall'+this.phoneNumber).subscribe(async (res:any)=>{
      if(res.data && !this.disable){
        if (res.data.from!=this.phoneNumber) {
          if (this.appelService.getInCall().active && this.appelService.getInCall().with == res.data.from) {
            this.soundSystem.stopSound()
            this.appelService.setInCall(false, res.data.from)
            this._location.back();       
          }
        }
      }
    })
  }

  addOrgaListener(id: number){
    this.srv.stop('sendMsgOrga'+this.organisationId)
    this.srv.stop('sendMsgOrga'+id)
    this.organisationId = id
    localStorage.setItem("organisationId", String(id))
    this.srv.listen('sendMsgOrga'+this.organisationId).subscribe(async (res:any)=>{
      if(res.data && !this.disable){
        this.soundSystem.playSound('sms')
        await this.http.post('http://phone/notify', JSON.stringify({
          message: "Nouveau message entreprise"
        })).toPromise();
      }
    })
  }

  prepareRoute(outlet: RouterOutlet) {
    return outlet && outlet.activatedRouteData && outlet.activatedRouteData['animation'];
  }

  @HostListener('window:message', ['$event'])
  onMessage(event: MessageEvent) {
    if (event.data.type === "setcid") {
      localStorage.setItem("phone", String(event.data.phone))
      localStorage.setItem("cid", String(event.data.cid))
      localStorage.setItem("organisationId", String(event.data.organisationId))
      if(event.data.organisationId){
        this.addOrgaListener(event.data.organisationId)
      }

    } else if (event.data.type === "enableui") {
      this.showApp = event.data.enable
    } else if (event.data.type === "sendSos") {
      let sms = {
        from: 9999,
        to: 1000,
        x: event.data.coords.x,
        y: event.data.coords.y,
        z: event.data.coords.z,
        content: "Une balise a été activée ici !"
      }
      this.msgService.sendSms(sms).subscribe(sms => {},
      (err) => {
        console.log(err);
      });
    } else if (event.data.type === "disable") {
      this.disable = event.data.disable
      localStorage.setItem("disable", event.data.disable)
    } else if (event.data.type === "sendPoliceMsg") {
      let sms = {
        from: 9999,
        to: 1000,
        x: event.data.coords.x,
        y: event.data.coords.y,
        z: event.data.coords.z,
        content: event.data.message
      }
      this.msgService.sendSms(sms).subscribe(sms => {},
      (err) => {
        console.log(err);
      });
    }
  }
  
  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    if(event.code=='Backspace'){
      if(this.router.url==="/home") {
        this.showApp = false
        await this.http.post('http://phone/close', JSON.stringify({
            enable: this.showApp
        })).toPromise();
      }
    }
  }
}
