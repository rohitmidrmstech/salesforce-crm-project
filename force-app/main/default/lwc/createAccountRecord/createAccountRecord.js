import { LightningElement } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import RATING_FIELD from '@salesforce/schema/Account.Rating';
export default class CreateAccountRecord extends LightningElement {
    objectApiName =ACCOUNT_OBJECT;
    fields =[NAME_FIELD,REVENUE_FIELD,RATING_FIELD];
    handleSuccess(event){
        const ToastEvent =new ShowToastEvent({
title: "Account Has been Created Successfully",
message:"Account Created" +event.details.id,
variant: "Success"
        });
        this.dispatchEvent(ToastEvent);
            

            }
        
    }