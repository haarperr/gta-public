import { Injectable } from '@angular/core';
import io from 'socket.io-client';
import { Observable, Subscriber } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SocketService {

  socket :any;

  constructor() {
    // this.socket = io('http://localhost:81/phone-api/')
    this.socket = io('https://swiily.ddns.net:8888')
  }

  listen(Eventname : string){
    return new Observable((subscriber)=>{
      this.socket.on(Eventname,(data:any)=>{
          subscriber.next(data);
      })
    })
  }

  stop(Eventname : string){
    this.socket.off(Eventname)
  }

  send(data: any){
    this.socket.emit('chatmsg', data)
  }
}
