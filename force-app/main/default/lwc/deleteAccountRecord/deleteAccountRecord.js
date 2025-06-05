import { LightningElement,wire } from 'lwc';
import getAcclist from '@salesforce/apex/AccountController.getAcclist';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import{refreshApex} from '@salesforce/apex'
export default class DeleteAccountRecord extends LightningElement {
accounts;
wiredAccountResult;
error;


    @wire(getAcclist)
wiredAccount(result){
this.wiredAccountResult=result;

if(result.data){
    this.accounts =result.data;
    this.error = undefined;
}
else if(result.error){
    this.accounts =undefined;
    this.error=result.error;
}
}
deleteAccount(event){
const recordId = event.target.dataset.recordid;
deleteRecord(recordId)
.then((result) =>{
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'success',
            message:'Account deleted successfully',
            variant: 'Success'
                })
    );
return refreshApex(this.wiredAccountResult);
})

.catch((error) => {
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'error',
            message:'Account record error',
            variant: 'error'
                })
    );
});
        }
    }