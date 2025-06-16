@isTest
public class OMRLineItemsControllerLCTest {
    public static testMethod void testMethod1() {
        Product2 prod = new Product2(Name = 'Laptop X20056',  isActive = true,
                                     Family = 'Hardware');
        Insert prod;
        
        Case caseRecord = new Case();
       // caseRecord.AccountId = accountRecord.id;
        caseRecord.Subject = 'TestCase';
        caseRecord.Campaign__c = 'MECH';
        INSERT caseRecord;
        
        Order_Mgmt_Request_Item__c orderObject = new Order_Mgmt_Request_Item__c();
        orderObject.Item__c = prod.id;
        orderObject.Invoice__c = 3000;
        orderObject.Quantity__c = 10.000;
        orderObject.OM_Request__c = caseRecord.id;
        Insert orderObject;
        
        List<Order_Mgmt_Request_Item__c> lstOMRItems = new List<Order_Mgmt_Request_Item__c>();
        
        OMRLineItemsControllerLC.saveRecords(lstOMRItems);
        OMRLineItemsControllerLC.getCaseRec(caseRecord.Id);
        OMRLineItemsControllerLC.getItemRec(prod.Id);
        OMRLineItemsControllerLC.getsavedOMRItems(caseRecord.id);
        OMRLineItemsControllerLC.deleteRecords(orderObject.id);
        
    }
}