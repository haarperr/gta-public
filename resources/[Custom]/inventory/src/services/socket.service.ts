import { Injectable } from '@angular/core';
import io from 'socket.io-client';
import { Observable, Subscriber } from 'rxjs';
import { EnvService } from './env.service';

@Injectable({
  providedIn: 'root'
})
export class SocketService {

  socket :any;

  baseURL: string;

    constructor(private env: EnvService) {
      this.baseURL = this.env.baseURL.replace('/api/', '/')
    // this.socket = io('http://localhost:81/phone-api/')
      this.socket = io(this.baseURL)
    }

    listen(Eventname : string){
      return new Observable((subscriber: { next: (arg0: any) => void; })=>{
        this.socket.on(Eventname,(data:any)=>{
            subscriber.next(data);
        })
      })
    }

    stop(Eventname? : string){
      this.socket.off(Eventname)
    }

    send(data: any){
      this.socket.emit('chatmsg', data)
    }
}
