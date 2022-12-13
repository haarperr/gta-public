import { HttpClient } from '@angular/common/http';
import { Component, HostListener, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { PreviousRouteService } from 'src/services/previous-route.service';
import { ModalComponent } from '../modal/modal.component';
import { ContactService } from '../../services/contact.service';
import {Location} from '@angular/common';

@Component({
  selector: 'app-contact',
  templateUrl: './contact.component.html',
  styleUrls: ['./contact.component.scss']
})
export class ContactComponent implements OnInit {
  focusedIndex: number = 0
  lastFocusedIndex: number = 0
  contacts: any;
  loading: boolean = false;
  actions: number = 0;
  menuAction: boolean = false
  cid: number = 0;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private http: HttpClient,
    private _location: Location,
    private contactService: ContactService
  ) {
  }

  ngOnInit(): void {
    this.cid = Number(localStorage.getItem("cid"))
    this.getContacts()
  }

  getContacts() {
    this.loading = true
    this.contactService.getAll(this.cid).subscribe(contacts => {
      if (contacts[0]) {
        for (let i = 0; i < contacts.length; i++) {
          i === 0 ? contacts[i].focused = true : contacts[i].focused = false
        }
        this.focusedIndex = 0
        this.lastFocusedIndex = 0
        this.contacts = contacts
        this.loading = false
      } else {
        this.loading = false
        this.focusedIndex = -1
      }
    })
  }


  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Backspace":
        if (this.menuAction) {
          this.menuAction = false
        } else {
          this.router.navigate(['/home']);
        }
        break
      case "ArrowUp":
        if (this.menuAction) {
          if(this.actions>0) {
            this.actions = this.actions -1
          }
        } else {
          if (this.contacts) {
            if (this.contacts[0] && this.focusedIndex!=-1) {
              if (this.focusedIndex==0) {
                this.contacts[0].focused = false
                this.focusedIndex = -1
              } else {
                this.lastFocusedIndex = this.focusedIndex        
                this.focusedIndex = this.focusedIndex-1
                this.contacts[this.lastFocusedIndex].focused = false
                this.contacts[this.focusedIndex].focused = true
                let el = document.getElementById(String(this.focusedIndex));
                el?.scrollIntoView({ behavior: 'auto', block: "center" });
              }
            }
          }
        }
        break;
      case "ArrowDown":
        if (this.menuAction) {
          if(this.actions<3){
            this.actions ++
          }
        } else {
          if (this.contacts) {
            if (this.contacts[0] && this.focusedIndex+1!=this.contacts.length) {
              if (this.focusedIndex==-1) {
                this.focusedIndex=0
                this.lastFocusedIndex=0
                this.contacts[this.focusedIndex].focused = true
              } else {
                this.lastFocusedIndex = this.focusedIndex        
                this.focusedIndex++
                this.contacts[this.lastFocusedIndex].focused = false
                this.contacts[this.focusedIndex].focused = true
                let el = document.getElementById(String(this.focusedIndex));
                el?.scrollIntoView({ behavior: 'auto', block: "center" });
              }
            }
          }
        }
        break;
      case "Enter":
        if (this.focusedIndex>-1 && !this.menuAction) {
          this.menuAction = true
          this.actions = 0
        } else if (this.menuAction) {
          if (this.actions === 0) { // APPEL
            this.router.navigate(['/appel/create/'+this.contacts[this.focusedIndex].phone], { relativeTo: this.route });
          } else if (this.actions === 1) { // MESSAGE
            this.router.navigate(['/message/from/'+this.contacts[this.focusedIndex].phone], { relativeTo: this.route });
          } else if (this.actions === 2) { // EDIT
            this.router.navigate(['/contact/edit/'+this.contacts[this.focusedIndex].id], { relativeTo: this.route });
          } else if (this.actions === 3){ // DELETE
            this.contactService.delete(this.contacts[this.focusedIndex].id).subscribe(d=> {
              if (d) {
                this.contacts[this.focusedIndex].focused = false                
                this.menuAction = false
                this.getContacts()
              }
            })
          }
        } else {
          this.router.navigate(['/contact/add'], { relativeTo: this.route });
        }
        break
    }
  }
}






























// ################################################################################### 
//  CONTACT FORM
// ###################################################################################




@Component({
  selector: 'app-contact-form',
  templateUrl: './contact-form.component.html',
  styleUrls: ['./contact.component.scss']
})
export class ContactFormComponent implements OnInit {

  contact: any;
  action: string = null!;
  focused: number = 0;
  modal: boolean = false;
  cid?: number;
  error: string = null!;
  success?: string;

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private contactService: ContactService,
    private http: HttpClient,
    public dialog: MatDialog,
    private previousRouteService: PreviousRouteService,
    private _location: Location,
  ){
    this.cid = Number(localStorage.getItem("cid"))
    this.contact = {}
    this.contact.name = ""
    this.contact.phone = ""
    if (this.previousRouteService.getPreviousUrl() === '/contact/add' && this.router.url.startsWith('/contact/edit/')) {
      this.success = "Contact créé avec succès"
    }
  }

  ngOnInit(){
    if(this.router.url.startsWith('/contact/add')){
      this.action = 'Nouveau contact'
    } else if(this.router.url.startsWith('/contact/edit/')){
      this.action = 'Modifier contact'
      this.contactService.getOne(this.route.snapshot.paramMap.get('id')).subscribe(c => {
        if (c) {
          this.contact = c          
        } else {
          this.router.navigate(['/contact']);
        }
      })
    }
  }



  @HostListener('window:keydown', ['$event'])
  async keyEvent(event: KeyboardEvent) {
    switch (event.code) {
      case "Backspace":
        
        if(!this.modal) this.router.navigate(['/contact']);
        break
      case "ArrowUp":
        if (this.focused>0) {
          this.focused = this.focused -1
        }
        break;
      case "ArrowDown":
        if (this.action === 'Modifier contact' && this.focused<3) {
          this.focused++
        } else if (this.focused<2) {
          this.focused++
        }
        break;
      case "Enter":
        if (this.modal===false) {
          
          if (this.focused===0) { // NAME
            this.modal = true
            this.openDialog({maxLength: 60, input: this.contact.name})            
          } else if (this.focused===1) { // PHONE
            this.modal = true
            this.openDialog({maxLength: 4, input: this.contact.phone})            
          } else if (this.focused===2) { // SAVE
            if (this.action === 'Nouveau contact') {
              let newContact = {
                name: this.contact.name,
                phone: this.contact.phone,
                characterId: this.cid
              }
              this.contactService.create(newContact).subscribe(c => {
                if (c) this.router.navigate(['/contact/edit/'+c.id], { relativeTo: this.route });
              })
            } else if (this.action === 'Modifier contact') {
              this.contactService.update(this.contact, this.contact.id).subscribe(c => {
                if (c) {
                  this.success = "Contact modifié avec succès!";
                } else {
                  this.success = null!;
                }
              })
            }

          } else if (this.focused===3) { // DELETE
            this.contactService.delete(this.contact.id).subscribe(d=> {
              if (d) this.router.navigate(['/contact']);
            })
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
        if (this.focused===0) {
          this.contact.name = result
        } else if (this.focused===1) {
          if (!isNaN(parseFloat(result)) && !isNaN(result - 0) && result.length == 4 && result > 999) {
            this.contact.phone = result
            this.error = null!
          } else {
            this.error = "Numéro invalide !"
          }
          
        }
      }
      setTimeout(async() => {
        this.modal = false
        await this.http.post('http://phone/inputs', JSON.stringify({
          enable: true
        })).toPromise();
      }, 100);
    });
  }




}