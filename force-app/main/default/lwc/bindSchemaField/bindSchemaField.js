import { LightningElement, wire } from 'lwc';
import getSingleAccount from '@salesforce/apex/AccountController.getSingleAccount';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ID_FIELD from '@salesforce/schema/Account.Id';
import { getSObjectValue } from '@salesforce/apex';
export default class BindSchemaField extends LightningElement {
@wire(getSingleAccount) account;
get name (){
    return this.account.data ? getSObjectValue(this.account.data , NAME_FIELD): '';
}
get ID (){
    return this.account.data ? getSObjectValue(this.account.data , ID_FIELD): '';
}


}