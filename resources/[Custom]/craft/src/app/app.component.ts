import { animate, state, style, transition, trigger } from '@angular/animations';
import { HttpClient } from '@angular/common/http';
import { Component, HostListener, ViewChild } from '@angular/core';
import { MatSidenav } from '@angular/material/sidenav';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';
import { CharacterService } from './services/character.service';
import { CraftService } from './services/craft.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  animations: [
    trigger(
      'myAnimation',
      [
        transition(
        ':enter', [
          style({transform: 'translateX(-10%)', opacity: 0}),
          animate('200ms', style({transform: 'translateX(0)', 'opacity': 1}))
        ]
      ),
      transition(
        ':leave', [
          style({transform: 'translateX(0)', 'opacity': 1}),
          animate('200ms', style({transform: 'translateX(-10%)', 'opacity': 0}))
        ]
      )]
    )
  ]
})
export class AppComponent {

  isVisible : boolean = false;
  basket: any

  selected: any
  @ViewChild('sidenav') public sidenav!: MatSidenav;
  crafts: any;
  craft: any;
  busy: boolean =  false
  cid: number;
  inventory: any;
  craftable: boolean = false;
  craftQuantity: number = 1
  craftDuration: any
  inputQuantity: number = 1
  organisationId?: number;
  
  constructor(
    private http: HttpClient,
    private router: Router,
    private _snackBar: MatSnackBar,
    private craftService: CraftService,
    private characterService: CharacterService
    ) {
      // localStorage.setItem("organisationId", String(1))
      // localStorage.setItem("cid", "1")
      this.cid = Number(localStorage.getItem("cid"))
      this.organisationId = Number(localStorage.getItem("organisationId"))
      this.getInventory()
      this.craftService.getAllType("general").subscribe(res => {
        this.crafts = res
      })
  }

  ngOnInit(): void {
    // localStorage.setItem("cid", "1")
  }

  getInventory(){
    this.characterService.getInventory(this.cid).subscribe(res => {
      this.inventory = res
      if (this.craft) {
        this.craftable = true
        for (let c = 0; c < this.craft.CraftRecettes.length; c++) {
          this.craft.CraftRecettes[c].inventory = null              
        }
        for (let c = 0; c < this.craft.CraftRecettes.length; c++) {
          for (let i = 0; i < this.inventory.length; i++) {
            if(this.craft.CraftRecettes[c].Item.id === this.inventory[i].Item.id) {
              this.craft.CraftRecettes[c].inventory = this.inventory[i].quantity
            }
          }
        }
        for (let c = 0; c < this.craft.CraftRecettes.length; c++) {
          if(!this.craft.CraftRecettes[c].inventory || this.craft.CraftRecettes[c].inventory < this.craft.CraftRecettes[c].quantity) {
            this.craftable = false
          }
        }
      }
    })
  }

  getCraft(type?: string, organisationId?: number){
    if (type) {
      this.craftService.getAllType(type).subscribe(res => {
        this.crafts = res
      })
    } else if (organisationId && this.organisationId && organisationId === this.organisationId) {
      this.craftService.getAllEntreprise(this.organisationId).subscribe(res => {
        this.crafts = res
      })
    }
  }


  previewCraft(item: any){
    if (!this.busy) {
      this.inputQuantity = 1
    }
    this.craft = item
    this.craftable = true
    for (let c = 0; c < this.craft.CraftRecettes.length; c++) {
      for (let i = 0; i < this.inventory.length; i++) {
        if(this.craft.CraftRecettes[c].Item.id === this.inventory[i].Item.id) {
          this.craft.CraftRecettes[c].inventory = this.inventory[i].quantity
        }
      }
    }
    for (let c = 0; c < this.craft.CraftRecettes.length; c++) {
      if(!this.craft.CraftRecettes[c].inventory || this.craft.CraftRecettes[c].inventory < this.craft.CraftRecettes[c].quantity) {
        this.craftable = false
      }
    }
    this.sidenav.toggle();
  }

