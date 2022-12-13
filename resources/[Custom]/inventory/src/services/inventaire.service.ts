import { Injectable } from '@angular/core';
import { HttpClient  } from '@angular/common/http';
import { Observable } from 'rxjs';
import { EnvService } from './env.service';

@Injectable({
  providedIn: 'root'
})
export class InventaireService {

  baseURL: string;

  constructor(
    private http: HttpClient,
    private env: EnvService,  
  ) {
    this.baseURL = this.env.baseURL    
  }

  // ******* CHARACTER INVENTORY
  getCharacterInventory(from: number): Observable<any[]> {
    return this.http.get<any[]>(this.baseURL + 'inventory-character/from/'+from);
  }

  buyShop(item: { price?: number; itemId?: any; quantity?: any; cid?: any; weight?: number; itemName?: number;}): Observable<{message:string}> {
    return this.http.put<{message:string}>(this.baseURL + 'inventory-character/buy-shop/'+item.cid, item)
  }

  // createCharacterInventory(item: any): Observable<any[]> {
  //   return this.http.post<any[]>(this.baseURL + 'inventory-character/create', item);
  // }

  // updateCharacterInventory(id: number, item: any): Observable<any[]> {
  //   return this.http.put<any[]>(this.baseURL + 'inventory-character/update/'+id, item);
  // }

  // deleteCharacterInventory(id: string): Observable<any[]> {
  //   return this.http.delete<any[]>(this.baseURL + 'inventory-character/delete/'+id);
  // }


  // ******* VEHICULE INVENTORY
  getVehiculeInventory(plate: string): Observable<any[]> {
    return this.http.get<any[]>(this.baseURL + 'coffre-vehicule/'+plate);
  }

  // createVehiculeInventory(item: any): Observable<any[]> {
  //   return this.http.post<any[]>(this.baseURL + 'coffre-vehicule/create', item);
  // }

  // updateVehiculeInventory(id: string, item: any): Observable<any[]> {
  //   return this.http.put<any[]>(this.baseURL + 'coffre-vehicule/update/'+id, item);
  // }

  // deleteVehiculeInventory(id: string, from: number, plate: string): Observable<any[]> {
  //   return this.http.delete<any[]>(this.baseURL + 'coffre-vehicule/delete/'+id+'/from/'+from+'/plate/'+plate);
  // }

  updateCoffreVehicule(item: { cid: number; from: any; itemId: any; quantity: any; plate: string; }): Observable<{message:string}> {
    return this.http.put<{message:string}>(this.baseURL + 'inventory-character/vehicule/'+item.cid, item)
  }



  // ******* COFFRE INVENTORY
  getCoffre(id: number): Observable<any[]> {
    return this.http.get<any[]>(this.baseURL + 'coffre/'+id);
  }

  updateCoffre(item: { cid: number; from: any; itemId: any; quantity: any; coffreId: number; }): Observable<{message:string}> {
    return this.http.put<{message:string}>(this.baseURL + 'inventory-character/coffre/'+item.cid, item)
  }



  // ******** SHOP
  getShop(id: number){
    return this.http.get<any[]>(this.baseURL + 'shop/'+id);
  }
}
