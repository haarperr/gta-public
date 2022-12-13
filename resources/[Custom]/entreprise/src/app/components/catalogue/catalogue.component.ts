import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { BasketService } from '../../services/basket.service';
import { ItemService } from '../../services/item.service';

@Component({
  selector: 'app-catalogue',
  templateUrl: './catalogue.component.html',
  styleUrls: ['./catalogue.component.scss']
})
export class CatalogueComponent implements OnInit {


  items: any
  basket: any

  constructor(
    private BasketService: BasketService,
    private itemService: ItemService,
    private _snackBar: MatSnackBar,
  ) { 
    this.basket = this.BasketService.getBasket()
    this.itemService.getBuyable().subscribe(res => {
      this.items = res
    })
  }

  ngOnInit(): void {
  }

  addToBasket(item: any){
    let quantity = Number((<HTMLInputElement>document.getElementById("input"+item.id)).value);
    if (quantity && quantity >= 1) {
      item.quantity = quantity
      this.BasketService.addItem(item)
    } else {
      // error
      this._snackBar.open("Erreur : Veuillez saisir une quantité valide.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
    }
  }

}
