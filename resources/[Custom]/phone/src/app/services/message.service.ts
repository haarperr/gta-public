import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MessageService {
  /**
  * @property {string} URL URL de l'API coriandre
  **/
  // URL : string = 'http://localhost:8888/api/messages/';
  URL : string = 'https://swiily.ddns.net:8888/api/messages/';

  constructor(
    private http: HttpClient,
  ){  }

  getAll(to: number): Observable<any> {
    return this.http.get<any>(this.URL+'to/'+to);
  }

  getAllEntreprise(id: number): Observable<any> {
    return this.http.get<any>(this.URL+'entreprise/'+id);
  }

  getAllFrom(to: number, from: number): Observable<any> {
    return this.http.get<any>(this.URL+'to/'+to+'/from/'+from);
  }
  
  getUnseen(to: number): Observable<number> {
    return this.http.get<any>(this.URL+'unseen/'+to)
  }

  getUnseenEntreprise(id: number): Observable<number> {
    return this.http.get<any>(this.URL+'unseen/entreprise/'+id)
  }

  setSeen(to: number, from: number): Observable<number> {
    return this.http.get<any>(this.URL+'setseen/to/'+to+'/from/'+from)
  }

  getSeenOne(id: number): Observable<number> {
    return this.http.get<any>(this.URL+'setseen/id/'+id)
  }

  sendSms(sms: any): Observable<any> {
    return this.http.post<any>(this.URL+'create/', sms);
  }
}
