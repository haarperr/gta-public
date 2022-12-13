import { Component, HostListener, Output, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { MatDialog } from '@angular/material/dialog';
import { ModalComponent } from './modal/modal.component';
import { SocketService } from 'src/services/socket.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  isVisible: boolean = false
  uuid?: string
  title: string = 'Menu 13'
  subtitle: string = 'Subtitle'
  footer:string = 'Footer'

  focusedIndex: number = 0
  lastFocusedIndex: number = 0

  sliderIndex: number = 0

  displayList: any
  displayLevel: number = 1
  firstLevel: any = [
    // {
    //   id: 1,
    //   text: "ICI LVL 1",
    //   type: 'submenu',
    //   focused: true,
    //   Items: [
    //     {
    //       id: 1,
    //       text: "ICI LVL 2",
    //       type: 'submenu',
    //       focused: true,
    //       Items: [
    //         {
    //           id: 1,
    //           text: "ICI LVL 3",
    //           type: 'submenu',
    //           focused: true,
    //           Items: [
    //             {
    //               id: 1,
    //               text: "ICI LVL 4",
    //               type: 'action',
    //               focused: false
    //             },
    //             {
    //               id: 2,
    //               text: "Submenu submenu",
    //               type: 'action',
    //               focused: false
    //             },
    //             {
    //               id: 3,
    //               text: "Submenu checkbox 1",
    //               type: 'checkbox',
    //               checked: false,
    //               focused: false
    //             },
    //             {
    //               id: 4,
    //               text: "Submenu checkbox 2",
    //               type: 'checkbox',
    //               checked: true,
    //               focused: false
    //             }
    //           ]
    //         },
    //         {
    //           id: 2,
    //           text: "Submenu submenu",
    //           type: 'action',
    //           focused: false
    //         },
    //         {
    //           id: 3,
    //           text: "Submenu checkbox 1",
    //           type: 'checkbox',
    //           checked: false,
    //           focused: false
    //         },
    //         {
    //           id: 4,
    //           text: "Submenu checkbox 2",
    //           type: 'checkbox',
    //           checked: true,
    //           focused: false
    //         }
    //       ]
    //     },
    //     {
    //       id: 2,
    //       text: "Submenu submenu",
    //       type: 'action',
    //       focused: false
    //     },
    //     {
    //       id: 3,
    //       text: "Submenu checkbox 1",
    //       type: 'checkbox',
    //       checked: false,
    //       focused: false
    //     },
    //     {
    //       id: 4,
    //       text: "Submenu checkbox 2",
    //       type: 'checkbox',
    //       checked: true,
    //       focused: false
    //     }
    //   ]
    // },
    // {
    //   id: 2,
    //   text: "Grocery shopping",
    //   type: 'action',
    //   focused: false
    // },
    // {
    //   id: 3,
    //   text: "Clean gecko tank",
    //   type: 'submenu',
    //   focused: false,
    //   Items: [
    //     {
    //       id: 1,
    //       text: "Submenu action 1",
    //       type: 'action',
    //       focused: false
    //     },
    //     {
    //       id: 2,
    //       text: "Submenu submenu",
    //       type: 'action',
    //       focused: false
    //     },
    //     {
    //       id: 3,
    //       text: "Submenu checkbox 1",
    //       type: 'checkbox',
    //       checked: false,
    //       focused: false
    //     },
    //     {
    //       id: 4,
    //       text: "Submenu checkbox 2",
    //       type: 'checkbox',
    //       checked: true,
    //       focused: false
    //     }
    //   ]
    // },
    // {
    //   id: 4,
    //   text: "Mow lawn",
    //   type: 'checkbox',
    //   checked: false,
    //   focused: false
    // },
    // {
    //   id: 5,
    //   text: "Catch up on Arrested",
    //   type: 'checkbox',
    //   checked: true,
    //   focused: false
    // },
    // {
    //   id: 6,
    //   text: "Slider",
    //   type: 'slider',
    //   focused: false,
    //   value: 0,
    //   list: [
    //     "Moteur modif 5",
    //     "2",
    //     "3",
    //     "4",
    //     "5",
    //   ]
    // },
    // {
    //   id: 7,
    //   text: "Slider",
    //   type: 'slider',
    //   focused: false,
    //   value: 0,
    //   list: [
    //     "Moteur modif 5",
    //     "2",
    //     "3",
    //     "4",
    //     "5",
    //   ]
    // }
  ]
  firstLevelIndex: number = 0
  secondLevel: any
  secondLevelIndex: number = 0
  thirdLevel: any
  thirdLevelIndex: number = 0
  fourthLevel: any
  type: any;
  parentType: any;
  parent: any;


  constructor(
    private http: HttpClient,
    public dialog: MatDialog,
    private srv: SocketService,
  ) {
    this.displayList = this.firstLevel
  }

  ngOnInit(){
  }

  @HostListener('window:message', ['$event'])
  onMessage(event: MessageEvent) {
    if(event.data.action ==="setVisible"){
      this.isVisible = event.data.data
      if(this.isVisible===false){
        this.dialog.closeAll()
      }
    } else if(event.data.action ==="sendMenu") {
      this.constructSubmenu(event.data.data)
      // this.uuid = event.data.data.uuid
      // this.title = event.data.data.title
      // this.subtitle = event.data.data.subtitle
      // this.footer = event.data.data.footer      
      // this.firstLevel = event.data.data.Items
      // for (let i = 0; i < this.firstLevel.length; i++) {
      //   this.firstLevel[i].focused = false        
      // }
      // this.firstLevel[0] ? this.firstLevel[0].focused = true : null;
      // this.displayList = this.firstLevel
      // this.focusedIndex = 0
      // this.lastFocusedIndex = 0
      // this.sliderIndex = 0
      // this.displayLevel = 1
      // this.firstLevelIndex = 0
      // this.secondLevelIndex = 0
      // this.thirdLevelIndex = 0
    }
  }


  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Escape":
      case "Backspace":
      case "ArrowLeft":
        if (this.displayList[this.focusedIndex] && this.displayList[this.focusedIndex].type==="slider") {
          this.displayList[this.focusedIndex].value === 0 ? this.displayList[this.focusedIndex].value = this.displayList[this.focusedIndex].list.length-1 : this.displayList[this.focusedIndex].value--;
        } else {
          if (this.type==="menu") {
            this.dialog.closeAll();
            this.isVisible = false;
            await this.http.post('http://menu/close', {}).toPromise();
          } else if (this.type==="submenu") {
            if (this.parentType==="menu") {
              await this.http.post('http://menu/requestMenu', {uuid: this.parent}).subscribe(menu => {
                if(menu){
                  this.constructSubmenu(menu)
                }
              });
            } else if (this.parentType==="submenu") {
              await this.http.post('http://menu/requestSubmenu', {uuid: this.parent}).subscribe(menu => {
                if(menu){
                  this.constructSubmenu(menu)
                }
              });
            }
          //   this.displayLevel = 1
          //   this.displayList = this.firstLevel
          //   this.focusedIndex = this.firstLevelIndex
          // } else if (this.displayLevel===3) {
          //   this.displayLevel = 2
          //   this.displayList = this.secondLevel
          //   this.focusedIndex = this.secondLevelIndex
          // } else {
          //   this.displayLevel = 3
          //   this.displayList = this.thirdLevel
          //   this.focusedIndex = this.thirdLevelIndex
          }
          let el = document.getElementById(String(this.focusedIndex));
          el?.scrollIntoView({ behavior: 'auto', block: "center" });
          
        }
        await this.http.post('http://menu/sound', {type: "BACK"}).subscribe();
        break
      case "ArrowUp":
        if (this.displayList) {
          if (this.displayList[0] && this.focusedIndex!=-1) {
            if (this.focusedIndex!=0) {
              this.lastFocusedIndex = this.focusedIndex        
              this.focusedIndex = this.focusedIndex-1
              this.displayList[this.lastFocusedIndex].focused = false
              this.displayList[this.focusedIndex].focused = true
              let el = document.getElementById(String(this.focusedIndex));
              el?.scrollIntoView({ behavior: 'auto', block: "center" });
            } else if(this.focusedIndex===0 && this.displayList.length > 1) {
              this.lastFocusedIndex = this.focusedIndex        
              this.focusedIndex = this.displayList.length-1
              this.displayList[this.lastFocusedIndex].focused = false
              this.displayList[this.focusedIndex].focused = true
              let el = document.getElementById(String(this.focusedIndex));
              el?.scrollIntoView({ behavior: 'auto', block: "center" });
            }
          }
          await this.http.post('http://menu/sound', {type: "NAV_UP_DOWN"}).subscribe();
        }
        break
      case "ArrowDown":
        if (this.displayList) {
          if (this.displayList[0] && this.focusedIndex+1!=this.displayList.length) {
            this.lastFocusedIndex = this.focusedIndex        
            this.focusedIndex++
            this.displayList[this.lastFocusedIndex].focused = false
            this.displayList[this.focusedIndex].focused = true
            let el = document.getElementById(String(this.focusedIndex));
            el?.scrollIntoView({ behavior: 'auto', block: "center" });
          } else if(this.focusedIndex===this.displayList.length-1 && this.displayList.length > 1) {
            this.lastFocusedIndex = this.focusedIndex        
            this.focusedIndex = 0
            this.displayList[this.lastFocusedIndex].focused = false
            this.displayList[this.focusedIndex].focused = true
            let el = document.getElementById(String(this.focusedIndex));
            el?.scrollIntoView({ behavior: 'auto', block: "center" });
          }
          await this.http.post('http://menu/sound', {type: "NAV_UP_DOWN"}).subscribe();
        }
        break
      case "ArrowRight":
        switch (this.displayList[this.focusedIndex].type) {
          case "checkbox":
            this.displayList[this.focusedIndex].checked = !this.displayList[this.focusedIndex].checked
            await this.http.post('http://menu/triggerItem', {type: this.type, menu : this.uuid, item : this.displayList[this.focusedIndex]}).subscribe();
            break;
          case "action":
            await this.http.post('http://menu/triggerItem', {type: this.type, menu : this.uuid, item : this.displayList[this.focusedIndex]}).subscribe();
            break;
          case "slider":
            this.displayList[this.focusedIndex].value === this.displayList[this.focusedIndex].list.length-1 ? this.displayList[this.focusedIndex].value = 0 : this.displayList[this.focusedIndex].value++;
            await this.http.post('http://menu/triggerItem', {type: this.type, menu : this.uuid, item : this.displayList[this.focusedIndex]}).subscribe();
            break;
          case "submenu":
            await this.http.post('http://menu/requestSubmenu', {uuid:this.displayList[this.focusedIndex].uuid}).subscribe(menu => {
              if(menu){
                this.constructSubmenu(menu)
              }
            });
            break;
          }
        await this.http.post('http://menu/sound', {type: "SELECT"}).subscribe();
        break
      case "Enter":
        switch (this.displayList[this.focusedIndex].type) {
          case "checkbox":
            this.displayList[this.focusedIndex].checked = !this.displayList[this.focusedIndex].checked
            await this.http.post('http://menu/triggerItem', {type: this.type, menu : this.uuid, item : this.displayList[this.focusedIndex]}).subscribe();
            break;
          case "action":
            await this.http.post('http://menu/triggerItem', {type: this.type, menu : this.uuid, item : this.displayList[this.focusedIndex]}).subscribe();
            break;
          case "slider": 
            await this.http.post('http://menu/triggerItem', {type: this.type, menu : this.uuid, item : this.displayList[this.focusedIndex]}).subscribe();
            break
          case "submenu":
            await this.http.post('http://menu/requestSubmenu', {uuid:this.displayList[this.focusedIndex].uuid}).subscribe(menu => {
              if(menu){
                this.constructSubmenu(menu)
              }
            });
            break;
          }
        await this.http.post('http://menu/sound', {type: "SELECT"}).subscribe();
        break
    }
  }

  constructSubmenu(menu: any){
    this.uuid = menu.uuid
    this.title = menu.title
    this.subtitle = menu.subtitle
    this.footer = menu.footer   
    this.type = menu.type   
    this.parentType = menu.parentType   
    this.parent = menu.parent   
    this.firstLevel = menu.Items
    for (let i = 0; i < this.firstLevel.length; i++) {
      this.firstLevel[i].focused = false        
    }
    this.firstLevel[0] ? this.firstLevel[0].focused = true : null;
    this.displayList = this.firstLevel
    this.focusedIndex = 0
    this.lastFocusedIndex = 0
    this.sliderIndex = 0
    // if (this.displayLevel===1) {
    //   this.secondLevel = this.firstLevel[this.focusedIndex].Items
    //   this.firstLevelIndex = this.focusedIndex
    //   this.displayLevel = 2
    //   this.displayList = this.secondLevel
    // } else if (this.displayLevel===2) {
    //   this.thirdLevel = this.secondLevel[this.focusedIndex].Items
    //   this.secondLevelIndex = this.focusedIndex
    //   this.displayLevel = 3
    //   this.displayList = this.thirdLevel
    // } else if (this.displayLevel===3) {
    //   this.fourthLevel = this.thirdLevel[this.focusedIndex].Items
    //   this.thirdLevelIndex = this.focusedIndex
    //   this.displayLevel = 4
    //   this.displayList = this.fourthLevel
    // }
    
    // let check = true
    // for (let i = 0; i < this.displayList.length; i++) {
    //   if(this.displayList[i].focused){
    //     check = false
    //     this.focusedIndex = i
    //     this.lastFocusedIndex = i
    //     break
    //   }
    // }
    // if(check){
    //   this.displayList[0].focused = true
    //   this.focusedIndex = 0
    //   this.lastFocusedIndex = 0
    // }
  }



}

