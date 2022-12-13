import { animate, state, style, transition, trigger } from '@angular/animations';
import { HttpClient } from '@angular/common/http';
import { Component, HostListener } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';
import { BasketService } from './services/basket.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  isVisible : boolean = false;
  basket: any
  
  constructor(
    private http: HttpClient,
    private router: Router,
    private BasketService: BasketService,
    private _snackBar: MatSnackBar,
    ) {
    this.BasketService.watchBasket().subscribe((c: number) => {
      this.basket = c
    })
    // localStorage.setItem("cid", "1")

  }

  ngOnInit(): void {
    // localStorage.setItem("cid", "1")
  }

  refreshBasketNumber(){
    this.basket = JSON.parse(localStorage.getItem("basket")!)
  }

  
  @HostListener('window:message', ['$event'])
  onMessage(event: MessageEvent) {
    if(event.data.action ==="setVisible"){
      this.isVisible = event.data.data
      if (this.isVisible) {
        this.router.navigate(['/home']);
        // event.data.cid ? localStorage.setItem("cid", String(event.data.cid)) : null ;
      } else {
        this._snackBar.dismiss()
      }
    } else if(event.data.action ==="refresh") {
      localStorage.setItem("cid", String(event.data.cid))
      localStorage.setItem("organisationId", String(event.data.organisationId))
    }
  }

  @HostListener('window:keydown', ['$event'])
  keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Escape":
        this._snackBar.dismiss();
        this.isVisible = false;
        this.http.post('http://entreprise/close', {}).subscribe();
        break
    }
  }

  
  @HostListener('document:click', ['$event'])
  clickout(event: any) {
    if(event.target.tagName==="HTML"){
      this.close()
    }
  }

  close(){
    this._snackBar.dismiss();
    this.isVisible = false
    this.http.post('http://entreprise/close', JSON.stringify({
      enable: this.isVisible
    })).subscribe();;
  }

}
