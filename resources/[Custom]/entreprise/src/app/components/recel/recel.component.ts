import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { CharacterService } from 'src/app/services/character.service';

@Component({
  selector: 'app-recel',
  templateUrl: './recel.component.html',
  styleUrls: ['./recel.component.scss']
})
export class RecelComponent implements OnInit {

  cid: number
  items: any[] = []

  constructor(
    private characterService: CharacterService,
    private _snackBar: MatSnackBar,
    private http: HttpClient,
  ) {
    this.cid = Number(localStorage.getItem("cid"))
    this.updateInventory()
  }

  ngOnInit(): void {
  }

  updateInventory(){
    this.items = []
    this.characterService.getInventory(this.cid).subscribe(res => {
      for (let i = 0; i < res.length; i++) {
        if(res[i].Item.priceRecel){
          this.items.push(res[i])
        }
      }
    })
  }

  sell(item: any){
    let quantity = Number((<HTMLInputElement>document.getElementById("input"+item.id)).value);
    if (quantity && quantity >= 1 && quantity <= item.quantity) {
      let total = quantity * item.Item.priceRecel
      this.http.post('http://inventory/triggerEvent', {name: "recelSellItem", data: {dirty: total, item: item.Item.id, quantity: quantity}}).subscribe();
      for (let i = 0; i < this.items.length; i++) {
        if(this.items[i].id){
          if (quantity < item.quantity) {
            this.items[i].quantity = this.items[i].quantity - quantity
          } else {
            this.items = this.items.filter(i => i.id != item.id)
          }
          break
        }
      }
      // this.characterService.getCharacter(this.cid).subscribe(res => {
      //   if(res){
      //     if (quantity < item.quantity) {
      //       item.quantity = item.quantity - quantity
      //       // this.characterService.updateInventory(item.id, item).subscribe((a: any) => {
      //       //   if (a) {
      //       //     this.updateInventory()
      //       //     let c = {
      //       //       id: res.id,
      //       //       cash: (res.cash + total)
      //       //     }
      //       //     this.characterService.updateCharacter(this.cid, c).subscribe(r => {
      //       //       if (!r) {
      //       //         this._snackBar.open("Une erreur s'est produite.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      //       //         console.log('erreur lors de la mise à jour de l\'inventaire.')                    
      //       //       } else {
      //       //         this.http.post('http://inventory/triggerEvent', {name: "updateCashInventaire", data: res.cash + total}).subscribe();
      //       //         this._snackBar.open("Succès : Vous avez revendu "+quantity+" x "+item.Item.name+" pour un total de $"+total+".00 .", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      //       //       }
      //       //     })
      //       //   } else {
      //       //     this._snackBar.open("Une erreur s'est produite.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      //       //     console.log('erreur lors de la mise à jour de l\'inventaire.')
      //       //   }
      //       // })

      //     } else if (quantity === item.quantity) {
      //       // this.characterService.deleteInventory(item.id).subscribe((a: any) => {
      //       //   if(a){
      //       //     this.updateInventory()
      //       //     let c = {
      //       //       id: res.id,
      //       //       cash: (res.cash + total)
      //       //     }
      //       //     this.characterService.updateCharacter(this.cid, c).subscribe(r => {
      //       //       if (!r) {
      //       //         this._snackBar.open("Une erreur s'est produite.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      //       //         console.log('erreur lors de la mise à jour de l\'inventaire.')                    
      //       //       } else {
      //       //         this.http.post('http://inventory/triggerEvent', {name: "updateCashInventaire", data: res.cash + total}).subscribe();
      //       //         this._snackBar.open("Succès : Vous avez revendu "+quantity+" x "+item.Item.name+" pour un total de $"+total+".00 .", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      //       //       }
      //       //     })
      //       //   } else {
      //       //     this._snackBar.open("Une erreur s'est produite.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      //       //     console.log('erreur lors de la mise à jour de l\'inventaire.')
      //       //   }
      //       // })
      //     }
      //   } else {
      //     this._snackBar.open("Une erreur s'est produite.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      //   }
      // })
    } else {
      this._snackBar.open("Erreur : Veuillez saisir une quantité valide.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
    }
  }

}
