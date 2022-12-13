import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.scss']
})
export class MenuComponent implements OnInit {

  logo: string

  constructor() {
    let organisationId = Number(localStorage.getItem("organisationId"))
    if(organisationId > 4){
      this.logo = "turtlecrimi"
    } else {
      this.logo = "turtle"
    }
  }

  ngOnInit(): void {
  }

}
