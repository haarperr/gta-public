import { Component, HostListener, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CharacterService } from '../../services/character.service';

@Component({
  selector: 'app-bank',
  templateUrl: './bank.component.html',
  styleUrls: ['./bank.component.scss']
})
export class BankComponent implements OnInit {

  bank: number = 0
  cid?: number;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private bankService: CharacterService
  ) {}

  ngOnInit(): void {
    this.cid = Number(localStorage.getItem("cid"))
    this.bankService.getCharacter(this.cid).subscribe(c => {
      if (c) this.bank = c.bank
    })
  }

  

  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Backspace":
        this.router.navigate(['/home'], { relativeTo: this.route });
        break
    }
  }

}
