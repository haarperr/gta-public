import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CommandeService {
  baseURL = 'https://swiily.ddns.net:8888/api/commandes/';
  // baseURL = 'http://localhost:81/phone-api/api/commandes/';

  constructor(private http: HttpClient) { }

  getOne(id: number): Observable<any> {
    return this.http.get<any>(this.baseURL + id);
  }

  getAll(): Observable<any> {
    return this.http.get<any>(this.baseURL);
  }

  create(item: any): Observable<any> {
    return this.http.post<any>(this.baseURL+'create', item)
  }

  update(id: number, c: {id: number, statut: string}): Observable<any> {
    return this.http.put<any>(this.baseURL + 'update/' + id, c);
  }
}
