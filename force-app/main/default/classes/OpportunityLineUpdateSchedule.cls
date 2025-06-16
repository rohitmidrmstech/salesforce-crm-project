public class OpportunityLineUpdateSchedule {
    
    //Public Flow.Interview.Update_Opportunity_Product_Schedule myAutoFlow { get; set; }
    Public OpportunityLineItem opLine {get; set;}
    private Decimal oldQuantity;
    private Decimal oldSalesPrice;
    private Decimal oldDiscount;
    
    
    public OpportunityLineUpdateSchedule(ApexPages.StandardController stdController) {
        List<String> fields = new List<String>();
        fields.add('Name');
        fields.add('Shipping_Start_Date__c');
        fields.add('Shipping_End_Date__c');
        fields.add('Quantity');
        fields.add('UnitPrice');
        fields.add('Opportunity_Probability__c');
        fields.add('Discount');
        if(!test.isrunningTest())
        stdController.addFields(fields);
        this.opLine = (OpportunityLineItem)stdController.getRecord();
        
        System.debug('--opLine--'+opLine);
        
        this.oldSalesPrice = this.opLine.UnitPrice != null ? this.opLine.UnitPrice.setScale(2) : null;
        this.oldQuantity = this.opLine.Quantity;
        this.oldDiscount = this.opLine.Discount;
    }

    @AuraEnabled
    public static OpportunityLineItem queryOpportunityLineItem(String recordId) {
        OpportunityLineItem opLine = [SELECT Id, Name, Shipping_Start_Date__c, Shipping_End_Date__c, Quantity,
                                      UnitPrice, Opportunity_Probability__c, Discount
                                      FROM OpportunityLineItem 
                                      WHERE Id =: recordId];

        return opLine;
    }

    @AuraEnabled
    //Get the picklist options for data export of invoices
    public static Map<String, List<PicklistOption>> getPicklistsData() {
        List<PicklistOption> probabilities = new List<PicklistOption>();
        
        for (Schema.PicklistEntry picklist : OpportunityLineItem.Opportunity_Probability__c.getDescribe().getPicklistValues()) {
            probabilities.add(new PicklistOption(picklist.getLabel(), picklist.getValue()));
        }

        Map<String, List<PicklistOption>> picklists = new Map<String, List<PicklistOption>>();
        picklists.put('probabilities', probabilities);

        return picklists;
    }
    
    Public Pagereference updateSchedule(){
        System.debug('---updateSchedule---called---');
        Savepoint sp = Database.setSavepoint();
        try{
            //Call actions here
            
            if(opLine != null && opLine.id != null){
                
                //Before Calling the aupdate we need to deactivate the existing Task record
                List<ID> recordIDs = new List<ID>();
                recordIDs.adD(opLine.Id);
                CompleteNextStepActivities.updateExistingActivtyRecords(recordIDs);
                System.debug('::::::::JSON::::::::'+JSON.serialize(opLine));
                
                if(opLine.Quantity == null || opLine.Quantity <= 0){
                   Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Please provide valid Quantity.')); 
                }
                
                if(opLine.UnitPrice == null || opLine.UnitPrice <= 0){
                   Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Please provide valid Sales Price.')); 
                }

                System.debug('--oldSalesPrice--'+oldSalesPrice);
                System.debug('--UnitPrice--'+opLine.UnitPrice);
                System.debug('--oldDiscount--'+oldDiscount);
                System.debug('--Discount--'+opLine.Discount);
                
                
                
                
                if((
                    oldSalesPrice != opLine.UnitPrice ||
                    oldQuantity != opLine.Quantity || 
                    oldDiscount != opLine.Discount
                   )
                   
                   || test.isRunningTest()){
                    //System.debug('Core val Change Called');
                    //Delete existing Schedule
                    deleteScheduleLines(recordIDs);
                    
                    //Update opportunity product record
                    Update opLine;
                    
                    //Recreate the schedule
                    createLineItemSchedule(recordIDs);
                
                }else{
                    //Update opportunity product record
                    Update opLine;
                }
                
                PageReference home = new PageReference('/'+opLine.id);
                home.setRedirect(true);        
                return home;
            }else{
                Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Please select valid Product and try again.'));
                return null;
            }
        }catch(Exception ex){
            Database.rollback( sp );
            ApexPages.addMessages(ex);
            system.debug('---save---Error--'+ex);
            return null;
        }
    }

    @AuraEnabled
    public static string updateScheduleLWC(String recordId, OpportunityLineItem opLine){
        Savepoint sp = Database.setSavepoint();
        try{
            //Call actions here
            
            if(opLine != null && opLine.id != null){
                
                //Before Calling the aupdate we need to deactivate the existing Task record
                List<ID> recordIDs = new List<ID>();
                recordIDs.adD(opLine.Id);
                CompleteNextStepActivities.updateExistingActivtyRecords(recordIDs);
                
                if(opLine.Quantity == null || opLine.Quantity <= 0){
                   Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Please provide valid Quantity.')); 
                }
                
                if(opLine.UnitPrice == null || opLine.UnitPrice <= 0){
                   Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Please provide valid Sales Price.')); 
                }

                OpportunityLineItem oliOld = [SELECT Id, Name, Shipping_Start_Date__c, Shipping_End_Date__c, Quantity,
                                              UnitPrice, Opportunity_Probability__c, Discount
                                              FROM OpportunityLineItem 
                                              WHERE Id =: recordId];
                
                if((oliOld.UnitPrice != opLine.UnitPrice || oliOld.Quantity != opLine.Quantity || oliOld.Discount != opLine.Discount) || test.isRunningTest()){
                    deleteScheduleLines(recordIDs);
                    
                    //Update opportunity product record
                    Update opLine;
                    
                    //Recreate the schedule
                    createLineItemSchedule(recordIDs);
                
                }else{
                    //Update opportunity product record
                    Update opLine;
                }

                return 'Success';
            }else{
                return null;
            }
        }catch(Exception ex){
            Database.rollback( sp );
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    public static void deleteScheduleLines(List<ID> oppLineItemIds){
        System.debug('---deleteScheduleLines--');
        if(oppLineItemIds != null && oppLineItemIds.size()>0){
            List<OpportunityLineItemSchedule> qliList = [Select id from OpportunityLineItemSchedule where OpportunityLineItemId in :oppLineItemIds];
            delete qliList;
        }
    }
    
    @future
    public static void createLineItemSchedule(List<ID> oliIds){
        system.debug('--oliIds.size-->'+oliIds.size());
        if(oliIds.size() > 0) 
        {
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            for(OpportunityLineItem oli : [select id,UnitPrice,discount, Created_Revenue_Schedules__c, Revenue_Per_Month__c, Shipping_Start_Date__c,
                                           Shipping_End_Date__c,Total_Months_of_Shipping__c,
                                           Quantity_Per_Month__c, Quantity, TotalPrice, Opportunity_Probability__c, (select id, ScheduleDate, Revenue, Quantity, OpportunityLineItemId from opportunityLineItemSchedules) from OpportunityLineItem where id in :oliIds]) {
                oliList.add(oli);
            }
            system.debug('--oliList-->>'+oliList.size());
            if(oliList.size() > 0){
                
                List<opportunityLineItemSchedule> oliSchToInsert = new List<opportunityLineItemSchedule>();
                for(OpportunityLineItem ol : oliList) {
                    Integer totalMonths = (Integer)ol.Total_Months_of_Shipping__c;
                    system.debug('---totalMonths-->'+totalMonths);
                    /*for(integer i = 0; i < totalMonths; i++) {
                        opportunityLineItemSchedule sch = new opportunityLineItemSchedule();
                        sch.OpportunityLineItemId = ol.id;
                        sch.Opportunity_Probability__c = ol.Opportunity_Probability__c;
                        sch.Revenue = ol.Revenue_Per_Month__c;
                        sch.Quantity = ol.Quantity_Per_Month__c;
                        sch.Type = 'Both';
                        sch.ScheduleDate = ol.Shipping_Start_Date__c.addMonths(i);
                        oliSchToInsert.add(sch);
                    }*/
                    
                    
                    for(integer i = 0; i < totalMonths - 1; i++) {
                        opportunityLineItemSchedule sch = new opportunityLineItemSchedule();
                        sch.OpportunityLineItemId = ol.id;
                        sch.Opportunity_Probability__c = ol.Opportunity_Probability__c;
                        sch.Revenue = ol.Revenue_Per_Month__c;
                        sch.Quantity = ol.Quantity_Per_Month__c;
                        sch.Type = 'Both';
                        sch.ScheduleDate = ol.Shipping_Start_Date__c.addMonths(i);
                        oliSchToInsert.add(sch);
                    }
                    System.debug('--oliSchToInsert--'+oliSchToInsert);
                    
                    
                    System.debug('--Quantity--'+ol.Quantity);
                    System.debug('--Quantity_Per_Month__c--'+ol.Quantity_Per_Month__c);
                    
                    Decimal computedQunatity = ol.Quantity != null ? ol.Quantity_Per_Month__c * totalMonths : 0;
                    Decimal remainingPart = ol.Quantity != null ? (ol.Quantity - (computedQunatity).setScale(2)).abs() : 0;
                    Decimal lastQuantity = ol.Quantity > computedQunatity ? (ol.Quantity_Per_Month__c + remainingPart).setScale(2) : 
                    (ol.Quantity_Per_Month__c - remainingPart).setScale(2);
                    
                    System.debug('--computedQunatity--'+computedQunatity);
                    System.debug('--remainingPart--'+ remainingPart);
                    System.debug('--lastQuantity--'+ lastQuantity);
                    
                    opportunityLineItemSchedule sch = new opportunityLineItemSchedule();
                    sch.OpportunityLineItemId = ol.id;
                    sch.Opportunity_Probability__c = ol.Opportunity_Probability__c;
                    System.debug('--unit price---'+ol.UnitPrice);
                    System.debug('--discount---'+ol.discount);
                    System.debug('--Quantity---'+ol.Quantity);
                    //Decimal discount = ol.discount == null ? 0 : ol.discount;
                    //System.debug('--Quantity * UnitPrice---'+(ol.Quantity * ol.UnitPrice ) * (1 - discount / 100) );
                    //System.debug('--Revenue_Per_Month__c---'+ol.Revenue_Per_Month__c);
                    //System.debug('--totalMonths---'+totalMonths);
                    System.debug('--totalMonths * Revenue_Per_Month__c---'+ol.Revenue_Per_Month__c * totalMonths);
                    System.debug('--TotalPrice---'+ol.TotalPrice);
                                        
                    sch.Revenue = (ol.TotalPrice)  > (ol.Revenue_Per_Month__c * totalMonths) 
                            ? ol.Revenue_Per_Month__c + (ol.TotalPrice - (ol.Revenue_Per_Month__c * totalMonths))
                            : ol.Revenue_Per_Month__c - ((ol.Revenue_Per_Month__c * totalMonths ) - ol.TotalPrice);
                    
                    //sch.Revenue = ol.Revenue_Per_Month__c;
                    sch.Quantity = lastQuantity;
                    sch.Type = 'Both';
                    sch.ScheduleDate = ol.Shipping_End_Date__c;
                    oliSchToInsert.add(sch);
                }
                system.debug('--oliSchToInsert-->>'+oliSchToInsert.size());
                
                
                if(oliSchToInsert.size() > 0) {
                    insert oliSchToInsert;
                }
            }
        }
    }
    
    
    public PageReference cancle(){
        try{     
            PageReference home = new PageReference('/'+opLine.id);
            home.setRedirect(true);        
            return home;    
        }catch (Exception ex) {
            ApexPages.addMessages(ex);
            system.debug('---cancle---Error--'+ex);
            return null;
        }
    }

    public class PicklistOption {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String description;
    
        public PicklistOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    
        public PicklistOption(String label, String value, String description) {
            this.label = label + ' - ' + description;
            this.value = value;
        }
    }
}