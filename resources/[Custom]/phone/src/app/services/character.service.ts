import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CharacterService {

  // URL : string = 'http://localhost:8888/api/characters/';
  URL : string = 'https://swiily.ddns.net:8888/api/characters/';
  volume: number;

  constructor(
    private http: HttpClient,
  ){
    this.volume = 1
  }

  getCharacter(id: number): Observable<any> {
    return this.http.get<any>(this.URL+''+id);
  }

  getVolume(): number {
    return this.volume
  }

  setVolume(v: number): void {
    this.volume = v
  }
}
