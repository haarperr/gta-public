import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CollectionCarService {
  baseURL = 'https://swiily.ddns.net:8888/api/collection-car/';
  // baseURL = 'http://localhost:81/phone-api/api/collection-car/';

  constructor(private http: HttpClient) { }

  getAll(id: number): Observable<any> {
    return this.http.get<any>(this.baseURL + 'orga/' + id);
  }

  getActive(id: number): Observable<any> {
    return this.http.get<any>(this.baseURL + 'active/' + id);
  }
}
