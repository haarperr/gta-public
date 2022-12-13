import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { faArrowLeft, faArrowRight, faHandHoldingUsd, faMoneyBillWave, faUniversity, faWallet } from '@fortawesome/free-solid-svg-icons';
import { CharacterService } from 'src/app/services/character.service';

@Component({
  selector: 'app-atm',
  templateUrl: './atm.component.html',
  styleUrls: ['./atm.component.scss']
})
export class AtmComponent implements OnInit {
  faUniversity = faUniversity
  faWallet = faWallet
  faArrowLeft = faArrowLeft
  faArrowRight = faArrowRight
  faHandHoldingUsd = faHandHoldingUsd
  faMoneyBillWave = faMoneyBillWave

  cid?: number;

  cash!: number;
  bank!: number;
  input: number = 0
  notif: any

  
  constructor(
    private http: HttpClient,
    private cService: CharacterService,
  ) {
    this.cid = Number(localStorage.getItem("cid"))
    this.cash = this.cService.getCash()
    this.bank = this.cService.getBank()
  }

  ngOnInit(): void {
  }

  async retrait(q: number, r: boolean) {
    if (this.cid) {
      if (q === 0) {
        await this.http.post("http://bank/notify", {type:'error',title:"ATM",text:"Précisez une somme à retirer."}).subscribe();
        return
      }
      if (q>this.bank && q>0) {
        await this.http.post("http://bank/notify", {type:'error',title:"ATM",text:"Vous n'avez pas assez d'argent !"}).subscribe();
      } else {
        this.cash = this.cash + q
        this.bank = this.bank - q
        this.cService.updateCharacter(this.cid, {id: this.cid, cash: this.cash, bank: this.bank}).subscribe(r => {
          this.cService.setCash(this.cash)
          this.cService.setBank(this.bank)
          this.http.post("http://bank/notify", {type:'success',title:"ATM",text:"Vous avez retiré $"+q}).subscribe();
          this.http.post('http://inventory/triggerEvent', {name: "updateCashInventaire", data: this.cash}).subscribe();
        })
      }
      if (r) {
        this.input = 0
      }
    }
    
  }

  async depot(q: number, r: boolean) {
    if (this.cid) {
      if (q === 0) {
        await this.http.post("http://bank/notify", {type:'error',title:"ATM",text:"Précisez une somme à déposer."}).subscribe();
        return
      }
      if (q>this.cash && q>0) {
        await this.http.post("http://bank/notify", {type:'error',title:"ATM",text:"Vous n'avez pas assez d'argent !"}).subscribe();
      } else {
        this.cash = this.cash - q
        this.bank = this.bank + q
        this.cService.updateCharacter(this.cid, {id: this.cid, cash: this.cash, bank: this.bank}).subscribe(r => {
          this.cService.setCash(this.cash)
          this.cService.setBank(this.bank)
            this.http.post("http://bank/notify", {type:'success',title:"ATM",text:"Vous avez déposé $"+q}).subscribe();
            this.http.post('http://inventory/triggerEvent', {name: "updateCashInventaire", data: this.cash}).subscribe();
          })
        }
      if (r) {
        this.input = 0
      }
    }
  }


}
