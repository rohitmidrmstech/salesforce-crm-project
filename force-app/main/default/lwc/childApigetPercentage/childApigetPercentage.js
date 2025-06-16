import { LightningElement,api } from 'lwc';

export default class ChildApigetPercentage extends LightningElement {
    @api percentage;
    get style(){
        return 'background-color: red;height: 50px ; width:${this.percentage}%';
    }
}