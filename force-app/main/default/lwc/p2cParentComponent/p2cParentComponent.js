import { LightningElement } from 'lwc';

export default class P2cParentComponent extends LightningElement {
    ShowModal = false;
    msg
    clickHandler(){
        this.ShowModal = true;
    }
    closeHandler(event){
        this.msg = event.detail.msg
        this.ShowModal= false;
    }
}