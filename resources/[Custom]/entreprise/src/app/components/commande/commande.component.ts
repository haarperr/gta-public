import { HttpClient } from '@angular/common/http';
import { Component, OnInit, ViewChild } from '@angular/core';
import { MatStepper } from '@angular/material/stepper';
import { ActivatedRoute, Router } from '@angular/router';
import { BasketService } from 'src/app/services/basket.service';
import { CommandeService } from 'src/app/services/commande.service';
import { CharacterService } from '../../services/character.service';

@Component({
  selector: 'app-commande',
  templateUrl: './commande.component.html',
  styleUrls: ['./commande.component.scss']
})
export class CommandeComponent implements OnInit {

  type: string = "none"
  step: string = "none"
  payementLoading: boolean = false
  payementConfirm: boolean = false
  payementError: boolean = false
  activeShipping: boolean = false
  details: any
  basket: any
  totalBasket: any
  commande: any
  cid: number;
  organisationId: number;
  
  @ViewChild('stepper') stepper!: MatStepper ;

  constructor(
    private router: Router,
    private characterService: CharacterService,
    private route: ActivatedRoute,
    private orderService: CommandeService,
    private basketService: BasketService,
    private http: HttpClient,
    ) {
    if(this.router.url.startsWith('/commandes/create')) {
      this.type = "create"
      this.basket = this.basketService.getBasket()
      let total = 0
      for (let i = 0; i < this.basket.length; i++) {
        total += (this.basket[i].quantity * this.basket[i].buyPrice);
      }
      this.totalBasket = total
    }
    this.cid = Number(localStorage.getItem("cid"))
    this.organisationId = Number(localStorage.getItem("organisationId"))
  }

  ngOnInit(): void {
  }

  ngAfterViewInit(){
    let commandeId = Number(this.route.snapshot.paramMap.get('id'))
    if(commandeId){
      this.orderService.getOne(commandeId).subscribe(res => {
        if(res){
          this.commande = res
          if (this.commande.statut==="payment") {
            this.stepper.next()
          } else if (this.commande.statut==="shipping" || this.commande.statut==="shipped") {
            if (this.commande.statut==="shipping") {
              this.checkActiveShipping()
            }
            this.stepper.next()
            this.stepper.next()
          } else if (this.commande.statut==="done") {
            this.stepper.next()
            this.stepper.next()
            this.stepper.next()
          }
        }
      })
    }
  }

  checkActiveShipping(){
    this.orderService.getAll().subscribe(res => {
      if(res.length>0){
        for (let i = 0; i < res.length; i++) {
          if(res[i].statut==="shipped"){
            this.activeShipping = true
            return
          }
        }
      }
      this.activeShipping = false
    })
  }

  confirm(){
    if(this.type==="create" && this.basket) {
      let order: any = {
        characterId : this.cid,
        organisationId : this.organisationId,
        price: this.totalBasket,
        details: this.details,
        statut : "payment", 
        total: this.totalBasket,
        CommandeContents: []
      }
      for (let i = 0; i < this.basket.length; i++) {
        let content = {
          itemId: this.basket[i].id,
          quantity: this.basket[i].quantity,
          price: this.basket[i].buyPrice
        }
        order.CommandeContents.push(content)      
      }
      
      this.orderService.create(order).subscribe(res => {
        if(res){
          this.basketService.flush()
          this.router.navigate(['/commandes/'+res.id], { relativeTo: this.route })
        }
      })
    } else {
      // UDATE
    }
  }

  payer(type: string){
    this.payementLoading = true
    setTimeout(() => {
      this.characterService.getCharacter(this.cid).subscribe(res => {
        if(res){
          if (type==='cb') {
            if (res.bank >= this.commande.total) {
              let c = {
                id: res.id,
                bank: (res.bank - this.commande.total)
              }
              this.characterService.updateCharacter(this.cid, c).subscribe(r => {
                let cUpdate = {
                  id: this.commande.id,
                  statut: "shipping"
                }
                this.orderService.update(this.commande.id, cUpdate).subscribe(re => {
                  r ? this.payementConfirm = true : this.payementError = true;
                  this.payementLoading = false
                  this.commande.statut = "shipping"
                  this.checkActiveShipping()
                })
              })
            } else {
              this.payementError = true
              this.payementLoading = false
            }
          } else {
            if (res.cash >= this.commande.total) {
              let c = {
                id: res.id,
                cash: (res.cash - this.commande.total)
              }
              this.characterService.updateCharacter(this.cid, c).subscribe(r => {
                let cUpdate = {
                  id: this.commande.id,
                  statut: "shipping"
                }
                this.orderService.update(this.commande.id, cUpdate).subscribe(re => {
                  re ? this.payementConfirm = true : this.payementError = true;
                  this.payementLoading = false
                  this.commande.statut = "shipping"
                  this.checkActiveShipping()
                })
              })
            } else {
              this.payementError = true
              this.payementLoading = false
            }
          }
        } else {
          this.payementError = true
          this.payementLoading = false
        }
      })
    }, 2000);
  }


  startLivraison(){
    this.orderService.getAll().subscribe(res => {
      if(res.length>0){
        for (let i = 0; i < res.length; i++) {
          if(res[i].statut==="shipped"){
            this.activeShipping = true
            return
          }
        }
      }
      let cUpdate = {
        id: this.commande.id,
        statut: "shipped"
      }
      this.orderService.update(this.commande.id, cUpdate).subscribe(async re => {
        await this.http.post('http://entreprise/triggerServerEvent', {name: "createCrate", data: this.commande.id, data2: this.commande}).subscribe(r => {});
        this.commande.statut = "shipped"
      })      
    })
    
  }

  getLivraisonCoords(){}


}
