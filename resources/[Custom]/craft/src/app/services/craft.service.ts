import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CraftService {

  baseURL = 'https://swiily.ddns.net:8888/api/crafts/';
  // baseURL = 'http://localhost:81/phone-api/api/crafts/';

  constructor(private http: HttpClient) {
    
  }

  getAll(): Observable<any> {
    return this.http.get<any>(this.baseURL);
  }

  getAllType(type: string): Observable<any> {
    return this.http.get<any>(this.baseURL + "type/" + type);
  }

  getAllEntreprise(id: number): Observable<any> {
    return this.http.get<any>(this.baseURL + "entreprise/" + id);
  }
}
