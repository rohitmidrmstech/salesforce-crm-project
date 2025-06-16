import { LightningElement,api } from 'lwc';
import getMemberData from '@salesforce/apex/getContactRecordBasedonName.getMemberData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import Email_FIELD from '@salesforce/schema/Contact.Email';
export default class SearchContactinLwc extends LightningElement {
    @api objectApiName = 'Contact';
	showRecScreen = false;
    namevalue;
    contacts;
    fields = [NAME_FIELD,Email_FIELD ];
	
	handleUpdate(){
	this.showRecScreen = true;
	}

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
        this.showRecScreen = false;

    }
    handleNameChange(event){
        this.namevalue = event.target.value;
        console.log('first Name is::'+this.namevalue );
        }
        handleclick(){
            getMemberData({name: this.namevalue})
            .then(result => {
                    this.contacts = result;
                    console.log('Members data  is'+ JSON.stringify(this.contacts));
            })
            .catch( error=>{
                this.contacts = null;
                console.log('error data  is'+ JSON.stringify(this.members));
            });
        } 
}