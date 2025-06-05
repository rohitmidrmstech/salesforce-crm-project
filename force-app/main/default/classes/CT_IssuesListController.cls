/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Controller class for CT_IssuesListView lightning component.
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Deepak Regala (dregala@liquidhub.com)
* @verstion       1.0
* @created        2017-06-14
*/
public without sharing class CT_IssuesListController {
    
    /* Function to return list of issues records.
* @param
*     - caseId : that issues related to.
*     - recordTypeName : Record type name Issues/Credit/Rebill
* @return - List of Issues__c object records.
* @description - This function will return the issues related to case.   76, 77, 83, 
*/
    @AuraEnabled
    public static List<IssueData> fetchIssuesData(String caseId, String recordTypeName) {
        
        // Variables initialization
        Boolean hasFilter = false;
        List<IssueData> issuesList = new List<IssueData>();
        String recordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        system.debug('rec type id'+recordTypeId);
        // Build query on Issues__c object
        String issuesQuery = ' SELECT Case_Order_Item__c, Case_Order_Item__r.Name, Case__c, Category__c, Code__c, ' +
            ' Order_Type_Code__c, Case__r.Rebill_Different_Customers__c, '+
            ' Details__c, Group__c, Id, ID__c, Issue_Type__c, Name,Problem__c, Status__c, Case__r.Status, ' +
            ' Case_Order_Item__r.Product__r.Name, QTY_ORD__c, UOM__c, EXT_QTY__c, UOM2__c, ' +
            ' UNIT_PRICE__c, EXT_AMOUNT__c, QTY__c, PRC__c, Discount__c, EXT_AMOUNT2__c, ' +
            ' Case_Order_Item__r.Product__r.Description, Product__c, Product__r.Name, ' +
            ' Inserted_From_Trigger__c, Product__r.Description, Product__r.CORP_CLASS__c, ' +
            ' Case_Order_Item__r.Price_Uom__c, Product__r.productCode, Ext_Qty_Conversion__c, '+
            ' RecordTypeId, RecordType.Name ' +
            ' FROM Issues__c ';
        
        // Filters
        if(String.isNotBlank(caseId)){
            issuesQuery += ' WHERE Case__c = :caseId ';
            hasFilter = true;
        }
        if(String.isNotBlank(recordTypeId)){
            if(hasFilter)
                issuesQuery += ' AND RecordTypeId = :recordTypeId ';
            else
                issuesQuery += ' WHERE RecordTypeId = :recordTypeId ';
        }
        issuesQuery +=' ORDER BY CREATEDDATE ';
        
        system.debug('list of issues'+Database.query(issuesQuery));
        for(Issues__c issue : Database.query(issuesQuery)){
            issuesList.add(new IssueData(issue));
        }
        
        return issuesList;
    }
    
    public static String getUserProfileName(){
        return [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
    }
    
    public static List<String> getUserGroupNames(){
        List<String> groupNames = new List<String>();
        List<GroupMember> gNames = [SELECT Id, Group.Type, Group.Name from GroupMember Where UserOrGroupId = :UserInfo.getUserId() AND Group.Type = 'Regular'];
        if(gNames.size() > 0){
            for(GroupMember gn : gNames){
                groupNames.add(gn.Group.Name);
            }
        }
        return groupNames;
    }
    
    @AuraEnabled
    public static List<IssueData> fetchIssuesPrice(Id caseId, String issuesJson)
    {
        Set<String> materialIds = new Set<String>();
        Map<String,List<IssueData>> issueByProdCode = new Map<String,List<IssueData>>();
        System.debug('G*G issue json'+issuesJson);
        System.debug(LoggingLevel.INFO,'>>>> issues'+issuesJson);
        List<IssueData> issuesList = (List<IssueData>)JSON.deserialize(issuesJson, List<IssueData>.class);
        
        String shipToAccountNo = '';
        String soldToAccountNo = '';
        String salesOrg = '';
        
        Case caseRecord = [SELECT Country__c, Sales_Org__c,Ship_to_No__c, Sold_to_No__c, Rebill_Different_Customers__c,
                           rebill_ship_to__c, rebill_sold_to__c, rebill_ship_to__r.SAP_ACCOUNT__c, rebill_sold_to__r.SAP_ACCOUNT__c
                           FROM Case WHERE Id=:caseId];
        
        shipToAccountNo = caseRecord.Ship_to_No__c;
        soldToAccountNo = caseRecord.Sold_to_No__c;
        
        if (caseRecord.Rebill_Ship_To__c!=null && String.isNotBlank(caseRecord.Rebill_Ship_To__r.SAP_ACCOUNT__c)){
            shipToAccountNo = caseRecord.Rebill_Ship_To__r.SAP_ACCOUNT__c;
            soldToAccountNo = caseRecord.Rebill_Sold_To__r.SAP_ACCOUNT__c;
        }
        
        salesOrg = caseRecord.Sales_Org__c;
        
        if (String.isEmpty(salesOrg)){
            if (String.isNotEmpty(caseRecord.Country__c)){
                if (caseRecord.Country__c=='USA') salesOrg = '1006';
                else salesOrg = '1100';
            }
        }
        
        for(IssueData issue : issuesList)
        {
            
            System.debug(LoggingLevel.INFO,'>>>> issue'+issue);
            
            if(String.isNotBlank(issue.productCode)
               && (caseRecord.Rebill_Different_Customers__c=='Yes' || issue.insertedFromTrigger==null || issue.insertedFromTrigger==false)
               && issue.isEdit==true)
            {
                if(!issueByProdCode.containsKey(issue.productCode)){
                    List<IssueData> tempIssueDataList = new List<IssueData>();
                    tempIssueDataList.add(issue);
                    issueByProdCode.put(issue.productCode,tempIssueDataList);
                }
                else{
                    List<IssueData> tempIssueDataList =  issueByProdCode.get(issue.productCode);
                    tempIssueDataList.add(issue);
                    issueByProdCode.put(issue.productCode,tempIssueDataList);
                }
                
                materialIds.add(issue.productCode);
            }
        }
        
        System.debug(LoggingLevel.INFO,'>>>> Material Ids'+materialIds);
        System.debug(LoggingLevel.INFO,'>>>> Ship To Account No'+shipToAccountNo);
        System.debug(LoggingLevel.INFO,'>>>> Sold To Account No'+soldToAccountNo);
        System.debug(LoggingLevel.INFO,'>>>> Sales Org'+salesOrg);
        
        if (materialIds.isEmpty()==false){
            CT_PricingWebService pricingWebService = new CT_PricingWebService();
            Map<String, CT_PricingWebService.PriceInfoContainer> mapPriceInfoContainer = pricingWebService.getPriceInfo(materialIds, soldToAccountNo, shipToAccountNo, Date.today(), salesOrg);
            
            for(String materialId : materialIds)
            {
                List<IssueData> issueDataList = issueByProdCode.get(materialId);
                if(!issueDataList.isEmpty()){
                    for(IssueData issue: issueDataList) {
                        CT_PricingWebService.PriceInfoContainer pricingContainer =  mapPriceInfoContainer.get(issue.productCode);
                        System.debug('pricingContainer '+pricingContainer);
                        if(pricingContainer != null)
                        {
                            system.debug('issue:'+issue);
                            
                            // find out if we have a ZP01 and if not, see if we have a ZP00
                            Decimal webServicePrice = pricingContainer.discountedPriceObject.condValue;
                            
                            if (webServicePrice==null || webServicePrice==0) webServicePrice = pricingContainer.listPriceObject.condValue;
                            if (webServicePrice==null) webServicePrice=0;
                            System.Debug(salesOrg+' : Price for material '+materialId+' : '+webServicePrice);
                            issue.price = String.valueOf(webServicePrice);
                            
                            // calculate extended amount 2
                            Decimal tempDecimalValue = 0;
                            
                            Decimal extQtyConversion = String.isNotBlank(issue.quantityConversion) ? Decimal.valueOf(issue.quantityConversion) : 1;
                            
                            Decimal quantity = (String.isNotBlank(issue.quantity) ? Decimal.valueOf(issue.quantity) : 0);
                            Decimal extendedQuantity = quantity * extQtyConversion;
                            issue.exactQuantity = String.valueOf( Math.abs(extendedQuantity.setScale(4)) );
                            
                            Decimal price = (String.isNotBlank(issue.price) ? Decimal.valueOf(issue.price) : 0); // price was just set from Web Service
                            Decimal discount = (String.isNotBlank(issue.discount) ? Decimal.valueOf(issue.discount) : 0);
                            if (caseRecord.Rebill_Different_Customers__c=='Yes') discount = 0.00;
                            
                            tempDecimalValue = Math.abs( extendedQuantity * price - (extendedQuantity * price * 0.01 * discount) );
                            
                            // check what sign the value should have
                            Decimal extendedAmount1 = String.isNotBlank(issue.exactAmount_1) ? Decimal.valueOf(issue.exactAmount_1) : 0;
                            if ( extendedAmount1 < 0 ) tempDecimalValue = -tempDecimalValue;
                            if (issue.recordTypeName == 'Credit') tempDecimalValue = -tempDecimalValue;
                            
                            issue.exactAmount_2 = String.valueOf(tempDecimalValue.setScale(2));
                            issue.discount = String.ValueOf(discount);
                        }
                    }
                }
            }
        }
        
        return issuesList;
        
    }
    
    @AuraEnabled
    public static String deleteIssuesData(String issueId){
        system.debug('G*G apex delete called');
        List<Issues__c> deleteIssuesList = new List<Issues__c>();
        
        deleteIssuesList = [Select id From Issues__c where Id=: issueId];
        if(!deleteIssuesList.isEmpty()){
            delete deleteIssuesList;
        }
        return 'Success';
    }
    
    
    /* Function to update modified list of Issues__c records.
* @param - Modified list of IssueData instances.
* @return - status of the dml operation.
* @description - This function will update the Issues__c information.
*/
    @AuraEnabled
    public static String updateIssuesListData(String issuesJson) {
        String creditRecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Credit').getRecordTypeId();
        
        system.debug('issue json'+issuesJson);
        String status = 'Success';
        
        List<Issues__c> listOfIssues = new List<Issues__c>();
        List<IssueData> issuesdata = (List<IssueData>)JSON.deserialize(issuesJson, List<IssueData>.class);
        
        for(IssueData issue : issuesdata){
            
            // Create Issues__c object with provided record Id to update.
            Issues__c isu = new Issues__c(Id = issue.issueId);
            if(String.isNotBlank(issue.category) && issue.category != '--None--')   isu.Category__c = issue.category;
            if(String.isNotBlank(issue.problem) && issue.problem != '--None--')     isu.Problem__c = issue.problem;
            
            
            
            isu.QTY__c = String.isNotBlank(issue.quantity) ? Decimal.valueOf(issue.quantity) : null;
            isu.PRC__c = String.isNotBlank(issue.price) ? Decimal.valueOf(issue.price) : null;
            isu.Discount__c = String.isNotBlank(issue.discount) ? Decimal.valueOf(issue.discount) : null;
            
            
            // force a certain formatting ---------------------
            if (isu.QTY__c != null) isu.QTY__c = Math.abs(isu.QTY__c);
            if (issue.recordTypeId==creditRecordTypeId) isu.QTY__c = -(Math.abs(isu.QTY__c));
            
            if (isu.Discount__c != null) isu.Discount__c = Math.abs(isu.Discount__c); // discount is always +
            // note price can be + or negative, but it doesn't matter as we will force the sign to be relative to Extended amount 1
            
            
            // calculate extended amount ---------------------------------------------------------------------
            Decimal extQtyConversion = String.isNotBlank(issue.quantityConversion) ? Decimal.valueOf(issue.quantityConversion) : null;
            
            Decimal quantity = (isu.QTY__c!=null? isu.QTY__c: 1);
            Decimal quantityConv = (extQtyConversion!=null? extQtyConversion: 1);
            Decimal extendedQuantity = quantity * quantityConv;
            
            if (issue.insertedFromTrigger==false)
                isu.EXT_QTY__c = Math.abs(extendedQuantity);
            
            Decimal price = (isu.PRC__c!=null? isu.PRC__c: 0.00);
            Decimal discount = (isu.Discount__c!=null? isu.Discount__c: 0.00);
            Decimal discountFactor = (1 - (discount/100));
            
            Decimal extendedAmt = 0.00;
            extendedAmt = (price * discountFactor) * extendedQuantity;
            // calculate extended amount end -----------------------------------------------------------------
            
            
            // make sure the sign is the same as what is shown on the extended amount 1 field
            Decimal issueExtendedAmount = String.isBlank(issue.exactAmount_1) ? 0 : Decimal.valueOf(issue.exactAmount_1);
            isu.EXT_AMOUNT2__c = Math.abs(extendedAmt);
            if ( issueExtendedAmount < 0)
            {
                isu.EXT_AMOUNT2__c = - Math.abs(isu.EXT_AMOUNT2__c);
            }
            if (issue.recordTypeId==creditRecordTypeId)  isu.EXT_AMOUNT2__c = -isu.EXT_AMOUNT2__c; // credits show opposite sign of ext amt 1
            
            isu.Details__c = issue.details;
            listOfIssues.add(isu);
        }
        
        
        // Update operation for list of Issues__c
        update listOfIssues;
        return status;
    }
    
    public static String getBusinessUnit (String recordTypeName) {
        System.debug('&&&& recordTypeName is -' + recordTypeName + '-');
        if (recordTypeName == 'Quality' || recordTypeName == 'Pricing' || recordTypeName == 'Service') {
            System.debug('%%%% returning ceilings');
            return 'Ceilings';
        }
        return 'Gypsum';
    }
    
    public static String getIssueType(String recordTypeName) {
        if (recordTypeName.indexOf('Quality') > -1)
            return 'Quality';
        if (recordTypeName.indexOf('Pricing') > -1)
            return 'Pricing';
        return 'Service';
        
    }
    
    
    
    
    /* Function to return pick list values related to issues.
* @return
*     - picklist values for Category__c field
*     - picklist values for Problem__c field
* @description - This function will return the IssuePickListEntries data.
*/
    @AuraEnabled
    public static Map<String,List<String>> getPickListEntries(String caseId){
        Case theCase = getCaseDetails(caseId);
        String bizUnit = getBusinessUnit(theCase.recordType.name);
        String issueType = getIssueType(theCase.recordType.name);
        
        List<CT_Issues_Problem_Code__c> issuesCS = new List<CT_Issues_Problem_Code__c>();   
        if(theCase.recordType.name == 'Quality Case' || theCase.recordType.name == 'Service Case' || theCase.recordType.name == 'Manual Quality Entry Case'){ 
            issuesCS = [select BUSINESS_UNIT__C, CATEGORY__C, PROBLEM__C, ISSUE_TYPE__C,Sales_Org__c    
                        from CT_Issues_Problem_Code__c  
                        //where BUSINESS_UNIT__C = :bizUnit and ISSUE_TYPE__C = :issueType];
                        Where ISSUE_TYPE__C = :issueType and Sales_Org__c =: theCase.Sales_Org__c ];    
        }   
        else{   
            issuesCS = [select BUSINESS_UNIT__C, CATEGORY__C, PROBLEM__C, ISSUE_TYPE__C,Sales_Org__c   
                        from CT_Issues_Problem_Code__c  
                        where BUSINESS_UNIT__C = :bizUnit   
                        and ISSUE_TYPE__C = :issueType  ];  
        }
        Map<String,List<String>> issuesPickValMap = new Map<String,List<String>>();
        
        issuesPickValMap.put('--None--', new List<String>{'--None--'});
        //Integer count = 0;
        for(CT_Issues_Problem_Code__c isp : issuesCS){
            //System.debug('&&& CT_Issues_Problem_Code__c [' + count + '] is ' + isp.category__c + ' / ' + isp.problem__c
            //            + ' (' + isp.issue_type__c + ', ' + isp.BUSINESS_UNIT__C + ')');
            //count++;
            if(issuesPickValMap.get(isp.Category__c) == null){
                List<String> prblms = new List<String>();
                prblms.add('--None--');
                prblms.add(isp.Problem__c);
                issuesPickValMap.put(isp.Category__c, prblms);
            }else{
                List<String> prblms = issuesPickValMap.get(isp.Category__c);
                prblms.add(isp.Problem__c);
                issuesPickValMap.put(isp.Category__c, prblms);
            }
        }
        System.debug('%%% issuesPickValMap.size() is '+ issuesPickValMap.keySet().size());
        
        for(String currKey: issuesPickValMap.keySet()){
            List<String> currList = issuesPickValMap.get(currKey);
            System.debug('&&& CurrList.size(of ' + currKey + ') = ' + currList.size());
            if (currList!=null){
                Set<String> mySet = new Set<String>();
                mySet.addAll(currList);
                currList.clear();
                currList.addAll(mySet);
                currList.sort();
            }
        }
        System.debug('%%% issuesPickValMap.size()2 is '+ issuesPickValMap.keySet().size());
        
        
        return issuesPickValMap;
    }
    
    @AuraEnabled
    public static Map<String,List<String>> getRecordtypeMap(String caseId){
        Case theCase = getCaseDetails(caseId);
        String bizUnit = getBusinessUnit(theCase.recordType.name);
        //String issueType = getIssueType(theCase.recordType.name);
        System.debug('&&&& bizUnit is ' + bizUnit);
        
        List<CT_Issues_Problem_Code__c> issuesCS = new List<CT_Issues_Problem_Code__c>();   
        if(theCase.recordType.name == 'Quality Case' || theCase.recordType.name == 'Service Case' || theCase.recordType.name == 'Manual Quality Entry Case'){ 
            issuesCS = [select BUSINESS_UNIT__C, CATEGORY__C, PROBLEM__C, ISSUE_TYPE__C,Sales_Org__c    
                        from CT_Issues_Problem_Code__c  
                        where //BUSINESS_UNIT__C = :bizUnit ]; 
                        Sales_Org__c =: theCase.Sales_Org__c ]; 
        }   
        else{   
            issuesCS = [select BUSINESS_UNIT__C, CATEGORY__C, PROBLEM__C, ISSUE_TYPE__C    
                        from CT_Issues_Problem_Code__c  
                        where BUSINESS_UNIT__C = :bizUnit]; 
        }
        
        //List<CT_Issues_Problem_Code__c> issuesCS = CT_Issues_Problem_Code__c.getall().values();
        Map<String,List<String>> rectypeMap = new Map<String,List<String>>();
        
        for(CT_Issues_Problem_Code__c isp : issuesCS){
            if(rectypeMap.get(isp.Issue_Type__c) == null){
                List<String> categories = new List<String>();
                //categories.add(isp.Category__c);
                //System.debug('%%% ... ' + isp.category__c);
                rectypeMap.put(isp.Issue_Type__c, categories);
            }
            List<String> categories = rectypeMap.get(isp.Issue_Type__c);
            Set<String> tempStringSet = new Set<String>();
            tempStringSet.addAll(categories);
            if(!tempStringSet.contains(isp.Category__c)){
                categories.add(isp.Category__c);
                categories.sort();
                rectypeMap.put(isp.Issue_Type__c, categories);
            }
        }
        
        return rectypeMap;
    }
    
    @AuraEnabled
    public static Product2 getProductDetails(String productId){
        Product2 p= [Select Id,Name,MSF_Conversion__c From Product2 Where Id=: productId LIMIT 1];
        return p;
    }
    
    @AuraEnabled
    public static Wrapper getWrapper(String caseId){
        Wrapper w = new Wrapper();
        w.issuesMap = getPickListEntries(caseId);
        w.recordtypeMap = getRecordtypeMap(caseId);
        w.cse = getCaseDetails(caseId);
        w.profileName = getUserProfileName();
        w.groupNames = getUserGroupNames();
        return w;
    }
    
    @AuraEnabled
    public static Case getCaseDetails(String caseId){
        Case c = new Case();
        c = [Select id,RecordType.Name,Status,Sales_Org__c, Plant_Manager__c, Quality_Manager__c from Case where id =: caseId limit 1];
        return c;
    }
    
    
    @AuraEnabled
    public static String insertNewIssue(String category,String problem,String caseId,String recordTypeName){
        String returnString = null;
        String recordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        System.Debug('RT ID#########:' + recordTypeId);
        Issues__c issue = new Issues__c();
        issue.Case__c = caseId;
        issue.Category__c = category;
        issue.Problem__c = problem;
        issue.RecordTypeId = recordTypeId;
        insert issue;
        returnString = issue.Id;
        return returnString;
    }
    
    @AuraEnabled
    public static List<Issues__c> insertIssues(String issuesJson)
    {
        List<Issues__c> newIssues = new List<Issues__c>();
        
        System.debug('issuesJson '+issuesJson);
        List<IssueData> issuesdata = (List<IssueData>)JSON.deserialize(issuesJson, List<IssueData>.class);
        
        for(IssueData issueData : issuesdata)
        {
            Issues__c iss = new Issues__c();
            
            iss.Discount__c = String.isNotBlank(issueData.discount) ? Decimal.valueOf(issueData.discount) : 0.00;
            if (iss.Discount__c != null) iss.Discount__c = Math.abs(iss.Discount__c); // discount is always +
            
            iss.PRC__c = String.isNotBlank(issueData.price) ? Decimal.valueOf(issueData.price) : 0.00;
            // iss.UNIT_PRICE__c = String.isNotBlank(issueData.unitPrice) ? Decimal.valueOf(issueData.unitPrice) : 0.00;
            if(issueData.recordTypeName == 'Credit'){
                iss.QTY__c = -(Math.abs( String.isNotBlank(issueData.quantity) ? Decimal.valueOf(issueData.quantity) : 1.00 ) );
            }
            else{
                iss.QTY__c = Math.abs( String.isNotBlank(issueData.quantity) ? Decimal.valueOf(issueData.quantity) : 1.00 );
            }
            
            iss.UOM__c = issueData.uom_1;
            iss.UOM2__c = issueData.uom_2;
            if(iss.UOM2__c=='MSF' && String.isNotEmpty(issueData.productId)){
                Product2 p = getProductDetails(issueData.productId);
                iss.Ext_Qty_Conversion__c = p.MSF_Conversion__c;
                if (issueData.insertedFromTrigger==false)
                    iss.EXT_QTY__c = Math.abs((p.MSF_Conversion__c!=null?p.MSF_Conversion__c: 1)*(iss.QTY__c!=null? iss.QTY__c: 1));
            }
            
            // calculate extended amount
            Decimal quantity = (iss.QTY__c!=null? iss.QTY__c: 1);
            Decimal quantityConv = (iss.Ext_Qty_Conversion__c!=null? iss.Ext_Qty_Conversion__c: 1);
            Decimal extendedQuantity = Math.abs(quantity * quantityConv);
            Decimal price = (iss.PRC__c!=null? iss.PRC__c: 0.00);
            Decimal discount = (iss.Discount__c!=null? iss.Discount__c: 0.00);
            Decimal discountFactor = (1 - (discount/100));
            
            Decimal extendedAmt = 0.00;
            extendedAmt = (price * discountFactor) * extendedQuantity;
            
            if(issueData.recordTypeName=='Credit'){
                iss.EXT_AMOUNT2__c = -(Math.abs(extendedAmt));
            }
            else{
                iss.EXT_AMOUNT2__c = Math.abs(extendedAmt);
            }
            
            // iss.EXT_AMOUNT__c = String.isNotBlank(issueData.exactAmount_1) ? Decimal.valueOf(issueData.exactAmount_1) : 0.00;
            // iss.QTY_ORD__c = String.isNotBlank(issueData.quantityOrdered) ? Decimal.valueOf(issueData.quantityOrdered) : 0.00;
            
            iss.Case__c = issueData.caseId;
            iss.Product__c = issueData.productId;
            //iss.EXT_QTY__c = issue.EXT_QTY__c;
            iss.RecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get(issueData.recordTypeName).getRecordTypeId();
            
            newIssues.add(iss);
        }
        System.debug(newIssues);
        insert newIssues;
        
        return newIssues;
    }
    
    @AuraEnabled
    public static String creditRebillTotal(String caseId){
        Decimal totalAmount = 0.00;
        List<AggregateResult> queryResult = [SELECT RecordType.Name, SUM(EXT_AMOUNT2__c) total
                                             FROM Issues__c WHERE Case__c = :caseId AND RecordType.Name IN ('Credit','Rebill') GROUP BY RecordType.Name];
        
        for(AggregateResult agr : queryResult){
            if(agr.get('total') != null)
                totalAmount += (Decimal)agr.get('total');
        }
        
        return String.valueOf(totalAmount);
    }
    @AuraEnabled    
    public static String getRecordType(String caseId){  
        Case cas = [select id , recordType.Name from Case where id =: caseId];  
        return cas.RecordType.Name; 
    }
    
    // Wrapper Class
    //       - Class constructs object with issues info
    //       - For use of inline edit feature
    public class IssueData {
        @AuraEnabled public Boolean isEdit;
        @AuraEnabled public Boolean isSave;
        @AuraEnabled public Boolean isNewIssue;
        @AuraEnabled public String issueId;
        @AuraEnabled public String issueNumber;
        @AuraEnabled public String recordTypeName;
        @AuraEnabled public String recordTypeId;
        @AuraEnabled public String caseOrderItem;
        @AuraEnabled public String caseStatus;
        @AuraEnabled public String orderTypeCode;
        @AuraEnabled public String rebillDifferentCustomers;
        
        @AuraEnabled public String category;
        @AuraEnabled public String problem;
        @AuraEnabled public String details;
        @AuraEnabled public String product;
        @AuraEnabled public String productId;
        @AuraEnabled public String caseId;
        @AuraEnabled public String productName;
        @AuraEnabled public String productCode;
        @AuraEnabled public String description;
        @AuraEnabled public String priceUOM;
        @AuraEnabled public String quantityOrdered;
        @AuraEnabled public String uom_1;
        @AuraEnabled public String exactQuantity;
        @AuraEnabled public Boolean insertedFromTrigger;
        @AuraEnabled public String productDescription;
        @AuraEnabled public String uom_2;
        @AuraEnabled public String unitPrice;
        @AuraEnabled public String exactAmount_1;
        @AuraEnabled public String quantity;
        @AuraEnabled public String quantityConversion;
        @AuraEnabled public String price;
        @AuraEnabled public String discount;
        @AuraEnabled public String exactAmount_2;
        @AuraEnabled public String uniqueId;
        @AuraEnabled public List<String> problemPickVals;
        
        public IssueData(Issues__c issue) {
            this.isEdit = false;
            this.isSave = true;
            this.isNewIssue = false;
            this.issueId = issue.Id;
            this.issueNumber = issue.Name;
            this.recordTypeId = issue.RecordTypeId;
            this.recordTypeName = issue.RecordType.Name;
            this.caseOrderItem = issue.Case_Order_Item__r.Name;
            this.caseStatus = issue.Case__r.Status;
            this.orderTypeCode = issue.Order_Type_Code__c;
            this.rebillDifferentCustomers = issue.Case__r.Rebill_Different_Customers__c;
            
            this.category = issue.Category__c;
            this.problem = issue.Problem__c;
            this.details = issue.Details__c;
            this.product = issue.Case_Order_Item__r.Product__r.Name;
            this.productId = issue.Product__c;
            this.caseId = issue.Case__c;
            this.productName = issue.Product__r.Name;
            //this.productCode = issue.Product__r.CORP_CLASS__c
            this.productCode = issue.Product__r.productCode;
            this.productDescription = issue.Product__r.Name;
            this.priceUOM = issue.Case_Order_Item__r.Price_Uom__c;
            this.insertedFromTrigger = issue.Inserted_From_Trigger__c;
            this.description = issue.Case_Order_Item__r.Product__r.Description;
            this.quantityOrdered = String.valueOf(issue.QTY_ORD__c);
            this.uom_1 = issue.UOM__c;
            this.exactQuantity = String.valueOf(issue.EXT_QTY__c);
            this.uom_2 = issue.UOM2__c;
            this.unitPrice = String.valueOf(issue.UNIT_PRICE__c);
            this.exactAmount_1 = String.valueOf(issue.EXT_AMOUNT__c);
            this.quantity = String.valueOf(issue.QTY__c);
            this.quantityConversion = String.valueOf(issue.Ext_Qty_Conversion__c);
            this.price = String.valueOf(issue.PRC__c);
            this.discount = String.valueOf(issue.Discount__c);
            this.exactAmount_2 = String.valueOf(issue.EXT_AMOUNT2__c);
            this.problemPickVals = new List<String>();
        }
    }
    
    @TestVisible
    Class Wrapper{
        @AuraEnabled public Map<String,List<String>> issuesMap;
        @AuraEnabled public Map<String,List<String>> recordtypeMap;
        @AuraEnabled public Case cse;
        @AuraEnabled public String profileName;
        @AuraEnabled public List<String> groupNames;
    }
}