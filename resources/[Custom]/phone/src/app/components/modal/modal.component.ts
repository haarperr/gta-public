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
  maxLength: number = 255;
  
  constructor(
    private http: HttpClient,
    private fb: FormBuilder,
    public dialogRef: MatDialogRef<ModalComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ){
    this.error = "";
    this.local_data = {...data};
    this.local_data.maxLength ? this.maxLength = this.local_data.maxLength : null;
    this.form = this.fb.group({
      input: [this.local_data.input],
    });
  }


  async ngOnInit() {
    await this.http.post('http://phone/inputs', JSON.stringify({
      enable: false
    })).toPromise();
    this.dialogRef.keydownEvents().subscribe(async event => {      
      if (event.key === "Escape") {
        this.dialogRef.close();
      }
      if (event.key === "Enter") {
        this.dialogRef.close(this.form.value.input);
      } 
    });
  }

  do(){
    this.dialogRef.close(this.form.value.input);
  }


}
