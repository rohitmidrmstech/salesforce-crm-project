import { LightningElement } from 'lwc';

export default class ParentApiPassTheValue extends LightningElement {
    percentage = 10;
    handleonchange(event) {
        this.percentage = event.target.value;
    }
}