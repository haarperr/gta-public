import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { BehaviorSubject, Observable, Subject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class BasketService {

  private basketNumber: BehaviorSubject<number>;

  constructor(
    private http: HttpClient,
    private _snackBar: MatSnackBar,
  ) {
    this.basketNumber = new BehaviorSubject<number>(0);
    let basket = JSON.parse(localStorage.getItem("basket")!)
    if (basket) {
      this.basketNumber.next(basket.length)
    }
  }

  watchBasket(): Observable<any> {
    return this.basketNumber.asObservable();
  }

  getBasket(): any {
    return JSON.parse(localStorage.getItem("basket")!)
  }

  addItem(item: any){
    let basket = JSON.parse(localStorage.getItem("basket")!)
    if (!basket) {
      basket = []
    }
    let check: number = -1
    for (let i = 0; i < basket.length; i++) {
      if (basket[i].id === item.id) {
        check = i
        if (basket[i].quantity === basket[i].buyMaxQuantity) {
          this._snackBar.open("Erreur : Maximum "+item.buyMaxQuantity+" x "+item.name+" par commande déjà atteint.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
          return
        } else if (basket[i].quantity + item.quantity > basket[i].buyMaxQuantity) {
          this._snackBar.open("Erreur : Maximum "+basket[i].buyMaxQuantity+" x "+basket[i].name+" par commande, déjà "+basket[i].quantity+" x "+basket[i].name+" dans le panier.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
          return            
        }
        break
      }
    }
    if (item.quantity > item.buyMaxQuantity) {
      this._snackBar.open("Erreur : Maximum "+item.buyMaxQuantity+" x "+item.name+" par commande.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      return            
    }
    if (check >=0){
      basket[check].quantity = basket[check].quantity + item.quantity
    } else {
      basket.push(item)
      this.basketNumber.next(basket.length)
    }
    localStorage.setItem('basket', JSON.stringify(basket));
    this._snackBar.open("Succès : "+item.quantity+" x "+item.name+" ajouté au panier.", 'OK', {duration: 2000, panelClass: ['success-snackbar']});
  }

  editItem(item: any){
    if (item.quantity > item.buyMaxQuantity) {
      // this._snackBar.open("Erreur : Maximum "+item.buyMaxQuantity+" x "+item.name+" par commande.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      return            
    }
    let basket = JSON.parse(localStorage.getItem("basket")!)
    for (let i = 0; i < basket.length; i++) {
      if (basket[i].id === item.id) {
        basket[i].quantity = item.quantity
        break
      }
    }
    localStorage.setItem('basket', JSON.stringify(basket));
  }

  deleteItem(item: any){
    let basket = JSON.parse(localStorage.getItem("basket")!)
    let j = -1
    for (let i = 0; i < basket.length; i++) {
      if (basket[i].id === item.id) {
        j = i
        break
      }
    }
        
    if (j >= 0) {
      basket.splice(j, 1)
      this.basketNumber.next(basket.length)
      localStorage.setItem('basket', JSON.stringify(basket));
    }
  }
  
  flush(){
    this.basketNumber.next(0)
    localStorage.setItem('basket', JSON.stringify(null));
  }
  
}
