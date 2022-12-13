import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CharacterService {

  baseURL = 'https://swiily.ddns.net:8888/api/';
  // baseURL = 'http://localhost:81/phone-api/api/';

  constructor(private http: HttpClient) {
    
  }

  getCharacter(id: number): Observable<any> {
    return this.http.get<any>(this.baseURL + "characters/" + id);
  }

  updateCharacter(id: number, c: {id: number, cash?: number, bank?: number}): Observable<any> {
    return this.http.put<any>(this.baseURL + 'characters/update/' + id, c);
  }

  getInventory(id: number): Observable<any> {
    return this.http.get<any>(this.baseURL + "inventory-character/from/" + id);
  }

  updateInventory(id: number, item: any): Observable<any[]> {
    return this.http.put<any[]>(this.baseURL + 'inventory-character/update/'+id, item);
  }

  deleteInventory(id: string): Observable<any[]> {
    return this.http.delete<any[]>(this.baseURL + 'inventory-character/delete/'+id);
  }
}
