import { LightningElement,track } from 'lwc';

export default class HelloWorld extends LightningElement {
fullname = "zero to hero"
title ="Aura"
changehandler(event){
    this.title = event.target.value 
}
@track address ={
    city:'nanded',
    Postcode:48939,
    country:'india'
}
arraylist =["A","B","C"]

trackHandler(event){
this.address.country = event.target.value
this.arraylist[1] =event.target.value
}
// exampleof getter In LWC 
arraylist =["rohit","rahul","karan"]
num1 = 10;
num2 = 45;
get firstName(){
    return this.arraylist[0]
}
get multiply(){
    return this.num1 * this.num2
}


}