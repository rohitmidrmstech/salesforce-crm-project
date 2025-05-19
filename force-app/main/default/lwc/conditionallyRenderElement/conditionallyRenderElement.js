import { LightningElement } from 'lwc';

export default class ConditionallyRenderElement extends LightningElement 
{
    showme = "data is showing"
    showdetails = false
    handleChange(event){
        this.showdetails = event.target.checked
    }


}