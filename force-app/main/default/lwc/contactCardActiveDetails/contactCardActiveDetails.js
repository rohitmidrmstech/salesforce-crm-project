import { LightningElement,wire } from 'lwc';
import getRecentlyCreatedContacts from '@salesforce/apex/contactCardActiveStatus.getRecentlyCreatedContacts';
export default class ContactCardActiveDetails extends LightningElement {
contacts=''
    @wire(getRecentlyCreatedContacts)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.error(error);
        }
    }

}