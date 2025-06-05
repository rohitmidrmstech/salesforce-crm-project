/**
* -------------------------------------------------------------------------------------------------
* Case Trigger Handler class
* -------------------------------------------------------------------------------------------------
* @author         Gautam Kumar (gkumar@liquidhub.com)
* @verstion       1.0
* @created        2017-05-22    513, 522, 536, 537, 552 
*/
public class CT_CasetriggerHandler {
    public Id issuesRecordTypeId {get;set;}
    public Id creditRecordTypeId {get;set;}
    public Id rebillRecordTypeId {get;set;}
    public Id qualityRecordTypeId {get;set;}
    public Id pricingRecordTypeId {get;set;}
    public Id serviceRecordTypeId {get;set;}
    public Id manQualityRecordTypeId {get;set;}
    public Id rebateRecordTypeId {get;set;}
    public Id rebateRecordTypeIdUS {get;set;}
    public Id priceExceptionRecordTypeId{get;set;}
    public Id salesAdjustmentSpecialsRecordTypeId{get;set;}
    public Id salesAdjustementFreightAllowanceRecordTypeId{get;set;}
    
    public CT_Common_Settings__c common {get;set;}
    private static Map<String,Plants__c> codeToPlantMap;
    
    static{
        // This assumes all plant info isn't a large set of data.  
        //  Currently (10/8/2017), plant data is at a count of 33
        codeToPlantMap = new Map<String, Plants__c>();
        List<Plants__c> plantsList = [SELECT id, SAP_Plant__c, Name from Plants__c];
        for (Plants__c currPlant : plantsList){
            codeToPlantMap.put(currPlant.SAP_Plant__c, currPlant);
        }
    }
    
    public CT_CasetriggerHandler(){
        issuesRecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Issues').getRecordTypeId();
        creditRecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Credit').getRecordTypeId();
        rebillRecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Rebill').getRecordTypeId();
        qualityRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Case').getRecordTypeId();
        pricingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Case').getRecordTypeId();
        serviceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId();
        manQualityRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manual Quality Entry Case').getRecordTypeId();
        //rebateRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Rebates').getRecordTypeId();
        //rebateRecordTypeIdUS = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Rebates US').getRecordTypeId();
        //priceExceptionRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Price Exception').getRecordTypeId();
        //salesAdjustmentSpecialsRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Specials').getRecordTypeId();
        //salesAdjustementFreightAllowanceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Freight Allowance').getRecordTypeId();
        
        common = CT_Common_Settings__c.getInstance();
    }

