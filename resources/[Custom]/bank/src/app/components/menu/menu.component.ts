import { Component, OnInit } from '@angular/core';
import { faUniversity, faMoneyBillWave } from '@fortawesome/free-solid-svg-icons';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.scss']
})
export class MenuComponent implements OnInit {
  faUniversity = faUniversity;
  faMoneyBillWave = faMoneyBillWave
  
  constructor() { }

  ngOnInit(): void {
  }

}
