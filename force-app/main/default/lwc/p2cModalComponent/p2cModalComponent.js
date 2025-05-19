import { LightningElement } from 'lwc';

export default class P2cModalComponent extends LightningElement {
    closeHandler(){
const myevent = new CustomEvent('close',{
    bubbles: true ,
        detail: {
            
            msg :"modal created suucessfully!!"
        }
   
    })
this.dispatchEvent(myevent)
    }
    bubblehandler(){
        console.log("bubble Handler Called Successfully");
    }
}