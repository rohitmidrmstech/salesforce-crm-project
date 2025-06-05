import { LightningElement,api } from 'lwc';

export default class SetterChildDemo extends LightningElement {
    userdetail
    @api 
    get detail(){
return this.userdetail
    }
    set detail(data){
       let newage = data.age*3
this.userdetail ={...data, age:newage, "Location": "pune"}
    }
    
}