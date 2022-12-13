import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { CharacterService } from 'src/app/services/character.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  
  cash?: number;
  bank?: number;
  cid: number = null!;

  constructor(
    private cService: CharacterService,
    private http: HttpClient
  ) {
    this.cid = Number(localStorage.getItem("cid"))
    if (this.cid) {
      // this.cService.getCharacter(this.cid).subscribe(c => {
      //   if (c) {
      //     this.cash = c.cash
      //     this.bank = c.bank        
      //   }
      // })
    }
  }

  async triggerEvent(name: string, data?: any){
    await this.http.post('http://entreprise/triggerEvent', {name: name, data: data}).subscribe(r => {});
  }
  async triggerServerEvent(name: string, data?: any, data2?: any){
    await this.http.post('http://entreprise/triggerServerEvent', {name: name, data: data, data2: data2}).subscribe(r => {});
  }
  async triggerFunction(name: string, data?: any){
    await this.http.post('http://entreprise/triggerFunction', {name: name, data: data}).subscribe(r => {});
  }

  ngOnInit(): void {
  }

}
