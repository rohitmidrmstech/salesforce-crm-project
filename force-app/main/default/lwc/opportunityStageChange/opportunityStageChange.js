import { LightningElement } from 'lwc';
import getopportunityList from '@salesforce/apex/GetAllOpportunityRecords.getopportunityList';
import updateRecord from '@salesforce/apex/GetAllOpportunityRecords.updateRecord';
import { refreshApex } from '@salesforce/apex';

export default class OpportunityStageChange extends LightningElement {
    searchvalue;
    opportunityrecord;
    updatedRecords;
    handlechange(event){
        this.searchvalue = event.target.value
        console.log(this.searchvalue)
    }
    searchopportunity(){
        console.log('search buttton called');
        getopportunityList({searchKey:this.searchvalue})
            .then(result => {
                this.opportunityrecord= result;
                console.log('opportunity record is' + JSON.stringify(this.opportunityrecord));
            })
            .catch(error => {
               
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message,
                });
                this.dispatchEvent(event);
            });

        
    }
    stageChange(){ 
        console.log('stagechangecalled');
        updateRecord({oppid:this.searchvalue})
        .then(result => {
            console.log(result)
            this.updatedRecords = result;
            console.log('closed won record is' + JSON.stringify(this.updatedRecords));
            return refreshApex(this.updatedRecords);

        })

        .catch(error => {
        })
    } 
    connectedCallback(){
        this.updatedRecords;
    }
        
    }