  startCraft(item: any){
    if (this.busy) {
      this._snackBar.open("Erreur : Vous êtes déjà occupé.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
    } else {
      if (this.craftable) {
        this.inputQuantity = Math.round(this.inputQuantity)
        if(this.inputQuantity >= 1 && this.inputQuantity <= 100){
          let check = true
          for (let c = 0; c < this.craft.CraftRecettes.length; c++) {
            if(this.craft.CraftRecettes[c].inventory < (this.craft.CraftRecettes[c].quantity*this.inputQuantity)) {
              check = false
            }
          }
          if (check) {
            this.busy = true
            this.craftDuration = item.duration
            this.craftQuantity = this.inputQuantity
            this.craftEvent()
            this.http.post('http://craft/startCraft', JSON.stringify({})).subscribe();
          } else {
            this._snackBar.open("Erreur : Vous n'avez pas suffisamment d'objet pour en fabriquer autant.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
          }
        } else {
          this._snackBar.open("Erreur : Entrez une quantité valide (> 0 et < 100).", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
        }
      } else {
        this._snackBar.open("Erreur : Vous ne pouvez pas fabriquer cet objet.", 'OK', {panelClass: ['error-snackbar'], duration: 5000 });
      }
    }
  }

  stopCraft(){
    this.busy = false
    this.http.post('http://craft/stopCraft', JSON.stringify({})).subscribe();
  }

  craftEvent(){
    if (this.busy && this.craftDuration>0) {
      setTimeout(() => {
        this.craftDuration--
        this.craftEvent()
      }, 995);
    } else if (this.busy && this.craftDuration===0) {
      this.craftRequest()
      if (this.craftQuantity > 1) {
        this.craftQuantity--
        this.craftDuration = this.craft.duration
        this.craftEvent()
      } else {
        this.stopCraft()
      }
    }
  }

  craftRequest() {
    let items: any[] = []
      for (let i = 0; i < this.craft.CraftRecettes.length; i++) {
        let item = {
          itemId: this.craft.CraftRecettes[i].itemId,
          userId: this.cid,
          quantity: -this.craft.CraftRecettes[i].quantity
        }
       items.push(item)
      }
      let item = {
        itemId: this.craft.itemId,
        userId: this.cid,
        quantity: this.craft.quantity
      }
      items.push(item)
      this.characterService.updateCheckInventory(this.cid, items).subscribe((res:any) => {
        if (res) {
          this.http.post('http://craft/notify', JSON.stringify({
            type: "success",
            message: "Vous avez fabriqué "+this.craft.quantity+" x "+this.craft.Item.name+"."
          })).subscribe();
        }
        this.getInventory()
      },
      (err) => {
        console.log(err);
        this.http.post('http://craft/notify', JSON.stringify({
          type: "error",
          message: "Erreur lors de la fabrication de cet item."
        })).subscribe();
      });
  }


  
  @HostListener('window:message', ['$event'])
  onMessage(event: MessageEvent) {
    if(event.data.action ==="setVisible"){
      this.isVisible = event.data.data.show
      if (this.isVisible) {
        this.crafts = []
        this.getCraft(event.data.data.type, event.data.data.organisationId)
        this.getInventory()
      } else {
        this._snackBar.dismiss()
      }
    } else if(event.data.action ==="refresh") {
      localStorage.setItem("cid", String(event.data.cid))
      this.cid = event.data.cid
      localStorage.setItem("organisationId", String(event.data.organisationId))
      this.organisationId = event.data.organisationId
      this.getInventory()
    } else if(event.data.action ==="stop") {
      this.busy = false
    }
  }

  @HostListener('document:click', ['$event'])
  clickout(event: any) {
    if(event.target.tagName==="HTML"){
      this.close()
    }
  }

  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Escape":
        this.close()
        break
    }
  }

  


  close(){
    this._snackBar.dismiss();
    this.isVisible = false
    this.http.post('http://craft/close', JSON.stringify({
      enable: this.isVisible
    })).subscribe();
  }

}
