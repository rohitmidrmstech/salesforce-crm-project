public class OMRLineItemsControllerLC {
    @AuraEnabled
    public static void saveRecords(List<Order_Mgmt_Request_Item__c> recList){
        String msg = '';
        try{
          Upsert recList;  
        }
        catch (DmlException e) {
               //Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
            //we can get from DmlException
             
            //Get All DML Messages
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            //throw DML exception message
            throw new AuraHandledException(msg);    
        }
    }
    
    @AuraEnabled
    public static void deleteRecords(id recId){
        String msg = '';
        system.debug('=================recId======================='+recId);
        List<Order_Mgmt_Request_Item__c> omrItem = new List<Order_Mgmt_Request_Item__c>();
        omrItem = [Select Id FROM Order_Mgmt_Request_Item__c Where id = :recId];
        if(omrItem.size()>0){
            try{
            	delete omrItem;
            }
            catch (DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    msg =+ e.getDmlMessage(i) +  '\n' ;
                }
            	throw new AuraHandledException(msg);    
        	}
        }   
    }
    
    @AuraEnabled
    public static List<Case> getCaseRec(Id recId){
        List<Case> lstcase = new List<Case>();
        lstcase = [Select Id, CaseNumber, Type, Action__c from Case Where Id = :recId];
        return lstcase;
    }

    @AuraEnabled
    public static List<Product2> getItemRec(Id itemRecId){
        List<Product2> lstItem = new List<Product2>();
        lstItem = [Select Id, Description, Name, Item_Class__c, Item_Class_Description__c from Product2 Where Id = :itemRecId];        
        return lstItem;
    }
    
    @AuraEnabled
    public static List<Order_Mgmt_Request_Item__c> getsavedOMRItems(Id caseId){
        List<Order_Mgmt_Request_Item__c> omrItem = new List<Order_Mgmt_Request_Item__c>();
        omrItem = [Select Id, Insulation_Id__c, Internal_Warehouse_Check__c, Invoice__c, Item__c, Item__r.ProductCode, Item__r.Name, Item__r.Description, Item__r.Item_Class__c, Item__r.Item_Class_Description__c, OM_Request__c, Promo_No__c, 
                   Quantity__c, Suggested__c, Warehouse_Acpt__c, Warehouse_Rec_d__c FROM Order_Mgmt_Request_Item__c Where OM_Request__c = :caseID];
        return omrItem;
    }
}