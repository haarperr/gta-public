import { trigger, state, style, transition, animate } from '@angular/animations';
import { Component, HostListener, Input, OnInit } from '@angular/core';
import { faPowerOff } from '@fortawesome/free-solid-svg-icons';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { CharacterService } from 'src/app/services/character.service';

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss'],
  animations: [
    trigger('isVisibleChanged', [
      state('true' , style({ opacity: 1, transform: 'scale(1.0)' })),
      state('false', style({ opacity: 0, transform: 'scale(0.0)'  })),
      transition('1 => 0', animate('100ms')),
      transition('0 => 1', animate('300ms'))
    ])
  ],
})
export class MainComponent implements OnInit {

  isVisible : boolean = false;
  faPowerOff = faPowerOff
  
  constructor(
    private http: HttpClient,
    private router: Router,
    private cService: CharacterService
  ) { }

  ngOnInit(): void {
    // localStorage.setItem("cid", "1")
  }

  
  @HostListener('window:message', ['$event'])
  onMessage(event: MessageEvent) {
    if(event.data.action ==="setVisible"){
      this.isVisible = event.data.data
      if (this.isVisible) {
        localStorage.setItem("cid", String(event.data.cid))
        this.cService.getCharacter(event.data.cid).subscribe((c:any)=>{
          this.cService.setCash(c.cash)
          this.cService.setBank(c.bank)
          this.router.navigate(['/atm']);
        });
      }
    } else if(event.data.action ==="refresh") {
      localStorage.setItem("cid", String(event.data.cid))
      this.cService.getCharacter(event.data.cid).subscribe((c:any)=>{
        this.cService.setCash(c.cash)
        this.cService.setBank(c.bank)
      });
    }
  }

  @HostListener('window:keydown', ['$event'])
  keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Escape":
        this.isVisible = false;
        this.http.post('http://bank/close', {}).subscribe();;
      break
    }
  }

  @HostListener('document:click', ['$event'])
  clickout(event: any) {
    if(event.target.tagName==="HTML"){
      this.close()
    }
  }


  close(){
    this.isVisible = false
    this.http.post('http://bank/close', JSON.stringify({
        enable: this.isVisible
    })).subscribe();;
  }

}
