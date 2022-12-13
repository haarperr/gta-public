import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ContactService {
  /**
  * @property {string} URL URL de l'API coriandre
  **/
  // URL : string = 'http://localhost:8888/api/contacts/';
  URL : string = 'https://swiily.ddns.net:8888/api/contacts/';

  constructor(
    private http: HttpClient,
  ){  }

  getOne(id: any): Observable<any> {
    return this.http.get<any>(this.URL+''+id);
  }

  getOneFromPhone(id:number, phone:number){
    return this.http.get<any>(this.URL+'c/'+id+'/phone/'+phone);
  }

  getAll(src: any): Observable<any> {
    return this.http.get<any>(this.URL+'c/'+src);
  }

  create(contact: any): Observable<any> {
    return this.http.post<any>(this.URL+'create/', contact);
  }

  update(contact: any, id: number): Observable<any> {
    return this.http.put<any>(this.URL+'update/'+id, contact);
  }

  delete(id: number): Observable<any> {
    return this.http.delete<any>(this.URL+'delete/'+id);
  }
}
