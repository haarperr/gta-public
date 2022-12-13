import { HttpClient } from '@angular/common/http';
import { Component, Inject, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';


/**
  * @ngdoc component
  * @name ModalComponent
  * 
  * @description
  * Gestion des modals
*/
@Component({
  selector: 'app-modal',
  templateUrl: './modal.component.html',
  styleUrls: ['./modal.component.scss']
})
export class ModalComponent implements OnInit {
  form!: FormGroup;
  error: string;
  local_data:any;
  max: number;
  
  constructor(
    private http: HttpClient,
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<ModalComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ){
    this.error = "";
    this.local_data = {...data};
    this.max = this.local_data.input.quantity;
    let t = null
    this.max===1?t=1:t=null;
    this.max===0?this.max=99999999999:null;
    this.form = this.fb.group({
      input: [t, [Validators.required]],
      initial: [this.local_data.input],
      merge: [this.local_data.merge],
      from: [this.local_data.from],
    });
    if (this.max===1) {
      this.dialogRef.close(this.form.value);
    }
  }


  async ngOnInit() {
    this.dialogRef.keydownEvents().subscribe(async event => {      
      if (event.key === "Escape") {
        this.dialogRef.close();
      }
      if (event.key === "Enter") {
        if (this.form.valid == true && this.form.value.input <= this.max) {
          this.dialogRef.close(this.form.value);
        }
      } 
    });
  }

  maxQ(){
    this.form = this.fb.group({
      input: [this.max, [Validators.required]],
      initial: [this.local_data.input],
      merge: [this.local_data.merge],
      from: [this.local_data.from],
    });
  }

  do(){
    if (this.form.valid == true && this.form.value.input <= this.max) {
      this.dialogRef.close(this.form.value);
    }
  }

  close(){
    this.dialogRef.close();
  }


}
