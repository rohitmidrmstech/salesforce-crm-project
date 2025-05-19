import { LightningElement,track, wire} from 'lwc';
import getAllOpps from '@salesforce/apex/GetAllOpportunityRecords.getAllOpps';
import updateOpportunityNames from '@salesforce/apex/GetAllOpportunityRecords.updateOpportunityNames';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UpdateOpportunityUsingdatatable extends LightningElement {
    @track columns = [{
        label: 'Opportunity name',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: 'Stage Name',
        fieldName: 'StageName',
        type: 'text',
        sortable: true
    },
    {
        label: 'Close date',
        fieldName: 'CloseDate',
        type: 'date',
        sortable: true
    }

];

wiredDataResult;
@track error;
@track data ;
@wire(getAllOpps)
wiredOpps(result) {

    this.wiredDataResult = result;
    if (result.data) {
        this.data = result.data;
     
    }
}



getSelectedName() {
    const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
    const selectedIds = [];
    
    
    // Display that fieldName of the selected rows
    for (let i = 0; i < selectedRows.length; i++){
        selectedIds.push(selectedRows[i].Id);
        console.log("You selected: " + selectedRows[i].Id);
    }

    updateOpportunityNames({ids: selectedIds}).then(result => {
        console.log("Opps updated!" + result)
         // Display fresh data in the datatable
         this.selectedRows = [];
         return refreshApex(this.wiredDataResult);
    }).catch(error => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creating record',
                message: error.message,
                variant: 'error'
            })
        );
    });
}
}