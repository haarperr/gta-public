import { Injectable } from '@angular/core';
import { CharacterService } from './character.service';

@Injectable({
  providedIn: 'root'
})
export class SoundService {

  audio: HTMLAudioElement;

  constructor(
    private cService: CharacterService
  ) {
    this.audio = new Audio();
    this.audio.volume=this.cService.getVolume();
  }

  playSound(type: string){
    if (type === 'sms') {
      this.audio.src = "./assets/notification-sms.mp3";
      this.audio.load();
      this.audio.loop = false
      this.audio.play();
    } else if (type === 'appel') {
      this.audio.src = "./assets/notification-sms.mp3";
      this.audio.load();
      this.audio.loop = true
      this.audio.play();
    } else if (type === 'calling') {
      this.audio.src = "./assets/calling.mp3";
      this.audio.load();
      this.audio.loop = true
      this.audio.play();
    }
  }

  stopSound(){
    this.audio.pause()
  }
}
