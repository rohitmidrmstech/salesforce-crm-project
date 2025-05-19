import { LightningElement,track } from 'lwc';

export default class PractiseLwcComponent extends LightningElement {
 @track message;
 handleinputtext(event){
    this.message = event.target.value;
 }
}