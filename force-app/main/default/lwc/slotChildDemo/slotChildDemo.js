import { LightningElement } from 'lwc';

export default class SlotChildDemo extends LightningElement {
    handlefooterChange(){
        const footerEle = this.template.querySelector('.slds-card__footer')
        if(footerEle){
            footerEle.classList.remove('slds-hide') ;
        }
    }
}