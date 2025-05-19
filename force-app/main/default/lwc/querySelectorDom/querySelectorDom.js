import { LightningElement } from 'lwc';

export default class QuerySelectorDom extends LightningElement {
  userlist = ["rohit","rahul","meghali","sneha"]
    Showdetails(){
        const elem = this.template.querySelector('h1')
        console.log(elem.innerText)
    }
}