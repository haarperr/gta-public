import { Component, HostListener, OnInit } from '@angular/core';
import {Location} from '@angular/common';
import { CharacterService } from 'src/app/services/character.service';
import { SoundService } from 'src/app/services/sound.service';


@Component({
  selector: 'app-settings',
  templateUrl: './settings.component.html',
  styleUrls: ['./settings.component.scss']
})
export class SettingsComponent implements OnInit {

  focused: number = 0;
  phoneNumber: number;
  volume: number = 100;

  constructor(
    private _location: Location,
    private cService: CharacterService,
    private soundService: SoundService
  ) { 
    this.volume = this.cService.getVolume()*100
    this.phoneNumber = Number(localStorage.getItem("phone"))
  }

  ngOnInit(): void {
  }

  soundTest(){
    let audio = new Audio();
    audio.src = "./assets/notification-sms.mp3";
    audio.load();
    audio.volume=this.volume/100;
    audio.play();
  }

  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Backspace":
        this._location.back();
        break
      case "ArrowUp":
        if (this.focused>0) {
          this.focused = this.focused-1
        }
        break;
      case "ArrowDown":
        if (this.focused<2) {
          this.focused++
        }
        break;
      case "ArrowLeft":
        if (this.focused===1) {
          if(this.volume-10>=0) {
            this.volume = this.volume-10
            this.cService.setVolume(this.volume/100)
            this.soundTest()
          }
        }
        break;
      case "ArrowRight":
        if (this.focused===1) {
          if(this.volume+10<=100) {
            this.volume = this.volume+10
            this.cService.setVolume(this.volume/100)
          }
          this.soundTest()
        }
        break;
      case "Enter":
        if (this.focused===2) {
          this.soundService.stopSound()
        }
        break
    }
  }

}
