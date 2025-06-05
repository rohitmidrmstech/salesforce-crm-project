import { LightningElement } from 'lwc';

export default class BindingInoutText extends LightningElement {
    showdetail = "world"
    handleChange(event){
        this.showdetail = event.target.value
    }
}