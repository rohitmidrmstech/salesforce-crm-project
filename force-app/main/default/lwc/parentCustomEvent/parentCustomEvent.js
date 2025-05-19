import { LightningElement } from 'lwc';

export default class ParentCustomEvent extends LightningElement {
    count = 1; 
    handlchange(){
        this.count = this.count+ 1;
    }
}