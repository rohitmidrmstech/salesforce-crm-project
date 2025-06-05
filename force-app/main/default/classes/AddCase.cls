/*********************************************************************************
* Apex Class: AddCase
* Created by Mohan Kumar, TCS, 08/21/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Auto create new case 
----------------------------------------------------------------------------------
* Unit Test: 
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME          DATE            DETAIL FEATURES
    1.0     Mohan Kumar,TCS         08/21/2014      INITIAL DEVELOPMENT
*********************************************************************************/
public Class AddCase{  

    private Order orderRec {get;set;}
    private Case caseRec {get;set;}
    private Account acc {get;set;} 
    private Plants__c wareHouse {get;set;}
    private String rmaCaseRTId {get;set;}
    private String creditCaseRTId {get;set;}
    private String orderNumber {get;set;}
    //private String orderEntryDate {get;set;}
    private String custPO {get;set;}
    //private String orderTotal {get;set;}
    //private String schduleShipDate {get;set;}
    private String shipToId {get;set;}
    private String wareHouseCode {get;set;} 
    private String recordType {get;set;}
    private String amount {get;set;}
    private boolean errorFlag;
    private boolean insertOrder {get;set;}
      
    public AddCase(){ 
        errorFlag = false;
        insertOrder = false;      
        orderNumber = ApexPages.currentPage().getParameters().get('on');        
        custPO = ApexPages.currentPage().getParameters().get('cpo');
        shipToId= ApexPages.currentPage().getParameters().get('sti');
        wareHouseCode = ApexPages.currentPage().getParameters().get('wh'); 
        recordType = ApexPages.currentPage().getParameters().get('ot');
        amount = ApexPages.currentPage().getParameters().get('tot');
        
        System.debug('wareHouseCode: '+wareHouseCode);
        System.debug('amount: '+amount);
        if(orderNumber == '' || orderNumber == null){    //error when Order Number not Found.
            errorFlag = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Order Number not found.');
            ApexPages.addMessage(errorMsg);
        }
        if(custPO == '' || custPO == null){    //error when Customer PO# not Found.
            errorFlag = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Customer PO# not found.');
            ApexPages.addMessage(errorMsg);
        }
        if(shipToId == '' || shipToId == null){    //error when Ship To Account not Found.
            errorFlag = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Ship-To Id not found.');
            ApexPages.addMessage(errorMsg);
        } 
        if(wareHouseCode == '' || wareHouseCode == null){    //error when wareHouseCode not Found.
            errorFlag = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Warehouse Code not found.');
            ApexPages.addMessage(errorMsg);
        }  
        if(recordType == '' || recordType == null){    //error when wareHouseCode not Found.
            errorFlag = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Record Type not found.');
            ApexPages.addMessage(errorMsg);
        }
        if(amount == '' || amount == null){    //error when wareHouseCode not Found.
            errorFlag = true;
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Credit Amount not found.');
            ApexPages.addMessage(errorMsg);
        }
        if(!errorFlag){
            checkOrderNumber();
        }                              
    }
    
    public void checkOrderNumber(){
        Schema.DescribeSObjectResult caseSobj = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = caseSobj.getRecordTypeInfosByName();
        rmaCaseRTId = rtMapByName.get('RMA').getRecordTypeId();
        creditCaseRTId = rtMapByName.get('Credit Request').getRecordTypeId();
        
        List<Account> acList = [Select Id, SAP_ACCOUNT__c from Account where SAP_ACCOUNT__c =: shipToId LIMIT 1];
        if(acList.size() > 0)
            acc = acList.get(0);
        
        List<Plants__c> whList = [Select Id from Plants__c where SAP_Plant__c = :wareHouseCode];
        if(whList.size() > 0)
            wareHouse = whList.get(0);
            
        List<Order> orderList = [Select Id, Name, OwnerId, EffectiveDate, PONumber, Planned_Ship_Date__c from Order WHERE BPCS_Order__c =: orderNumber LIMIT 1];
        if(orderList.size() > 0)
            orderRec = orderList.get(0);

        if(orderRec != null){
            caseRec = new Case();
            caseRec.Order__c = orderRec.id;
            orderRec.OwnerId = UserInfo.getUserId();
            caseRec.Order_Number__c = orderNumber;
            if(acc != null)
                caseRec.AccountId = acc.id;  
            if(wareHouse != null)
                caseRec.Location__c = wareHouse.Id;
            if(recordType ==  'R') {
                caseRec.RecordTypeId = rmaCaseRTId;
                if(amount != null) caseRec.Return_Material_Amount__c = formatCreditAmount(amount);
            } else if(recordType ==  'C') {
                caseRec.RecordTypeId = creditCaseRTId;
                if(amount != null) caseRec.Credit_Amount__c = formatCreditAmount(amount);
            }
        }
        else{ // if orderNumber Not Match from any database Order record Create New Order
            orderRec = new Order();
            //orderRec.Name = orderNumber;
            orderRec.BPCS_Order__c = orderNumber;
            orderRec.PONumber = custPO;
            orderRec.OwnerId = UserInfo.getUserId();
            if(acc != null)
                orderRec.Sold_To__c = acc.id;
            if(wareHouse != null)
                orderRec.Plant__c = wareHouse.Id;
            insertOrder = true;
        }
    }                   
     
    public PageReference saveCaseRec(){ 
        if(!errorFlag){
            if(insertOrder){
                try{
                    insert orderRec;
                }catch(System.Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage(), e.getMessage());
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }
            if(insertOrder){
                caseRec = new Case();
                caseRec.Order__c = orderRec.id;
                caseRec.Order_Number__c = orderNumber;
                caseRec.OwnerId = UserInfo.getUserId();
                if(acc != null)
                    caseRec.AccountId = acc.id;
                if(wareHouse != null)
                    caseRec.Location__c = wareHouse.Id;
                if(recordType ==  'R') {
                    caseRec.RecordTypeId = rmaCaseRTId;
                    if(amount != null) caseRec.Return_Material_Amount__c = formatCreditAmount(amount);
                } else if(recordType ==  'C') {
                    caseRec.RecordTypeId = creditCaseRTId;
                    if(amount != null) caseRec.Credit_Amount__c = formatCreditAmount(amount);
                }
            }
            try{
                insert caseRec;
            }catch(System.Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage(), e.getMessage());
                ApexPages.addMessage(myMsg);
                return null;
            }
            pageReference pg = new pageReference('/'+caseRec.Id+'/e?retURL=%2F'+caseRec.id);
            return pg;
        }
        else
            return null; 
    }
    
    public String unEscapeUrl(String url) {
        if (url == null) return null;
        String s = url;
        s = s.replace('%20', ' ');
        /*s = s.replace('%2B', '+');        
        s = s.replace('%3D', '=');
        s = s.replace('%2F', '/');
        s = s.replace('%26', '&');
        s = s.replace('%3F', '?');*/

        return s;
    }
    
    public Decimal formatCreditAmount(String cAmount) {
        while(cAmount.contains('-')) {
            cAmount = cAmount.replace('-', '');
        }
        return Decimal.valueOf(cAmount);
    }
    
}