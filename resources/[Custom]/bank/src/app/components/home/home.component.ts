import { Component, OnInit } from '@angular/core';
import { faUniversity, faWallet } from '@fortawesome/free-solid-svg-icons';
import { CharacterService } from 'src/app/services/character.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  faUniversity = faUniversity
  faWallet = faWallet
  cash?: number;
  bank?: number;
  cid: number = null!;

  constructor(
    private cService: CharacterService
  ) {
    this.cash = this.cService.getCash()
    this.bank = this.cService.getBank()
  }

  ngOnInit(): void {
  }

}
