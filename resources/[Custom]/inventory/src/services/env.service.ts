import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';



/**
  * @ngdoc service
  * @name EnvService
  * 
  * @description
  * Gestion de l'environnement Angular
**/
@Injectable({
  providedIn: 'root'
})
export class EnvService {

  public baseURL: string = '';

  constructor( ) {  
  }

}
