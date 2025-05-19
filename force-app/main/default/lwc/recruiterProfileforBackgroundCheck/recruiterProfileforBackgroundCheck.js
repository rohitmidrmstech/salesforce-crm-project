import { LightningElement,track } from 'lwc';

export default class RecruiterProfileforBackgroundCheck extends LightningElement {
    @track isShowModal = false;
    firstName;
    UpdateText() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }
    firstNameChange(event){
        this.firstName = event.target.value;
    }
    handleClick(event){
        
    }
}