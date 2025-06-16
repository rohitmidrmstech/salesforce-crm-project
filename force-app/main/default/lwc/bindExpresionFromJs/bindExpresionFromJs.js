import { LightningElement } from 'lwc';

export default class BindExpresionFromJs extends LightningElement {
handleChange(event){
    const field = event.target.name
    if(field == fullName){
        this.fullName = event.target.value
    } else if(field== email){
this.email= event.target.value
    } else if(field == Phone){
        this.Phone= event.target.value
  
    }

}


}