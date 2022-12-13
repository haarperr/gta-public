import { Component, HostListener, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import {Location} from '@angular/common';
import { ContactService } from 'src/app/services/contact.service';
import { AppelService } from 'src/app/services/appel.service';
import { CharacterService } from 'src/app/services/character.service';
import { SocketService } from 'src/app/services/socket.service';
import { HttpClient } from '@angular/common/http';
import { SoundService } from 'src/app/services/sound.service';


@Component({
  selector: 'app-phonecall',
  templateUrl: './phonecall.component.html',
  styleUrls: ['./phonecall.component.scss']
})
export class PhonecallComponent implements OnInit {

  phoneNumber: number;
  to: number;
  cid: number;
  contact: string = "";
  temps?: number;
  focused: number = 1;
  receive: boolean = false;
  counter?: string;

  constructor(
    private http: HttpClient,
    private router: Router,
    private route: ActivatedRoute,
    private _location: Location,
    private contactService: ContactService,
    private appelService: AppelService,
    private srv: SocketService,
    private cService: CharacterService,
    private soundSystem: SoundService
    ) { 
    this.cid = Number(localStorage.getItem("cid"))
    this.phoneNumber = Number(localStorage.getItem("phone"))
    this.to = Number(this.route.snapshot.paramMap.get('phone'))
    this.contactService.getOneFromPhone(this.cid, this.to).subscribe(c => {
      if (c) {this.contact = c.name} else {this.contact='Inconnu'}
    });
    if(this.router.url.startsWith('/appel/create/')){
      if(!this.appelService.getInCall().active) {
        this.soundSystem.playSound('calling')
        this.focused = 1
        this.receive = false
        this.appelService.setInCall(true, this.to)
        let call = {
          from: this.phoneNumber,
          to: this.to,
          unseen: 1
        }
        this.appelService.createCall(call).subscribe(c=>{if (!c) console.log('Erreur, impossible de créer l\'appel en base de données.')})
      }
    } else {
      if(!this.appelService.getInCall().active) {
        this.appelService.setInCall(true, this.to)
        this.focused = 0
        this.receive = true
      } else if(this.appelService.getInCall().active && !this.appelService.getInCall().channelOpen) {
        this.appelService.setInCall(true, this.to)
        this.focused = 0
        this.receive = true
      }
    }
    this.srv.stop('openChannel'+this.phoneNumber)
    this.srv.listen('openChannel'+this.phoneNumber).subscribe(async (res:any)=>{
      if(res.data){
        if (res.data.from!=this.phoneNumber) {
          this.soundSystem.stopSound()
          if (res.data.active=="true") {
            this.startCounter()
            this.toggleChannel(res.data.from, true)
          } else {
            this.toggleChannel(res.data.from, false)
          }
          
        }
      }
    })
    this.srv.stop('closeChannel'+this.phoneNumber)
    this.srv.listen('closeChannel'+this.phoneNumber).subscribe(async (res:any)=>{
      if(res.data){
        if (res.data.from!=this.phoneNumber) {
        }
      }
    })
  }

  ngOnInit(): void {
  }

  startCounter(){
    let count = 0
    setInterval(() => {
      let hours: any = Math.floor(count / 3600)
      hours < 10 && hours > 0
       ? hours = '0'+hours : null;
      let minutes: any = Math.floor((count % 3600)/60);
      minutes < 10 ? minutes = '0'+minutes : null;
      let seconds: any = Math.floor(count % 60);
      seconds < 10 ? seconds = '0'+seconds : null;
      count++
      hours ? this.counter = hours + ":" + minutes + ":" + seconds : this.counter = minutes + ":" + seconds ;
    }, 1000);
  }
  


  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Enter":
        this.soundSystem.stopSound()
        if (this.focused===0) { // DECROCHE
          this.receive = false
          this.focused = 1
          this.appelService.setSeenLast(this.phoneNumber, this.to).subscribe(c=>{if(c)console.log("set seen last");})
          this.startCounter()
          this.appelService.toggleChannel(this.phoneNumber, this.to, true).subscribe(c=>{if(c)console.log("request to other client to open channel");});
          this.toggleChannel(this.to, true)
        } else { // RACROCHE
          this.appelService.setInCall(false, 0);
          this.appelService.setInCallBackend(this.phoneNumber, this.to, false).subscribe(c=>{if(c)console.log("phonecall ended");})
          this.appelService.toggleChannel(this.phoneNumber, this.to, false).subscribe(c=>{if(c)console.log("request to other client to close channel");});
          this.toggleChannel(this.to, false)
          this._location.back();
        }
        break
      case "Backspace": // RACROCHE
        this.soundSystem.stopSound()
        this.appelService.setInCall(false, 0)
        this.appelService.setInCallBackend(this.phoneNumber, this.to, false).subscribe(c=>{if(c)console.log("phonecall ended");})
        this.appelService.toggleChannel(this.phoneNumber, this.to, false).subscribe(c=>{if(c)console.log("request to other client to close channel");});
        this.toggleChannel(this.to, false)
        this._location.back();
        break
    }
  }
  async toggleChannel(to: number, bool: boolean) {
    let id
    this.phoneNumber > to ? id = to+''+this.phoneNumber : id = this.phoneNumber+''+ to;
    bool ? console.log("Rejoint le channel "+id) : console.log("Quitte le channel "+id);
    
    await this.http.post('http://phone/openchannel', JSON.stringify({
      id: id,
      enable: bool
    })).toPromise();
  }
}
