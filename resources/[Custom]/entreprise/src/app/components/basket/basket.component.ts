import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { CommandeService } from 'src/app/services/commande.service';
import { BasketService } from '../../services/basket.service';

@Component({
  selector: 'app-basket',
  templateUrl: './basket.component.html',
  styleUrls: ['./basket.component.scss']
})
export class BasketComponent implements OnInit {
  basket: any
  totalBasket: number = 0

  constructor(
    private BasketService: BasketService,
    private orderService: CommandeService,
    private _snackBar: MatSnackBar,
  ) {
    this.basket = this.BasketService.getBasket()
    this.updateTotal()
  }

  ngOnInit(): void {
  }

  edit(event: any, item: any){
    let quantity = Number(event.target.value);
    if (quantity >= 1 && item) {      
      if (quantity > item.buyMaxQuantity) {
        event.target.value = item.quantity
        this._snackBar.open("Erreur : Maximum "+item.buyMaxQuantity+" x "+item.name+" par commande.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
        return            
      } else if (item.quantity <= item.buyMaxQuantity) {
        item.quantity = quantity
        this.BasketService.editItem(item)
        this.updateTotal()
      }
    } else {
      this._snackBar.open("Erreur : Veuillez saisir une quantité valide.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
    }
  }

  delete(item: any){
    this.BasketService.deleteItem(item)
    this.basket = this.BasketService.getBasket()
    this.updateTotal()
  }

  updateTotal(){
    let total = 0
    for (let i = 0; i < this.basket.length; i++) {
      total += (this.basket[i].quantity * this.basket[i].buyPrice);
    }
    this.totalBasket = total
  }


}
