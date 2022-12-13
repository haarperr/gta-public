import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CharacterService {
  baseURL = 'https://swiily.ddns.net:8888/api/characters/';

  cash: number = 0
  bank: number = 0

  constructor(private http: HttpClient) { }

  getCharacter(id: number): Observable<any> {
    return this.http.get<any>(this.baseURL + id)
  }

  getCash(): number {
    return this.cash
  }
  getBank(): number {
    return this.bank
  }
  setCash(cash: number) {
    this.cash = cash
  }
  setBank(bank: number) {
    this.bank = bank
  }

  updateCharacter(id: number, c: {id: number, cash: number, bank: number}): Observable<any> {
    return this.http.put<any>(this.baseURL + 'update/' + id, c);
  }
}
