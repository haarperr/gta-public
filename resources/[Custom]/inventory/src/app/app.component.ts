import { Component, HostListener, Output, ViewChild } from '@angular/core';
import {CdkDragDrop, copyArrayItem, moveItemInArray, transferArrayItem} from '@angular/cdk/drag-drop';
import { InventaireService } from 'src/services/inventaire.service';
import { HttpClient } from '@angular/common/http';
import { MatMenuTrigger } from '@angular/material/menu';
import { CharacterService } from 'src/services/character.service';
import { MatDialog } from '@angular/material/dialog';
import { ModalComponent } from './modal/modal.component';
import { SocketService } from 'src/services/socket.service';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  cID!: number

  inventaire: any[] = [];
  coffre: any;

  transferQuantity = 0
  temp: any;
  isVisible: any = false;
  type: string = 'inventaire';
  nearestPlayer: number = 0;
  cash: number = 0;
  plate: string = '';
  weapons: any;
  lastPlate: string = '';
  coffreId!: number;
  coffreType: string = "";
  shopId: number = 1;
  totalWeightInventaire: number = 0.0;
  maxWeighInventaire: number = 30.0;
  totalWeightCoffre: number = 0;

  constructor(
    private invService: InventaireService,
    private http: HttpClient,
    public dialog: MatDialog,
    private cService: CharacterService,
    private srv: SocketService,
    private _snackBar: MatSnackBar
  ) {
    // this.getInventaire()
    // this.getCash()
    // if (this.type==="inventaire") {
    // } else if (this.type==="vehicule") {
    //   this.getVehiculeInventaire()
    // } else if (this.type==="coffre") {
    //   this.getCoffre()
    // } else if (this.type==="shop") {
    //   this.getShop()
    // }
  }

  ngOnInit(){
  }

  getInventaire(){
    this.invService.getCharacterInventory(this.cID).subscribe((i: any[]) => {
      this.inventaire = i
      this.totalWeightInventaire = 0
      let disablePhone = true
      let disableRadio = true
      for (let i = 0; i < this.inventaire.length; i++) {
        this.totalWeightInventaire = this.totalWeightInventaire + (this.inventaire[i].Item.weight * this.inventaire[i].quantity)
        if(this.inventaire[i].itemId===33) {
          // SI C'EST UN TELEPHONE
          disablePhone = false
        }
        if (this.inventaire[i].itemId===38) {
          // SI C'EST UNE RADIO
          disableRadio = false
        }
      }
      this.http.post('http://inventory/triggerEvent', {name: "togglePhoneEnable", data: disablePhone}).subscribe();
      this.http.post('http://inventory/triggerEvent', {name: "toggleRadioEnable", data: disableRadio}).subscribe();
      this.checkWeapons()
    })
  }


  checkWeapons(){
    let weapons = []
    for (let i = 0; i < this.inventaire.length; i++) {
      if(this.inventaire[i].Item.type=='weapon'){
        weapons.push(this.inventaire[i])
      }
    }
    this.sendWeapon(weapons)
  }

  sendWeapon(weapons: any){
    this.http.post('http://inventory/sendWeapon', weapons).subscribe((res:any)=>{
      this.checkAmmos()
    });
  }


  
  checkAmmos(){
    let ammos = []
    for (let i = 0; i < this.inventaire.length; i++) {
      if(this.inventaire[i].Item.type=='ammo'){
        ammos.push(this.inventaire[i])
      }
    }
    this.sendAmmo(ammos)
  }

  sendAmmo(ammos: any){
    this.http.post('http://inventory/sendAmmo', ammos).subscribe();
  }


  getVehiculeInventaire(){
    this.invService.getVehiculeInventory(this.plate).subscribe((items: any[]) => {
      this.coffre = items
      this.totalWeightCoffre = 0
      for (let i = 0; i < this.coffre.length; i++) {
        this.totalWeightCoffre = this.totalWeightCoffre + (this.coffre[i].Item.weight * this.coffre[i].quantity)
      }
    })
    this.srv.stop()
    this.srv.listen('invVehicule'+this.plate).subscribe((res:any)=>{
      if(res.plate===this.plate) {
        this.invService.getVehiculeInventory(this.plate).subscribe((items: any[]) => {
          this.coffre = items
          this.totalWeightCoffre = 0
          for (let i = 0; i < this.coffre.length; i++) {
            this.totalWeightCoffre = this.totalWeightCoffre + (this.coffre[i].Item.weight * this.coffre[i].quantity)
          }
        })
      }
    })
  }

  getCash(){
    this.cService.getCharacter(this.cID).subscribe((c: any) => {
      if (c) this.cash = c.cash
      this.http.post('http://inventory/triggerEvent', {name: "updateCashInventaire", data: this.cash}).subscribe();
    })
  }

  getShop(){
    this.invService.getShop(this.shopId).subscribe((items: any[]) => {
      this.coffre = items
    });
  }

  getCoffre(){
    this.invService.getCoffre(this.coffreId).subscribe((coffre: any) => {
      this.coffre = coffre
      this.totalWeightCoffre = 0
      for (let i = 0; i < this.coffre.InventaireCoffres.length; i++) {
        this.totalWeightCoffre = this.totalWeightCoffre + (this.coffre.InventaireCoffres[i].Item.weight * this.coffre.InventaireCoffres[i].quantity)
      }
    });
    this.srv.stop()
    this.srv.listen('invCoffre'+this.coffreId).subscribe((res:any)=>{
      if (res.coffreId===this.coffreId) {
        this.invService.getCoffre(this.coffreId).subscribe((coffre: any) => {
          this.coffre = coffre
          this.totalWeightCoffre = 0
          for (let i = 0; i < this.coffre.InventaireCoffres.length; i++) {
            this.totalWeightCoffre = this.totalWeightCoffre + (this.coffre.InventaireCoffres[i].Item.weight * this.coffre.InventaireCoffres[i].quantity)
          }
        });
      }
    })
  }


  getInventaireFouille(){
    this.invService.getCharacterInventory(this.coffreId).subscribe((coffre: any) => {
      this.coffre = coffre
      this.totalWeightCoffre = 0
      for (let i = 0; i < this.coffre.length; i++) {
        this.totalWeightCoffre = this.totalWeightCoffre + (this.coffre[i].Item.weight * this.coffre[i].quantity)
      }
    });
    // this.srv.stop()
    // this.srv.listen('invJoueur'+this.coffreId).subscribe((res:any)=>{
    //   if (res.coffreId===this.coffreId) {
    //     this.invService.getCoffre(this.coffreId).subscribe((coffre: any) => {
    //       this.coffre = coffre
    //       this.totalWeightCoffre = 0
    //       for (let i = 0; i < this.coffre.length; i++) {
    //         this.totalWeightCoffre = this.totalWeightCoffre + (this.coffre[i].Item.weight * this.coffre[i].quantity)
    //       }
    //     });
    //   }
    // })
  }


  



  // GESTION DU DROP
  drop(event: CdkDragDrop<string[]>, list: string) {
    // SI ON DROP AU MEME ENDROIT ON NE FAIT RIEN
    if (event.previousContainer != event.container) {
      // ************ IF TYPE INVENTAIRE
      if(this.type==="inventaire" && this.nearestPlayer) {
        // SI ON DROP DANS LE COFFRE A ECHANGE
        if(list==='coffre') { 
          if(event.previousContainer.id==="wallet") { 
            if (event.item.element.nativeElement.id === "cash") {
              let state = {
                from: event.previousContainer.id,
                input: {quantity: this.cash},
              }
              this.openDialogInventaire(state)
            }
          // SINON C'EST L'INVENTIARE
          } else {
            let state = {
              from: event.previousContainer.id,
              input: this.inventaire[event.previousIndex],
            }
            state.input.previousIndex = event.previousIndex
            this.openDialogInventaire(state)
          }
        }
      // ************ ELSE NOT TYPE INVENTAIRE 
      } else if(this.type === "coffre" || this.type === "vehicule") { 
        // *** SI ON DROP DANS L'INVENTAIRE
        if(list==='inventaire') {
          let item = {itemId: 0}
          if (this.type==="coffre") {
            item = this.coffre.InventaireCoffres[event.previousIndex]
          } else if (this.type==="vehicule") {
            item = this.coffre[event.previousIndex]
          }
          this.openDialog({input: item, from: "coffre"})
        // *** SINON ON DROP DANS LE COFFRE
        } else if(list==='coffre') { 
          let item = this.inventaire[event.previousIndex]
          this.openDialog({input: item, from: "inventaire"})
        }
      } else if (this.type === "shop") {
        this.openDialogShop({input: this.coffre[event.previousIndex], from: "inventaire"})
      }
    }
  }

  


  openDialog(data: any): void {
    const dialogRef = this.dialog.open(ModalComponent, {
      data: data,
    });

    dialogRef.afterClosed().subscribe((result: any) => {
      if (result) {
        if (this.type === "coffre") {
          let req = {
            cid: this.cID,
            from: result.from,
            itemId: result.initial.Item.id,
            quantity: result.input,
            coffreId: this.coffreId
          }
          this.invService.updateCoffre(req).subscribe( (res: { message: string; }) => {
            this.getInventaire()
            this._snackBar.open(res.message , 'OK', {panelClass: ['success-snackbar'], duration: 4000 });
          }, 
          (err:any)=>{
            console.log(err);
            this._snackBar.open("Erreur : " + (err.error.message? err.error.message : 'Une erreur est survenue.') , 'OK', {panelClass: ['error-snackbar'], duration: 4000 });
          })
        } else if (this.type === "vehicule") {
          let req = {
            cid: this.cID,
            from: result.from,
            itemId: result.initial.Item.id,
            quantity: result.input,
            plate: this.plate
          }
          this.invService.updateCoffreVehicule(req).subscribe( (res: { message: string; }) => {
            this.getInventaire()
            this._snackBar.open(res.message , 'OK', {panelClass: ['success-snackbar'], duration: 4000 });
          }, 
          (err:any)=>{
            console.log(err);
            this._snackBar.open("Erreur : " + (err.error.message? err.error.message : 'Une erreur est survenue.') , 'OK', {panelClass: ['error-snackbar'], duration: 4000 });
          })
        } else if (result.from==="inventaire") {

        }
        setTimeout(() => {
          if(result.initial.Item.type == 'weapon'||result.initial.Item.type == 'ammo'){
            this.checkWeapons()
          }
        }, 500);
      }
    });
  }




  openDialogInventaire(data: any): void {
    const dialogRef = this.dialog.open(ModalComponent, {
      data: data,
    });

    dialogRef.afterClosed().subscribe((result: any) => {
      if (result) {
        // SI C'EST LE PORTE FEUILLE
        if(result.from==="wallet") { 
          if (result.input <= this.cash && this.nearestPlayer) {
            this.cash = this.cash - result.input
            this.http.post('http://inventory/transfertCash', {to: this.nearestPlayer, quantity: result.input}).subscribe((res:any) => {
              if(res=="cancel"){
                this.cash = this.cash + result.input
              }
            });
          }
        // SINON C'EST L'INVENTIARE
        } else { 
          if (this.nearestPlayer) {
            let del = false
            if (result.initial.quantity > result.input) {
              this.inventaire[result.initial.previousIndex].quantity = this.inventaire[result.initial.previousIndex].quantity-result.input
            } else if (result.initial.quantity === result.input) {
              del = true 
              if(this.inventaire[result.initial.previousIndex].itemId===33) {
                // SI C'EST UN TELEPHONE
                this.http.post('http://inventory/triggerEvent', {name: "togglePhoneEnable", data: true}).subscribe();
              }
              if(this.inventaire[result.initial.previousIndex].itemId===38) {
                // SI C'EST UN TELEPHONE
                this.http.post('http://inventory/triggerEvent', {name: "toggleRadioEnable", data: true}).subscribe();
              }
              this.inventaire.splice(result.initial.previousIndex, 1)
            }
            let ele = result.initial
            this.http.post('http://inventory/transfertTo', {to: this.nearestPlayer, quantity: result.input, item: ele}).subscribe((res: any) => {
              if(res=="cancel"){
                if(del){
                  this.inventaire.push(ele)
                } else {
                  this.inventaire[result.initial.previousIndex].quantity = this.inventaire[result.initial.previousIndex].quantity+result.input
                }
              }
            });
          }
        }
        setTimeout(() => {
          if(result.initial.Item.type == 'weapon'||result.initial.Item.type == 'ammo'){
            this.checkWeapons()
          }
        }, 500);
      }
    });
  }



  openDialogShop(data: any): void {
    const dialogRef = this.dialog.open(ModalComponent, {
      data: data,
    });

    dialogRef.afterClosed().subscribe((result: any) => {
      if (result) {
        let total = result.input*result.initial.Item.price
        if (total <= this.cash) {
          this.cash = this.cash - total
          let req = {
            price: total,
            itemId: result.initial.itemId,
            itemName: result.initial.Item.name,
            weight: (result.initial.Item.weight * result.input),
            quantity: result.input,
            cid: this.cID,
          }
          this.invService.buyShop(req).subscribe( (res: { message: string; }) => {
            this.getInventaire()
            this._snackBar.open(res.message , 'OK', {panelClass: ['success-snackbar'], duration: 4000 });
          }, 
          (err:any)=>{
            console.log(err);
            this._snackBar.open("Erreur : " + (err.error.message? err.error.message : 'Une erreur est survenue.') , 'OK', {panelClass: ['error-snackbar'], duration: 4000 });
          })
        } else {
          this._snackBar.open("Tu n'as pas assez d'argent.", 'OK', {panelClass: ['error-snackbar'], duration: 4000 });
        }
      }
    });
  }


  test(e: any){
    console.log(e);
    
  }






  @ViewChild(MatMenuTrigger)
  contextMenu!: MatMenuTrigger;
  contextMenuPosition = { x: '0px', y: '0px' };
  onContextMenu(event: MouseEvent, item: Item) {
    event.preventDefault();
    this.contextMenuPosition.x = event.clientX + 'px';
    this.contextMenuPosition.y = event.clientY + 'px';
    this.contextMenu.menuData = { 'item': item };
    this.contextMenu.menu.focusFirstItem('mouse');
    this.contextMenu.openMenu();
  }
  onContextMenuWallet(event: MouseEvent, type: string) {
    event.preventDefault();
    this.contextMenuPosition.x = event.clientX + 'px';
    this.contextMenuPosition.y = event.clientY + 'px';
    this.contextMenu.menuData = { 'item': type };
    this.contextMenu.menu.focusFirstItem('mouse');
    this.contextMenu.openMenu();
  }


  seeFromWallet(type: string){
    console.log(type);
    
  }
  showFromWallet(type: string){

  }

  useFood(item: Item) {
    // for (let i = 0; i < this.inventaire.length; i++) {
    //   if (this.inventaire[i].id === item.id) {
    //     this.inventaire[i].quantity = this.inventaire[i].quantity - 1
    //     this.invService.updateCharacterInventory(this.inventaire[i].id, this.inventaire[i]).subscribe((a: any) => {!a? console.log('erreur lors de la mise à jour de l\'inventaire.'):null;});
    //     break
    //   }
    // }
    this.http.post('http://inventory/useItem', item).subscribe();
  }

  useItem(item: Item) {
    this.http.post('http://inventory/useItem', item).subscribe();
  }

  useTool(item: Item) {
    this.http.post('http://inventory/useItem', item).subscribe();
  }

  useAmmo(item: Item) {
    // let hash
    // let q
    // for (let i = 0; i < this.inventaire.length; i++) {
    //   if (this.inventaire[i].id === item.id ) {
    //     if(this.inventaire[i].quantity === 1) {
    //       this.inventaire.splice(i, 1)
    //     } else if(this.inventaire[i].quantity > 1){
    //       this.inventaire[i].quantity = this.inventaire[i].quantity - 1
    //     }
    //     hash = this.inventaire[i].Item.action
    //     q = this.inventaire[i].Item.priceCrimi
    //     this.invService.updateCharacterInventory(this.inventaire[i].id, this.inventaire[i]).subscribe((a: any) => {!a? console.log('erreur lors de la mise à jour de l\'inventaire.'):null;});
    //     break
    //   }
    // }
    // this.http.post('http://inventory/useAmmo', {hash: hash, q: q}).subscribe();
  }

  destroy(item: Item) {
    console.log(item);
  }


  @HostListener('window:message', ['$event'])
  onMessage(event: MessageEvent) {
    if(event.data.action ==="isVisible"){
      this.isVisible = event.data.data
      if(this.isVisible===false){
        this.srv.stop()
        this.dialog.closeAll()
        this.contextMenu.closeMenu();
      }
      if (event.data.cid) {
        this.cID = event.data.cid
        this.type = event.data.type
        this.getInventaire()
        if (this.type==="inventaire") {
          this.getCash()          
          this.getInventaire()
        } else if(this.type==="vehicule"){
          this.lastPlate = this.plate
          this.plate = event.data.plate
          this.getVehiculeInventaire()
        } else if(this.type==="coffre"){
          this.coffreId = event.data.coffreId
          this.coffreType = event.data.coffreType
          this.getCoffre()
        } else if(this.type==="fouille"){
          this.coffreId = event.data.coffreId
          this.getInventaireFouille()
        } else if(this.type==="shop"){
          this.shopId = event.data.shopId
          this.getCash()
          this.getShop()
        }
      }
    } else if(event.data.action === "nearestPlayer") {
      this.nearestPlayer = event.data.nearestPlayer
    } else if(event.data.action === "refresh"){
      if (event.data.cid) {
        this.cID = event.data.cid
        this.getInventaire()
        this.getCash()    
      }
    }
  }

  @HostListener('document:click', ['$event'])
  clickin(event: any) {
    if(event.target.id==="root"){
      this.isVisible = false;
      this.http.post('http://inventory/close', {}).subscribe();
    }
  }


  @HostListener('window:keydown', ['$event'])
  keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Escape":
      case "KeyI":
      case "KeyO":
      case "KeyE":
        this.srv.stop()
        this.dialog.closeAll();
        this.contextMenu.closeMenu();
        this.isVisible = false;
        this.http.post('http://inventory/close', {}).subscribe();
      break
    }
  }



}

export interface Item {
  id: number;
  name: string;
}
