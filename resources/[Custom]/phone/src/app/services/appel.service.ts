import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AppelService {

  /**
  * @property {string} URL URL de l'API coriandre
  **/
  // URL : string = 'http://localhost:8888/api/appel/';
  URL : string = 'https://swiily.ddns.net:8888/api/appel/';
  inCall: {active: boolean, with: number} = {active: false, with: 0};
  channelOpen : boolean = false;

  constructor(
    private http: HttpClient,
  ){  }

  getAll(to: number): Observable<any> {
    return this.http.get<any>(this.URL+'to/'+to);
  }
  
  getSeen(to: number): Observable<number> {
    return this.http.get<any>(this.URL+'unseen/'+to)
  }
  
  setSeen(to: number): Observable<number> {
    return this.http.get<any>(this.URL+'setseen/to/'+to)
  }

  setSeenLast(to: number, from: number): Observable<number> {
    return this.http.get<any>(this.URL+'setseenlast/to/'+to+"/from/"+from)
  }

  createCall(call: any): Observable<any> {
    return this.http.post<any>(this.URL+'create/', call);
  }

  getInCall() {
    let res: any = this.inCall
    res.channelOpen = this.channelOpen
    return res
  }

  setInCall(bool: boolean, w: number) {
    this.inCall = {active: bool, with: w}
  }

  setInCallBackend(to: number, from: number, bool: boolean) {
    return this.http.get<any>(this.URL+'setcall/'+to+"/"+from+"/"+bool)
  }

  toggleChannel(to: number, from: number, bool: boolean) {
    this.channelOpen = bool
    return this.http.get<any>(this.URL+'openchannel/'+to+"/"+from+"/"+bool)
  }
}