    public Set<id> getInsulationRecordTypes() {
        Set<String> recordTypeNameList = new Set<String>{'Customer Master Request','Customer Specific FOI Disc','Email','General Call','National Pricing',
                'Price Increase','Pricing Incident','Quality Incident','Quality RMA Incident',
                'Sales Adjustment Allowance', 'Sales Adjustment Behavioral Rebates','Sales Adjustment Credit Terms',
                'Sales Adjustment Customer Specific Price','Sales Adjustment Job Pricing',
                'Sales Adjustment Non-Behavioral Rebates','Sales Adjustment Sales District/Price List',
                'Service Incident','Service Price Negotiation Incident','Service Recon/Redelivery Incident',
                'Service RMA Incident','Technical Marketing'};
                
        Set<Id> recordTypeIdList = new set<Id>();
        Id recordTypeId;
        for(String recordTypeName : recordTypeNameList){
            if(Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName) != null){
                recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
                if(recordTypeId != null)
                    recordTypeIdList.add(recordTypeId);
            }
        }      
        return  recordTypeIdList;
        /*return( new Map<id, RecordType>([select id, name from recordType where sobjecttype = 'Case' and
        name in ('Customer Master Request','Customer Specific FOI Disc','Email','General Call','National Pricing',
                'Price Increase','Pricing Incident','Quality Incident','Quality RMA Incident',
                'Sales Adjustment Allowance', 'Sales Adjustment Behavioral Rebates','Sales Adjustment Credit Terms',
                'Sales Adjustment Customer Specific Price','Sales Adjustment Job Pricing',
                'Sales Adjustment Non-Behavioral Rebates','Sales Adjustment Sales District/Price List',
                'Service Incident','Service Price Negotiation Incident','Service Recon/Redelivery Incident',
                'Service RMA Incident','Technical Marketing')])).keySet();*/

    }

    public Set<id> getGypsumCeilingRecordTypes() {
        Set<String> recordTypeNameList = new Set<String>{'General Price Change Case','Finishing Case Support','Manual Quality Entry Case','Quality','Service','Pricing','Quality Case',
                'Service Case','Pricing Case','Service Closed','Pricing Closed','Quality Closed','Portal',
                'Sales Adjustment Price Exception','Sales Adjustment Rebates','Sales Adjustment Rebates US',
                'Sales Adjustment Specials','Sales Adjustment List Price Canada','Sales Adjustment No Charge',
                'Internal Case Support','Manual Adjustment','Sales Adjustment Freight Allowance',
                'Sales Adjustment Area Price US','Sales Adjustment Cheque Request','Sales Adjustment Credit Request',
                'Sales Adjustment No Charge US'};
                
        Set<Id> recordTypeIdSet = new set<Id>();
        Id recordTypeId;
        for(String recordTypeName : recordTypeNameList){
            if(Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName) != null){
                recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
                if(recordTypeId != null)
                    recordTypeIdSet.add(recordTypeId);
            }
        }      
        return  recordTypeIdSet;
    
        /*return( new Map<id, RecordType>([select id, name from recordType where sobjecttype = 'Case' and
        name in ('General Price Change Case','Finishing Case Support','Manual Quality Entry Case','Quality','Service','Pricing','Quality Case',
                'Service Case','Pricing Case','Service Closed','Pricing Closed','Quality Closed','Portal',
                'Sales Adjustment Price Exception','Sales Adjustment Rebates','Sales Adjustment Rebates US',
                'Sales Adjustment Specials','Sales Adjustment List Price Canada','Sales Adjustment No Charge',
                'Internal Case Support','Manual Adjustment','Sales Adjustment Freight Allowance',
                'Sales Adjustment Area Price US','Sales Adjustment Cheque Request','Sales Adjustment Credit Request',
                'Sales Adjustment No Charge US')])).keySet();*/
                

    }
    
    // handler template actions
    public void beforeInsertHandler(List<Case> newList){
        
        mapCaseOrderInvoice(newList);
        processSoldToShipTo(newList);

        List<Id> ceilingsRTs = new List<Id>();
        ceilingsRTs.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId());
        ceilingsRTs.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing').getRecordTypeId());
        ceilingsRTs.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality').getRecordTypeId());



        List<Case> gypsumCases = new List<Case>();
        for (Case nextCase : newList) {
            if (!ceilingsRTs.contains(nextCase.recordTypeId))
                gypsumCases.add(nextCase);
        }
        processNewShipToNewSoldTo(gypsumCases);
    }
    
    /* After Insert Handler function for the case trigger.
* @param - insertedCaseList
* @description - This function will auto-populate case Items from the orderItems related to the order field on case.
*/
    
    public void afterInsertHandler(List<case> newList){
        caseTriggerHandler.serviceCaseAssignment(newList);
        
        createCaseItems(newList);
        shareCasesWithOutRebatesToSoldToOwners(newList);
    }
    
    /* Before Update Handler function for the case trigger.
* @param - updatedCaseList, updatedCaseMap
* @description - This function will check if the order__c field has been updated
* If the field has been updated and it is not null it will change the invoice field value accordingly
* If the order__c field is null and invoice__c is unchanged then the order__c will be populated with
* the value it was containing before the update
*/
    public void beforeUpdateHandler(List<Case> updatedCaseList, Map<Id,Case> updatedCaseMap)
    {
        preSettlementRSM(updatedCaseList); // Process Builder "Approval_Approver_User_Fillin_Other"
        supplierApprover(updatedCaseList); // Process Builder "Approval_Approver_User_Fillin_Other"
        plantApproversPlantChange(updatedCaseList, updatedCaseMap); // Process Builder "Approval_Approver_User_Fillin_Other"
        
        checkProcessSoldToShipTo(updatedCaseList, updatedCaseMap);
        checkProcessNewShipToNewSoldTo(updatedCaseList, updatedCaseMap);
        validation_checkForIssues(updatedCaseList, updatedCaseMap);
        Set<Id> ownerUpdatedCaseIds = new Set<Id>();
        for(case c : updatedCaseList){
            if(updatedCaseMap.get(c.Id).OwnerId != c.OwnerId){
                ownerUpdatedCaseIds.add(c.Id);
            }
        }
        if(ownerUpdatedCaseIds.size()>0 ){
            handleOwnerUpdate(ownerUpdatedCaseIds);
        }
    }
    
    public void plantApproversPlantChange(List<Case> updatedCaseList, Map<Id,Case> updatedCaseMap)
    {
        Set<Id> setPlantIDs = new Set<Id>();
        Set<String> setPlantNames = new Set<String>();
        for(case c : updatedCaseList)
        {
            // Plant Approvers
            if((c.Manufacturing_Plant__c != null && c.Plant_Manager__c == null) || (c.Manufacturing_Plant__c != updatedCaseMap.get(c.Id).Manufacturing_Plant__c))
                setPlantIDs.add(c.Manufacturing_Plant__c);
            
            // Plant Change
            if((c.Manufacturing_Plant__c != updatedCaseMap.get(c.Id).Manufacturing_Plant__c) && c.Status == 'Pending Quality Manager')
                setPlantIDs.add(c.Manufacturing_Plant__c);
            
            if(c.Product_Category__c  == 'Export'){
                if((c.Warehouse__c != null && c.Plant_Manager__c == null) || (c.Warehouse__c != updatedCaseMap.get(c.Id).Warehouse__c))
                    setPlantNames.add(c.Warehouse__c);
            }
        }
        
        Map<Id, Plants__c> mapPlants;
        if(setPlantIDs.size() >0 || setPlantNames.size()>0)
            mapPlants = new Map<Id, Plants__c>([SELECT Id, Name, Plant_Manager__c, Quality_Manager__c,Warehouse_Manager__c FROM Plants__c WHERE (Id IN :setPlantIDs or Name IN:setPlantNames) ]);
        system.debug('mapPlants ' +mapPlants);
        for(case c : updatedCaseList)
        {
            ID QualityManagerID;
            
            if((c.Manufacturing_Plant__c != null && c.Plant_Manager__c == null) || (c.Manufacturing_Plant__c != updatedCaseMap.get(c.Id).Manufacturing_Plant__c))
            {
                if(mapPlants.containsKey(c.Manufacturing_Plant__c))
                {
                   
                   system.debug('c.Sales_Org__c===>'+c.Sales_Org__c);
                     c.Manufacturing_Plant_Selected_DateTime__c = SYSTEM.NOW();
                   // CHG1044966  12.9.2021
                    if(c.Sales_Org__c != null )
                    {
                        if(c.Sales_Org__c == System.Label.SalesOrg1100  || c.Sales_Org__c == System.Label.SalesOrg1101 || c.Sales_Org__c == System.Label.SalesOrg1300)
                        {
                         
                            system.debug('c.Sales_Org__c from Ifpart ===>'+c.Sales_Org__c);   
                            ID PlantManagerID = mapPlants.get(c.Manufacturing_Plant__c).Plant_Manager__c;
                            ID WarehouseManagerID = mapPlants.get(c.Manufacturing_Plant__c).Warehouse_Manager__c ;
                            QualityManagerID = mapPlants.get(c.Manufacturing_Plant__c).Quality_Manager__c;
                            
                            //c.Manufacturing_Plant_Selected_DateTime__c = SYSTEM.NOW();
                           
                            if(WarehouseManagerID != null && c.RecordTypeId ==System.Label.Service_Case_Record_Id ) 
                            {
                            system.debug('For RecordType=Service Case , County==Canada , On CaseObject plant Manager field ,should be populated from Plant Objects (warehouse Manager)');
                            system.debug('c.RecordTypeId for Service Case==>0120V000002213cQAA'+ c.RecordTypeId);
                            c.Plant_Manager__c = WarehouseManagerID ;
                            }
                            if(PlantManagerID != null && (c.RecordTypeId ==System.Label.Quality_Case_Record_ID || c.RecordTypeId ==System.Label.Manual_Quality_Entry_Case_Record_ID )) 
                            {
                            system.debug('For RecordType=Quality Case , County==Canada , On CaseObject plant Manager field ,should be populated from Plant Objects (Plant Manager)');
                            system.debug('c.RecordTypeId for Quality Case==>0120V000002213bQAA || manual Quality case ==>0120V000002213ZQAQ'+ c.RecordTypeId);
                            c.Plant_Manager__c = PlantManagerID ;
                            }
                            system.debug(' Plant_Manager__c on Case Object'+c.Plant_Manager__c );
                            if(QualityManagerID != null)    c.Quality_Manager__c = QualityManagerID;
                            system.debug('QualityManagerID==After==>'+QualityManagerID );
                         }
                        else
                        {
                          if(c.country__c =='USA' && (c.RecordTypeId ==System.Label.Quality_Case_Record_ID || c.RecordTypeId ==System.Label.Manual_Quality_Entry_Case_Record_ID ))
                          {
                             QualityManagerID = mapPlants.get(c.Manufacturing_Plant__c).Quality_Manager__c;
                             ID PlantManagerID = mapPlants.get(c.Manufacturing_Plant__c).Plant_Manager__c;
                              if(PlantManagerID != null)  c.Plant_Manager__c = PlantManagerID;
                              if(QualityManagerID != null)    c.Quality_Manager__c = QualityManagerID;  
                          }
                          else{
                            ID PlantManagerID = mapPlants.get(c.Manufacturing_Plant__c).Warehouse_Manager__c ;
                            QualityManagerID = mapPlants.get(c.Manufacturing_Plant__c).Quality_Manager__c;
                            //c.Manufacturing_Plant_Selected_DateTime__c = SYSTEM.NOW();
                            if(PlantManagerID != null)  c.Plant_Manager__c = PlantManagerID;
                            if(QualityManagerID != null)    c.Quality_Manager__c = QualityManagerID;      
                        }
                        }
                   
                    }
                    
                }
            }
            
            if((c.Manufacturing_Plant__c != updatedCaseMap.get(c.Id).Manufacturing_Plant__c) && c.Status == 'Pending Quality Manager')
            {
                if(mapPlants.containsKey(c.Manufacturing_Plant__c))
                {
                    c.Manufacturing_Plant_Selected_DateTime__c = SYSTEM.NOW();
                    
                    QualityManagerID = mapPlants.get(c.Manufacturing_Plant__c).Quality_Manager__c;
                    
                    if(QualityManagerID != null)    c.OwnerId = QualityManagerID;
                }
                
            }
            else if(c.Product_Category__c  == 'Export'){
            system.debug(' updatedCaseMap ' +updatedCaseMap);
                if((c.Warehouse__c != null && c.Plant_Manager__c == null) || 
                   (c.Warehouse__c != updatedCaseMap.get(c.Id).Warehouse__c))
                {
                    for(Id key : mapPlants.keySet())
                    {
                        Plants__c p =mapPlants.get(key);
                        if(p.name == c.Warehouse__c){
                            ID PlantManagerID = mapPlants.get(key).Warehouse_Manager__c ;
                            if(PlantManagerID != null)  c.Plant_Manager__c = PlantManagerID;
                        }
                    }
                }
            }
        }
    }
    
    public void supplierApprover(List<Case> updatedCaseList)
    {
        Set<Id> setSupplierIDs = new Set<Id>();
        for(case c : updatedCaseList)
        {
            if(c.Supplier__c != null && c.Supplier_Approver__c == null)
                setSupplierIDs.add(c.Supplier__c);      
        }
        
        Map<Id, Supplier__c> mapSuppliers;
        if(setSupplierIDs.size() > 0)
            mapSuppliers = new Map<Id, Supplier__c>([SELECT Id, Approver__c FROM Supplier__c WHERE Id IN :setSupplierIDs]);
        
        for(case c : updatedCaseList)
        {
            if(c.Supplier__c != null && c.Supplier_Approver__c == null)
            {
                if(mapSuppliers.containsKey(c.Supplier__c))
                {
                    ID SupplierApproverID = mapSuppliers.get(c.Supplier__c).Approver__c;
                    if(SupplierApproverID == null)  c.Supplier_Approver__c = SupplierApproverID;
                }
            }      
        }
    }
    
    public void preSettlementRSM(List<Case> updatedCaseList)
    {

        ID RTID_ManualQualityEntryCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manual Quality Entry Case').getRecordTypeId();
        ID RTID_QualityCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Case').getRecordTypeId();
        Set<Id> setSalesRepIDs = new Set<Id>();
        for(case c : updatedCaseList)
        {
            if((c.RecordTypeId == RTID_ManualQualityEntryCase || c.RecordTypeId == RTID_QualityCase) && c.Pre_Approver_1a__c == null && c.Sales_Rep__c != null)
                setSalesRepIDs.add(c.Sales_Rep__c);
        }
        
        Map<Id, User> mapSalesReps = new Map<Id, User>();
        if(setSalesRepIDs.size() > 0)
            mapSalesReps = new Map<Id, User>([SELECT Id, ManagerId, Manager.ManagerId FROM User WHERE Id IN :setSalesRepIDs]);
        
        for(case c : updatedCaseList)
        {
            if((c.RecordTypeId == RTID_ManualQualityEntryCase || c.RecordTypeId == RTID_QualityCase)  && c.Sales_Rep__c != null)
            {
                if(mapSalesReps.containsKey(c.Sales_Rep__c))    
                {
                    ID SalesRepManagerID = mapSalesReps.get(c.Sales_Rep__c).ManagerId;
                    if(c.Pre_Approver_1a__c == null  && SalesRepManagerID != null) c.Pre_Approver_1a__c = SalesRepManagerID;
                    if(c.RSM__c == null  && SalesRepManagerID != null) c.RSM__c = SalesRepManagerID;
                    if(c.VP__c == null  && SalesRepManagerID != null) c.VP__c = mapSalesReps.get(c.Sales_Rep__c).Manager.ManagerId;
                }
            }
            if(c.Sales_org__c == '1101'){ // CHG1040266 - Added by Sandip
                c.Pre_Approver_1a__c = common.Pre_approver_user_Id_1101__c;
                c.RSM__c = common.RSM_User_Id_1101__c;
                c.VP__c = common.VP_User_Id_1101__c;
            }
                
        }
        
    }
    
    /* After Update Handler function for the case trigger.
* @param - updatedCaseList, updatedCaseMap
-- If case owner is changed add sharing to the previous case owner 
*/
    public void afterUpdateHandler(List<Case> updatedCaseList,Map<Id,Case> updatedCaseMap)
    {
        
    }
    
    // Business logic ----------------------------------------------------------------------------------------------------------------------
    
    // functions in before insert --------------------------------------------------------------------------------------
    // this will set up the order and invoice fields and copy a bunch of data from the invoice item
    public void mapCaseOrderInvoice(List<Case> newList){
        Set<id> orderIdSet = new Set<id>();
        List<Case> workingList = new List<Case>();
        
        for (Case currCase : newList){
            System.debug('*** sold to is ' + currCase.sold_to_name__c);
            if (String.isNotEmpty(currCase.Order__c)){
                orderIdSet.add(currCase.Order__c);
                workingList.add(currCase);
            }
        }
        
        
        // query for the invoice get data
        if (orderIdSet.isEmpty()==false){
            Map<Id, Order> orderMap = new Map<Id, Order>(
                [SELECT Id, EffectiveDate, Doc_Type_Desc__c, Doc_Type__c, Ship_To__c, Sold_To__c, PoNumber
                , plant_desc__c
                 //, Mode_of_Transport__c
                 FROM Order 
                 WHERE id in: orderIdSet]
            );
            
            
            List<Invoice__c> invoiceList = [SELECT Id, Name, Order__c, Ship_To_Lookup__c, Sold_To_Lookup__c,
                                            Billing_Date__c,Carrier__c,Carrier_Name__c,Curr__c,
                                            Inv_Cancelled__c,Inv_Type__c,Inv_Type_Desc__c,Invoice_Number__c,
                                            Load_Number__c,Net_Value__c,Payer__c,Plant__c,PO_Number__c,
                                            Sales_Org__c,Sales_Org_Name__c,Ship_Date__c,Shipment_Number__c,
                                            Territory__c,Total_Freight__c, Plant_Name__c
                                            FROM invoice__c 
                                            WHERE order__c in: orderIdSet];
            
            Map<Id, Invoice__c> orderIdToInvoiceMap = new Map<Id, Invoice__c>();
            
            // GCP-399 alternate mapping: if case specified a specific invoice, get that one.
            Map<Id, Invoice__c> directInvoiceMap    = new Map<Id, Invoice__c>();
            System.debug('invoiceList'+invoiceList);
            for (Invoice__c currInv : invoiceList){
                orderIdToInvoiceMap.put(currInv.Order__c, currInv);
                directInvoiceMap.put(currInv.Id, currInv);
            }
            
            
            for (Case currCase : workingList){
                Order currOrder = orderMap.get(currCase.Order__c);
                
                // GCP-491 - we will currently separate the way we create cases against order and invoices.  We will leave the legacy code
                //  in case the decision goes back to the old methodology
                // Invoice__c currInvoice = orderIdToInvoiceMap.get(currCase.Order__c);
                Invoice__c currInvoice = null;
                system.debug('@@@directInvoiceMap.get(currCase.Invoice__c)@@@@'+directInvoiceMap.get(currCase.Invoice__c));
                system.debug('@@@directInvoiceMap@@@@'+directInvoiceMap.keySet());
                
                // GCP-399 alternate mapping: if case specified a specific invoice, get that one.
                if (currCase.Invoice__c!=null) currInvoice = directInvoiceMap.get(currCase.Invoice__c);
                
                mapOrderToCase(currCase, currOrder);
                system.debug('@@@@currInvoice@@@@'+currInvoice);
                if (currInvoice!=null){
                    // map the invoice field
                    currCase.Invoice__c = currInvoice.Id;
                    
                    mapInvoiceToCase(currCase, currInvoice);
                }
            }
        }
       // system.debug('@@@currCase@@@'+currCase);
         // system.debug('@@@currInvoice@@@'+currInvoice);
        
    }
    
    public void mapOrderToCase(Case currCase, Order currOrder){
        System.debug('*** mapOrderToCase');
        //currCase.Mode_of_Transport__c = currOrder.Mode_of_Transport__c;
        currCase.Order_Date__c = currOrder.EffectiveDate;
        currCase.Order_Type_Picklist__c = currOrder.Doc_Type_Desc__c;
        currCase.Order_Type__c = currOrder.Doc_Type__c;
        
        currCase.Sold_to_Name__c = currOrder.Sold_To__c;
        currCase.Ship_To_Company__c = currOrder.Ship_To__c;
        currCase.P_O__c = currOrder.PoNumber;
        currCase.Warehouse__c = currOrder.plant_desc__c;
    }
    public void mapInvoiceToCase(Case currCase, Invoice__c currInvoice){
        System.debug('*** mapInvoiceToCase');

        currCase.Sold_to_Name__c = currInvoice.Sold_To_Lookup__c;
        currCase.Ship_To_Company__c = currInvoice.Ship_To_Lookup__c;
        
        currCase.Billing_Date__c = currInvoice.Billing_Date__c;
        currCase.Carrier__c = currInvoice.Carrier__c;
        currCase.Carrier_Name__c = currInvoice.Carrier_Name__c;
        currCase.Curr__c = currInvoice.Curr__c;
        currCase.Inv_Cancelled__c = currInvoice.Inv_Cancelled__c;
        currCase.Inv_Type__c = currInvoice.Inv_Type__c;
        currCase.Inv_Type_Desc__c = currInvoice.Inv_Type_Desc__c;
        currCase.Invoice_Number__c = currInvoice.Invoice_Number__c;
        currCase.Load_Number__c = currInvoice.Load_Number__c;
        currCase.Net_Value__c = currInvoice.Net_Value__c;
        currCase.Payer__c = currInvoice.Payer__c;
        
        Plants__c currPlant=null;
        if (String.isNotBlank(currInvoice.Plant__c)) currPlant = codeToPlantMap.get(currInvoice.Plant__c);
        if (currPlant!=null) currCase.Plants__c = currPlant.Id;
        currCase.Warehouse__c = currInvoice.Plant_Name__c;
        
        currCase.P_O__c = currInvoice.PO_Number__c;
        currCase.Sales_Org__c = currInvoice.Sales_Org__c;
        currCase.Sales_Org_Name__c = currInvoice.Sales_Org_Name__c;
        currCase.Ship_Date__c = currInvoice.Ship_Date__c;
        currCase.Shipment_Number__c = currInvoice.Shipment_Number__c;
        currCase.Total_Freight__c = currInvoice.Total_Freight__c;
        
        
        currCase.Shipment__c = currInvoice.Shipment_Number__c;
        currCase.Carrier_Name__c = currInvoice.Carrier_Name__c;
        
        currCase.Territory__c = currInvoice.Territory__c;
    }
    
    // -------------------------------------------------------------------------------------------------------------------------------
    // this method should be called AFTER Order and invoice mapping
    // this method will bring in missing Sold to's and bring in Ship to / sold to info onto the case
    public void processSoldToShipTo(List<Case> newList){
        Set<Id> accountIds = new Set<Id>();
        
        
        for (Case currCase : newList){
            if (currCase.Sold_to_Name__c!=null) accountIds.add(currCase.Sold_to_Name__c);
            if (currCase.Ship_To_Company__c!=null) accountIds.add(currCase.Ship_To_Company__c);
            System.debug('***Alan currCase.Sold_to_Name__c is ' + currCase.Sold_to_Name__c);
            System.debug('***Alan currCase.Ship_To_Company__c is ' + currCase.Ship_To_Company__c);
        }

        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT Id, JDE_Hierarchy_Level__c, RSM__c, TM__c, ParentId, BillingCountry, OwnerId, SAP_ACCOUNT__c
             FROM Account 
             WHERE Id in :accountIds]
        );
        
        Id chosenAccount = null;
        System.debug('*** getting to it: ');
        for (Case currCase : newList){
            System.debug('*** getting to it Details: ' + currCase.Sold_to_Name__c);
            if (currCase.Ship_To_Company__c != null){
                chosenAccount = currCase.Ship_To_Company__c;
                
                if (currCase.Sold_to_Name__c==null){
                    Account currShipTo = accountMap.get(currCase.Ship_To_Company__c);

                    if (currShipTo.JDE_Hierarchy_Level__c=='Sold-To') {
                        System.debug('*** setting sold to to the shipToCompany: ' + currCase.Ship_To_Company__c);
                        if(currCase.Sold_to_Name__c != currCase.Ship_To_Company__c) currCase.Sold_to_Name__c = currCase.Ship_To_Company__c;
                    }else {
                        System.debug('*** setting sold to to the shipTos parent: ' + currShipTo.ParentId);
                        if(currCase.Sold_to_Name__c != currShipTo.ParentId) currCase.Sold_to_Name__c = currShipTo.ParentId;
                    }
                }
            }
            else if (currCase.Sold_to_Name__c != null && currCase.Ship_To_Company__c==null){
                chosenAccount = currCase.Sold_to_Name__c;
            }
            
            // this is how we achieve Confidential / dont assign AccountId if we need to hide it from Sales
            System.debug('***Alan case.accountid is ' + currCase.AccountId);
            System.debug('***Alan chosenAccount is ' + chosenAccount);
            currCase.AccountId = null;
            setConfidentialCheckbox(currCase);
            if (isConfidential(currCase)!=true)  {
                System.debug('***Alan notConfidential and chosenAccount is ' + chosenAccount);
                currCase.AccountId = chosenAccount;
            }
            
            
            // fill in more data
            Account currAcct = accountMap.get(chosenAccount);
            if (currAcct!=null){
                currCase.Country__c = currAcct.BillingCountry;
                currCase.Sales_Rep__c = currAcct.OwnerId;
            }
        }
    }
    public void setConfidentialCheckbox(Case currCase){
        // Price Protection behaves exactly like Confidential, so we will set that checkbox
        if (currCase.Type_of_Discount__c == 'Price Protection') currCase.Confidential__c = true;
    }
    public boolean isConfidential(Case currCase){
        System.debug('*** Confidential__c' + currCase.Confidential__c);
        System.debug('*** Type_of_Discount__c' + currCase.Type_of_Discount__c);
        System.debug('*** recordtype.name is ' + currCase.recordtype.name);
        return (currCase.Confidential__c ||
                currCase.Type_of_Discount__c == 'Price Protection' ||
                currCase.RecordTypeId == rebateRecordTypeId ||
                currCase.RecordTypeId == rebateRecordTypeIdUS ||
                //--GCP-537: Added these record types to Confidential logic 
                currCase.RecordTypeId == priceExceptionRecordTypeId ||
                currCase.RecordTypeId == salesAdjustmentSpecialsRecordTypeId ||
                currCase.RecordTypeId == salesAdjustementFreightAllowanceRecordTypeId);
    }

    public void checkProcessSoldToShipTo(List<Case> newList, Map<Id, Case> oldMap){
        List<Case> workingList = new List<Case>();
        for (Case currCase : newList){
            if( (currCase.Sold_To_Name__c!=null && oldMap.get(currCase.Id).Sold_To_Name__c != currCase.Sold_To_Name__c) ||
               (currCase.Ship_To_Company__c!=null && oldMap.get(currCase.Id).Ship_To_Company__c != currCase.Ship_To_Company__c) ||
               ( oldMap.get(currCase.Id).Confidential__c != currCase.Confidential__c )
              ){
                  workingList.add(currCase);
              }
        }
        processSoldToShipTo(workingList);
    }
    
    
    
    
    //This function will give read access on newly created case(that are not cloned)
    //to the owners of sold to and ship tos available on the case
    public void shareCasesWithOutRebatesToSoldToOwners(List<Case> insertedCaseList){
        
        //variable decalaration and Initialization.
        Set<Id> soldToAccountIdSet = new  Set<Id>();
        List<Account> soldToShipToList;
        Map<Id, List<Account>> soldToShipToMap = new Map<Id, List<Account>>();
        Map<Id, List<Account>> caseIdToShipToMap = new Map<Id, List<Account>>();
        Map<Id, List<Account>> caseIdToSoldToMap = new  Map<Id, List<Account>>();
        
        Set<Id> soldToSet = new Set<Id>();
        
        
        
        for( Case c : insertedCaseList){
            if(c.Sold_To_Name__c != null)
                soldToAccountIdSet.add(c.Sold_To_Name__c);
        }
        
        soldToShipToList = ([Select Id, OwnerId, (Select ID, OwnerId from ChildAccounts) 
                             FROM Account
                             WHERE Id IN : soldToAccountIdSet]);
        
        Map<Id, Account> soldToMap = new Map<Id, Account>([SELECT Id, OwnerId 
                                                           FROM Account
                                                           WHERE Id IN : soldToAccountIdSet]);
        
        for(Account a : soldToShipToList){
            soldToShipToMap.put(a.Id, a.ChildAccounts);
        }
        
        Map<Id, RecordType> CaseRecordIdMap = new Map<Id, RecordType>([SELECT Id, Name 
                                                                       FROM RecordType 
                                                                       WHERE Name IN ('Sales Adjustment Price Exception',                                                                                      
                                                                                      'Sales Adjustment Specials',
                                                                                      'Sales Adjustment Freight Allowance')]); 
        
        system.debug('soldToShipToList : '+soldToShipToList);
        /* Commented by Sunny 04 Feb 2021, CT_PriceExceptionRelatedAcctSharingCtrl doesn't exist
        CT_PriceExceptionRelatedAcctSharingCtrl objShr = new CT_PriceExceptionRelatedAcctSharingCtrl();
        if(insertedCaseList.size() == 1){
            for(Case cas : insertedCaseList){
                if(!cas.IsClone__c &&
                   soldToShipToMap.containsKey(cas.Sold_to_Name__c) &&
                   CaseRecordIdMap.containsKey(cas.RecordTypeId) ){
                       
                       //   system.debug('Entered since they are new Cases,  caseShr.Id ' + cas.Id + ' soldToShipToMap.get(cas.Sold_to_Name__c) '+soldToShipToMap.get(cas.Sold_to_Name__c));
                       objShr.manualShareRead(cas.Id, soldToShipToMap.get(cas.Sold_to_Name__c) );
                       List<Account> soldToShare = new List<Account>{ soldToMap.get(cas.Sold_to_Name__c) };
                           objShr.manualShareRead(cas.Id, soldToShare);    //Commented the line - kk - S-577115 //Comment removed - Sandip - To show case on associated case section of Parent (Payer) account - Dec 2018
                       
                   }
            }
        }
        */
        
    }
    
    
    
    
    // This function will create Case Items --------------------------------------------------------------------------------------
    public void createCaseItems(List<Case> insertedCaseList){
        //variable decalaration and Initialization.
        List<case_order_items__c> insertCaseItemList = new List<case_order_items__c>();
        
        // list used to quickly retreive line item data by using parent Ids
        Map<id,List<orderItem>> orderIdAndOrderItemsListMap = new Map<id,List<orderItem>>();
        Map<id,List<Invoice_Line_Item__c>> invoiceIdAndInvoiceItemsListMap = new Map<id,List<Invoice_Line_Item__c>>();
        
        // maps used to retieve product ids for line items
        Map<Id,String> invoiceLineIdItemToMaterialId = new Map<Id,String>();
        Set<String> sapMaterialStringSet = new Set<String>();
        Map<String,Id> productMap = new Map<String,Id>();
        
        
        Set<id> orderIdSet = new Set<id>();
        Set<id> invoiceIdSet = new Set<id>();
        Map<id,id> caseAndOrderIdMap = new Map<id,id>();
        Map<id,id> orderIdAndInvoiceIdMap = new Map<id,id>();
        
        for(case c: insertedCaseList){
            if(c.order__c!=null){
                orderIdSet.add(c.order__c);
                invoiceIdSet.add(c.Invoice__c);
                caseAndOrderIdMap.put(c.id,c.order__c);
                orderIdAndInvoiceIdMap.put(c.Order__c,c.Invoice__c);
            }
        }
        
        
        if(!orderIdSet.isEmpty()){
            
            Map<Id,String> invoiceIdAndSalesOrgMap = new Map<Id,String>();
            for(Invoice__c inv : [select id,Order__c,Order__r.Sales_Org__c from Invoice__c where Order__c IN: orderIdSet]){
                orderIdAndInvoiceIdMap.put(inv.Order__c,inv.Id);
                invoiceIdAndSalesOrgMap.put(inv.Id,inv.Order__r.Sales_Org__c);
                invoiceIdSet.add(inv.Id);
            }
            system.debug('G*G order invoice Map'+orderIdAndInvoiceIdMap);
            
            // this will query for order items given in OrderId Set
            List<orderItem> orderItemsList = CT_CaseTriggerHelper.returnOrderItemsList(orderIdSet);
            
            if(!orderItemsList.isEmpty()){
                for(orderItem orderItems: orderItemsList){
                    List<orderItem> tempOrderItemList = new List<orderItem>();
                    if(!orderIdAndOrderItemsListMap.containsKey(orderItems.orderId)){
                        tempOrderItemList.add(orderItems);
                        orderIdAndOrderItemsListMap.put(orderItems.orderId,tempOrderItemList);
                    }
                    else{
                        tempOrderItemList = orderIdAndOrderItemsListMap.get(orderItems.orderId);
                        tempOrderItemList.add(orderItems);
                        orderIdAndOrderItemsListMap.put(orderItems.orderId,tempOrderItemList);
                    }
                }
            }
            
            if(!invoiceIdSet.isEmpty()){
                
                // this will query for invoice line items given in OrderId Set
                List<Invoice_Line_Item__c> invoiceLineItemList = CT_CaseTriggerHelper.returnInvoiceLineItemList(invoiceIdSet);
                System.debug(' **** invoiceLineItemList.size() is ' + invoiceLineItemList.size());
                
                if(!invoiceLineItemList.isEmpty()){
                    system.debug('G*G invoice sales org map'+invoiceIdAndSalesOrgMap);
                    
                    
                    for(Invoice_Line_Item__c invoiceItem: invoiceLineItemList){
                        // collect into invoiceLineIdItemToMaterialId the prodict code needed for each invoice line item
                        if(invoiceIdAndSalesOrgMap.containsKey(invoiceItem.Invoice__c) && invoiceIdAndSalesOrgMap.get(invoiceItem.Invoice__c)!=null){
                            system.debug('G*G inside invoice item map');
                            
                            String tempString = invoiceItem.Material__c+'-'+invoiceIdAndSalesOrgMap.get(invoiceItem.Invoice__c);
                            System.debug('**** tempString ' + tempString);
                            sapMaterialStringSet.add(tempString);
                            invoiceLineIdItemToMaterialId.put(invoiceItem.Id,tempString);
                        }
                        
                        // collect into invoice line items into lists that are easy to lookup.
                        if(!invoiceIdAndInvoiceItemsListMap.containsKey(invoiceItem.Invoice__c)){
                            List<Invoice_Line_Item__c> tempInvoiceList = new List<Invoice_Line_Item__c>();
                            tempInvoiceList.add(invoiceItem);
                            invoiceIdAndInvoiceItemsListMap.put(invoiceItem.Invoice__c,tempInvoiceList);   
                        }
                        else{
                            List<Invoice_Line_Item__c> tempInvoiceList = invoiceIdAndInvoiceItemsListMap.get(invoiceItem.Invoice__c);
                            tempInvoiceList.add(invoiceItem);
                            invoiceIdAndInvoiceItemsListMap.put(invoiceItem.Invoice__c,tempInvoiceList);
                        }
                    }
                }
            }
            
            if(!sapMaterialStringSet.isEmpty()){
                for(Product2 p:[Select id,Name,SAP_Material__c From Product2
                                Where SAP_Material__c In: sapMaterialStringSet]){
                                    productMap.put(p.SAP_Material__c,p.Id);
                                }
            }
            
            insertCaseItemList = CT_CaseTriggerHelper.returnInsertCaseListItem(insertedCaseList, 
                                                                               caseAndOrderIdMap,
                                                                               orderIdAndInvoiceIdMap,
                                                                               orderIdAndOrderItemsListMap,
                                                                               invoiceIdAndInvoiceItemsListMap,
                                                                               productMap,
                                                                               invoiceLineIdItemToMaterialId);
        }
        
        if(!insertCaseItemList.isEmpty()){
            List<database.saveResult> srList = database.insert(insertCaseItemList,false);
            
            for(database.saveResult sr: srList){
                if(!sr.isSuccess()){
                    for(database.error err: sr.getErrors()){
                        system.debug('The following error has occurred.');                    
                        system.debug(err.getStatusCode() + ': ' + err.getMessage());
                        system.debug('Case Item fields that affected this error: ' + err.getFields());
                    }
                }
                
            }
        }
    }
    
    // ---------------------------------------------------------------------------
    // Update the new Sold to based on the new ship to
    public void processNewShipToNewSoldTo(List<Case> updatedCaseList){
        Set<Id> shipToAccountIds = new Set<Id>();
        List<Case> workingList = new List<Case>();
        
        for (Case c : updatedCaseList){
            if(c.Rebill_Different_Customers__c!='Yes' && c.Rebill_Ship_To__c!=null){
                c.addError('You can not add a "Rebill Ship To" value without "Rebill Different Customers" field being Yes.');
                continue;
            }
            
            if(c.Rebill_Different_Customers__c=='Yes' && c.Rebill_Ship_To__c==null){
                c.addError('You have to add a value in the "Rebill Ship To" field');
                continue;
            }
            
            if (c.Rebill_Ship_To__c==null) c.Rebill_Sold_To__c=null;
            
            if (c.Rebill_Ship_To__c!=null){
                shipToAccountIds.add(c.Rebill_Ship_To__c);
                workingList.add(c);
            }
            
        }
        
        if (shipToAccountIds.size() > 0 ){
            Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, RecordType.Name, ParentId FROM Account WHERE Id in :shipToAccountIds]);
            
            for (Case currCase : workingList){
                Account shipToAcct = accountMap.get(currCase.rebill_ship_to__c);
                if (shipToAcct!=null){
                    if (shipToAcct.RecordType.Name      == 'Sold-To') currCase.rebill_sold_to__c = shipToAcct.Id;
                    else if (shipToAcct.RecordType.Name == 'Ship-To') currCase.rebill_sold_to__c = shipToAcct.ParentId;
                }
            }
        }
        
    }
    public void checkProcessNewShipToNewSoldTo(List<Case> newList, Map<Id, Case> oldMap){
        
        List<Case> workingList = new List<Case>();
        List<Id> ceilingsRTs = new List<Id>();
        ceilingsRTs.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId());
        ceilingsRTs.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing').getRecordTypeId());
        ceilingsRTs.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality').getRecordTypeId());

        for (Case currCase : newList){
            if( (oldMap.get(currCase.Id).Rebill_Different_Customers__c != currCase.Rebill_Different_Customers__c) ||
               ( oldMap.get(currCase.Id).rebill_ship_to__c != currCase.rebill_ship_to__c )
              ){
                System.debug('&&& currCase.recordTypeid is '+ currCase.recordTypeid);
                if (!ceilingsRTs.contains(currCase.recordTypeid))
                        workingList.add(currCase);
              }
        }


        processNewShipToNewSoldTo(workingList);
        
    }
    public void handleOwnerUpdate(Set<Id> updatedCaseIdSet){
        /* Commented by Sunny 04 Feb 2021, CT_PriceExceptionRelatedAcctSharingCtrl doesn't exist
        List<CaseShare> caseShareList = [SELECT Id, CaseId, UserOrGroupId, RowCause, CaseAccessLevel FROM CaseShare where CaseId IN :updatedCaseIdSet];
        String caseShare = SYSTEM.JSON.serialize(caseShareList);
        CT_PriceExceptionRelatedAcctSharingCtrl.createReadManualShare(caseShare);
        */
    }
    
    
    public void validation_checkForIssues(List<Case> updatedCaseList, Map<Id,Case> updatedCaseMap){
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id, String> hasIssuesCaseIdMap = new Map<Id, String>();
        List<Case> workingList = new List<Case>();
        Map<Id, Id> caseToOrderIds = new Map<Id, Id>();
        //updated Case Status equal to pending TM reference to Pending Rep in if clause 
        for(case c: updatedCaseList){
            if ((
                (c.Status!='Draft' && updatedCaseMap.get(c.Id).Status == 'Draft') ||
                (c.Status!='Pending Investigator' && updatedCaseMap.get(c.Id).Status == 'Pending Investigator') ||
                (c.Status!='Pending CSM' && updatedCaseMap.get(c.Id).Status == 'Pending CSM') ||
                (c.Status!='Pending TM' && updatedCaseMap.get(c.Id).Status == 'Pending TM')
            )
                &&
                (c.recordTypeId == qualityRecordTypeId ||
                 c.recordTypeId == pricingRecordTypeId ||
                 c.recordTypeId == serviceRecordTypeId ||
                 c.recordTypeId == manQualityRecordTypeId
                )
               ){
                   caseIdSet.add(c.id);
                   workingList.add(c);
               }
            if (c.Order__c != null) caseToOrderIds.put(c.Id, c.Order__c);
        }
        // lets retreive order info as there is different validation for normal orders vs stock transfers
        Map<Id, Order> orderMap = new Map<Id, Order>();
        if (caseToOrderIds.isEmpty()==false){
            orderMap = new Map<Id, Order>([SELECT id, Doc_Type__c FROM Order where Id in :caseToOrderIds.values()]);
        }
        
        if(!caseIdSet.isEmpty() || Test.isRunningTest()){
            
            for(Issues__c issue: [Select Id,Case__c,Category__c,Problem__c From Issues__c Where Case__c In: caseIdSet and RecordTypeId =: issuesRecordTypeId]){
                if (hasIssuesCaseIdMap.containsKey(issue.Case__c)==false) hasIssuesCaseIdMap.put(issue.Case__c, null);
                
                if ( String.isBlank(issue.Category__c) || String.isBlank(issue.Problem__c) ) hasIssuesCaseIdMap.put(issue.Case__c,'ValidationError');
            }
            
            for(Issues__c issue: [Select Id,Case__c,QTY__c,PRC__c,Product__c From Issues__c Where Case__c In: caseIdSet and (RecordTypeId =: creditRecordTypeId
                                                                                                                             or RecordTypeId =: rebillRecordTypeId)]){
                                                                                                                                 
                                                                                                                                 Order currOrder = null;
                                                                                                                                 if ( caseToOrderIds.containsKey(issue.Case__c) ) currOrder = orderMap.get(caseToOrderIds.get(issue.Case__c));
                                                                                                                                 
                                                                                                                                 if ( issue.Product__c==null || issue.QTY__c==null || issue.QTY__c==0.00 ||
                                                                                                                                     ( 
                                                                                                                                         // for no price, this is allowed for Stock transfers (Doc type NBC3 / NBC4)

                                                                                                                                         (issue.PRC__c==null || issue.PRC__c==0.00 ) &&
                                                                                                                                         (currOrder != null && currOrder.Doc_Type__c!='NBC3' && currOrder.Doc_Type__c!='NBC4')
                                                                                                                                     )
                                                                                                                                    ){
                                                                                                                                        hasIssuesCaseIdMap.put(issue.Case__c,'CreditRebillError');
                                                                                                                                    }
                                                                                                                             }
        }
        
        // Validation rules
        for(case c: workingList){
            if(!hasIssuesCaseIdMap.containsKey(c.Id)) c.addError('Please add at least one Issue the case.');
            else if(hasIssuesCaseIdMap.get(c.Id)=='ValidationError') c.addError('Please ensure all issues have Category and Problem selected');
            else if(hasIssuesCaseIdMap.get(c.Id)=='CreditRebillError') c.addError('Please ensure that all credit/rebill entries have Product, Quantity '+ 
                                                                                  'and Price values filled or delete the entry and create a new one.');
        }
    }
    
    public Set<String> setCaseRecordTypes 
    {
        get 
        {
            if(setCaseRecordTypes == null)
            {
                setCaseRecordTypes = new Set<String>();
                for(String rt : Schema.SObjectType.Case.getRecordTypeInfosById().keyset())
                    setCaseRecordTypes.add(rt);
            }
            return setCaseRecordTypes;
        }
        set;
    }
    
    /*
    public Set<String> getCaseRecordTypes(){
        Set<String> recordTypeSet = new Set<String>();
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment No Charge US').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portal').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Closed').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Closed').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Closed').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manual Adjustment').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Manual Quality Entry Case').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Case').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Case').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Cheque Request').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Credit Request').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment No Charge').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Email').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('General Call').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Incident').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Incident').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality RMA Incident').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Incident').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Price Negotiation Incident').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service RMA Incident').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Recon/Redelivery Incident').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Marketing').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Transportation Incident').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Email Case').getRecordTypeId());
        recordTypeSet.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Finishing Case Support').getRecordTypeId());
        return recordTypeSet; 
    }
*/
    
}