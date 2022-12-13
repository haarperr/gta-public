import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class SoundService {

  audio: HTMLAudioElement;

  constructor(
  ) {
    this.audio = new Audio();
  }

  playSound(type: string){
    if (type === 'doorbell') {
      this.audio = new Audio();
      this.audio.src = "./assets/doorbell.mp3";
      this.audio.load();
      this.audio.volume=0.1;
      this.audio.play();
    } 
  }

  stopSound(){
    this.audio.pause()
  }
}
