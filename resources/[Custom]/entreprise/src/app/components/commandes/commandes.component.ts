import { Component, OnInit } from '@angular/core';
import { CommandeService } from 'src/app/services/commande.service';

@Component({
  selector: 'app-commandes',
  templateUrl: './commandes.component.html',
  styleUrls: ['./commandes.component.scss']
})
export class CommandesComponent implements OnInit {
  commandes: any;

  constructor(
    private orderService: CommandeService,
  ) {
    this.orderService.getAll().subscribe(res => {
      this.commandes = res
    })
  }

  ngOnInit(): void {
  }

}
