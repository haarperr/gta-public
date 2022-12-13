import { Injectable } from '@angular/core';
import { HttpClient  } from '@angular/common/http';
import { Observable } from 'rxjs';
import { EnvService } from './env.service';

@Injectable({
  providedIn: 'root'
})
export class CharacterService {

  baseURL: string;

  constructor(
    private http: HttpClient,
    private env: EnvService,  
  ) {
    this.baseURL = this.env.baseURL+'characters/'
    
  }

  getCharacter(id: number): Observable<any> {
    return this.http.get<any>(this.baseURL+id);
  }

  setCash(id: number, cash: any): Observable<any> {
    return this.http.put<any>(this.baseURL+'update/'+id, cash);
  }
}
