import { Component, HostListener, OnInit, ViewChild } from '@angular/core';
import { trigger, state, style, animate, transition, } from '@angular/animations';
import { ActivatedRoute, Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MessageService } from '../../services/message.service';
import { SocketService } from '../../services/socket.service';
import { MatDialog } from '@angular/material/dialog';
import { ModalComponent } from '../modal/modal.component';

@Component({
  selector: 'app-msg',
  templateUrl: './msg.component.html',
  styleUrls: ['./msg.component.scss'],
  animations: [
  ]
})
export class MsgComponent implements OnInit {

  loading: boolean = false;
  messages: any[] = [];

  lastFocusedIndex: number = 0;
  focusedIndex: number = 0;
  phoneNumber: any = 0;
  actions : any[] = []
  menuAction: boolean = false
  modal: boolean = false;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private http: HttpClient,
    private msgService: MessageService,
    public dialog: MatDialog,
    private srv: SocketService
    ) { 
      this.phoneNumber = Number(localStorage.getItem("phone"))
      this.getMessages()
      this.srv.listen('sendMsg'+this.phoneNumber).subscribe((res:any)=>{
        if(res.data){
          this.getMessages()
        }
      })
    }

  ngOnInit() {
  }

  getMessages() {
    this.loading = true
    this.msgService.getAll(this.phoneNumber).subscribe(msgs => {
      if (msgs[0]) {
        console.log(msgs);
        
        for (let i = 0; i < msgs.length; i++) {
          i === 0 ? msgs[i].focused = true : msgs[i].focused = false
        }
        this.messages = msgs
      } else {
        this.lastFocusedIndex = -1;
        this.focusedIndex = -1;
      }
      this.loading = false        
    })
  }

  changeRoute(){
    for (let i = 0; i < this.messages.length; i++) {
      const element = this.messages[i];
      let route 
      element.from.phone == this.phoneNumber ? route = element.to.phone : route = element.from.phone;
      if (element.focused===true) {
        this.router.navigate(['/message/from/'+route], {state: {id: route}, relativeTo: this.route });
      }
    }
  }


  @HostListener('window:message', ['$event'])
  onMessage(event: MessageEvent) {
    if(event.data.messages){
      for (let i = 0; i < event.data.messages.length; i++) {
        const ele = event.data.messages[i];
        if (i===0) {
          ele.focused = true
        } else {
          ele.focused = false
        }
        ele.text = ele.content
        this.messages.push(ele)
      }
    }
  }

  @ViewChild('listmessages') myDiv: any;
  
  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Backspace":
        if (this.menuAction) {
          this.menuAction = false
        } else {
          this.router.navigate(['/home'], { relativeTo: this.route });
        }
        break
      case "ArrowUp":
        if (this.menuAction) {
          if(this.actions[0].focused) {
            this.actions[0].focused = false 
            this.actions[1].focused = true 
          } else {
            this.actions[0].focused = true
            this.actions[1].focused = false
          }
        } else {
          if (this.messages && this.messages[0]) {
            if (this.focusedIndex-1!=-2) {
              if (this.focusedIndex-1==-1) {
                this.messages[0].focused = false
                this.focusedIndex = -1
              } else {
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
        if (this.menuAction) {
          if(this.actions[0].focused) {
            this.actions[0].focused = false 
            this.actions[1].focused = true 
          } else {
            this.actions[0].focused = true
            this.actions[1].focused = false
          }
        } else {
          if (this.messages && this.messages[0]) {
            if (this.focusedIndex+1!=this.messages.length) {
              if (this.focusedIndex==-1) {
                this.focusedIndex=0
                this.lastFocusedIndex=0
                this.messages[this.focusedIndex].focused = true
              } else {
                this.lastFocusedIndex = this.focusedIndex        
                this.focusedIndex++
                this.messages[this.lastFocusedIndex].focused = false
                this.messages[this.focusedIndex].focused = true
              }
            }
            let el = document.getElementById(String(this.focusedIndex));
            el?.scrollIntoView({ behavior: 'auto', block: "center" });
          }
        }
        break;
      case "Enter":
        if (this.focusedIndex>=0) {
          this.changeRoute()          
        } else if(this.focusedIndex===-1 && !this.menuAction){
          this.menuAction = true
          this.actions = [{focused: true, text: "Depuis contact"}, {focused: false, text: "Depuis numéro"}]
        } else if(this.menuAction){
          if (this.actions[0].focused) {
            this.router.navigate(['/contact'], { relativeTo: this.route });
          } else if (this.actions[1].focused && !this.modal) {
            this.modal = true
            this.openDialog({maxLength: 4})
          }
        }
        break
    }
  }

  openDialog(data: any): void {
    const dialogRef = this.dialog.open(ModalComponent, {
      data: data,
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        if (!isNaN(parseFloat(result)) && !isNaN(result - 0) && result.length == 4 && result > 1100 && result < 9999) {
          this.router.navigate(['/message/from/'+result], { relativeTo: this.route });
          setTimeout(async() => {
            this.modal = false
            
            await this.http.post('http://phone/inputs', JSON.stringify({
              enable: true
            })).toPromise();
          }, 100);
        } else {
          this.modal = false
        }
      }
    });
  }

}
