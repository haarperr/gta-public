import { Component, HostListener, OnInit } from '@angular/core';
import {Location} from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { MessageService } from 'src/app/services/message.service';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-messageriepro',
  templateUrl: './messageriepro.component.html',
  styleUrls: ['./messageriepro.component.scss']
})
export class MessagerieproComponent implements OnInit {

  focusedIndex: number = 0
  lastFocusedIndex: number = 0
  messages: any;
  loading: boolean = false;
  organisationId: number;
  menuAction: any;

  constructor(
    private _location: Location,
    private route: ActivatedRoute,
    private msgService: MessageService,
    private http: HttpClient,
  ) {
    this.organisationId = Number(this.route.snapshot.paramMap.get('id'))
    this.msgService.getAllEntreprise(this.organisationId).subscribe(msgs => {
      if (msgs[0]) {
        this.messages = msgs
        for (let i = 0; i < this.messages.length; i++) {
          this.messages[i].focused = false;          
        }
        this.messages[0].focused = true        
      }
    })
  }

  ngOnInit(): void {
  }

  
  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Backspace":
        if (this.menuAction) {
          this.menuAction = false
        } else {
          this._location.back();
        }
        break
      case "ArrowUp":
        if (!this.menuAction) {
          if (this.messages) {
            if (this.messages[0] && this.focusedIndex!=-1) {
              if (this.focusedIndex!=0) {
                this.lastFocusedIndex = this.focusedIndex        
                this.focusedIndex = this.focusedIndex-1
                this.messages[this.lastFocusedIndex].focused = false
                this.messages[this.focusedIndex].focused = true
                let el = document.getElementById(String(this.focusedIndex));
                el?.scrollIntoView({ behavior: 'auto', block: "center" });
              }
            }
          }
        }
        break;
      case "ArrowDown":
        if (!this.menuAction) {
          if (this.messages) {
            if (this.messages[0] && this.focusedIndex+1!=this.messages.length) {
              this.lastFocusedIndex = this.focusedIndex        
              this.focusedIndex++
              this.messages[this.lastFocusedIndex].focused = false
              this.messages[this.focusedIndex].focused = true
              let el = document.getElementById(String(this.focusedIndex));
              el?.scrollIntoView({ behavior: 'auto', block: "center" });
            }
          }
        }
        break;
      case "Enter":
        if (this.focusedIndex>-1 && !this.menuAction) {
          this.menuAction = true
        } else if (this.menuAction) {
          this.msgService.getSeenOne(this.messages[this.focusedIndex].id).subscribe(async res => {
            if(res){
              this.messages[this.focusedIndex].unseen = 0
              if (this.messages[this.focusedIndex].x) {
                await this.http.post('http://phone/setGPS', JSON.stringify(this.messages[this.focusedIndex])).toPromise();
              }
            }
          })
          this.menuAction = false
        }
        break
    }
  }


}
