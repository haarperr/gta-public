import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ItemService {
  baseURL = 'https://swiily.ddns.net:8888/api/items/';
  // baseURL = 'http://localhost:81/phone-api/api/items/';

  constructor(private http: HttpClient) { }

  getAll(): Observable<any> {
    return this.http.get<any>(this.baseURL);
  }

  getBuyable(): Observable<any> {
    return this.http.get<any>(this.baseURL+"/buyable");
  }
}
