import { Pipe, PipeTransform } from "@angular/core";


/**
  * @ngdoc filter
  * @name ObjectSortPipe sortObject
  * @function transform sortObject
  *
  * @description
  * Tri un tableau d'object
  *
  * @param {any[]} array Tableau à trier
  * @param {string} filed Champs concerné
  *
  * @returns {any[]} Tableau trié
*/
@Pipe({
  name: "sortObject"
})
export class ObjectSortPipe  implements PipeTransform {
  transform(array: any[], field: string): any[] {
    if (!Array.isArray(array)) {
      return null!;
    }
    array.sort((a: any, b: any) => {
      if (a[field].name < b[field].name) {
        return -1;
      } else if (a[field].name > b[field].name) {
        return 1;
      } else {
        return 0;
      }
    });
    return array;
  }
}

/**
  * @ngdoc filter
  * @name SortPipe sort
  * @function transform sort
  *
  * @description
  * Tri un tableau
  *
  * @param {any[]} array Tableau à trier
  *
  * @returns {any[]} Tableau trié
*/
@Pipe({
  name: 'sort'
})
export class SortPipe implements PipeTransform {  
  transform(array: any): any[] {
    if (!Array.isArray(array)) {
      return null!;
    }
    array.sort((a: any, b: any) => {
      if (a < b) {
        return -1;
      } else if (a > b) {
        return 1;
      } else {
        return 0;
      }
    });
    return array;
  }
}