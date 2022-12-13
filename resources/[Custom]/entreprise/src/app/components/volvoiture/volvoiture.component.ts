import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { CollectionCarService } from 'src/app/services/collectionCar.service';

@Component({
  selector: 'app-volvoiture',
  templateUrl: './volvoiture.component.html',
  styleUrls: ['./volvoiture.component.scss']
})
export class VolvoitureComponent implements OnInit {

  organisationId: number; 
  collection: any;
  randomCars = [
    {model: 80636076, modelName: "Dominator"},
    {model: -825837129, modelName: "Vigero"},
    {model: 108773431, modelName: "Coquette"},
    {model: -1041692462, modelName: "Banshee"},
    {model: -1297672541, modelName: "Jester"},
    {model: 970598228, modelName: "Sultan"},
    {model: 1011753235, modelName: "Coquette Classic"},
    {model: 1177543287, modelName: "Dubsta"},
    {model: -114291515, modelName: "Bati"},
    {model: 1672195559, modelName: "Akuma"},
    {model: -1045541610, modelName: "Comet"},
    {model: -1622444098, modelName: "Voltic"},
    {model: -1800170043, modelName: "Gauntlet"},
    {model: 767087018, modelName: "Alpha"},
    {model: -1255452397, modelName: "Schafter2"},
    {model: -89291282, modelName: "Felon2"},
    {model: -5153954, modelName: "Exemplar"},
    {model: -1089039904, modelName: "Furore GT"},
    {model: -1461482751, modelName: "9F Décapotable"},
    {model: 1032823388, modelName: "9F Toit rigide"},
    {model: 418536135, modelName: "Infernus"}
  ]

  constructor(
    private http: HttpClient,
    private collectionCarService: CollectionCarService
  ) {
    this.organisationId = Number(localStorage.getItem("organisationId"))
    this.collectionCarService.getActive(this.organisationId).subscribe(res => {
      this.collection = res
    })
  }

  ngOnInit(): void {
  }

  async triggerServerEvent(name: string, data?: any, data2?: any){
    await this.http.post('http://entreprise/triggerServerEvent', {name: name, data: data, data2: data2}).subscribe(r => {});
  }

  startCollection(){
    let newCollection: any[] = []
    let collectionLength: number = Math.floor(Math.random() * (5 - 3 + 1) + 3)
    for (let l = 0; l < collectionLength; l++) {
      let min = 0
      let max = this.randomCars.length-1
      let retry = true
      let r = 0
      while (retry) {
        r = Math.floor(Math.random() * (max - min + 1) + min)
        let check = true
        for (let i = 0; i < newCollection.length; i++) {
          if(newCollection[i].model === this.randomCars[r].model){
            check = false
          }
        }
        if(check){
          retry = false
        }
      }
      newCollection.push(this.randomCars[r])
    }
    console.log(newCollection);
    
  }

}
