// see all data is needed as the trigger testing needs to see the Standard price book entry 
//  that was created in the setup by the CT_Product2 trigger.  For some odd reason Salesforce
//  testing does not allow that to be visibile
@isTest(SeeAllData=true)
public class CT_CaseItemControllerTest {
    
    static testMethod void caseItemTest(){
        
        List<case> caseList = new List<case>();
        List<case_order_items__c> caseItemsList = new List<case_order_items__c>();
        List<order> orderList = new List<order>();
        List<orderItem> orderItemList = new List<orderItem>();
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        Set<id> contentVersionIdSet = new Set<id>();
        
        account a = new account();
        a.name ='Test Acc';
        insert a;
        
         account a1 = new account();
        a1.name ='Test Acc1';
        insert a1;
        
        Plants__c  Testingplant2 = new Plants__c();
        Testingplant2.Name ='Testing12212324';
        Testingplant2.Plant_Manager__c = UserInfo.getUserId();
        Testingplant2.SAP_Plant__c ='0276';
        insert Testingplant2;


        
        Product2 p = new product2();
        p.name='TestProduct11332345';
        p.productCode = 'islabor34';
        p.Sales_Org__c = '1100';
        p.SAP_Material__c = '9081638445_1100';
        p.ApprovingPlant__c =Testingplant2.id;
        insert p; 
        
        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> pbe =  [select id,product2Id,pricebook2Id,Product2.Name,PriceBook2.isStandard from PricebookEntry  limit 2];
        
       //where pricebook2Id=:pricebookId
        
        Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing232324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c ='0274';
        insert Testingplant1;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
       
        Product2 p1 = new Product2();
       p1.SAP_Material__c = '9080638445-1100';
        p1.Sales_Org__c = '1100';
        p1.productCode = 'islabor34';
        p1.Name ='TestProduct22342';
        p1.ApprovingPlant__c =Testingplant1.id;
        p1.RecordTypeId = strRecordTypeId;
                insert p1;
                
       
        
        
        order o1 = new order();
        o1.accountId = a.id;
        o1.effectiveDate = Date.Today();
         o1.Pricebook2Id = pbe[0].Pricebook2Id;
        o1.status = 'Draft';
        //o1.invoice__c = i2.id;
        o1.Sales_Org__c = '1100';
        orderList.add(o1);
        
        order o2 = new order();
        o2.accountId = a1.id;
        o2.effectiveDate = Date.Today();
        o2.status = 'Draft';
         //o2.invoice__c = i2.id;
        o2.Pricebook2Id = pbe[1].Pricebook2Id;
        o2.Sales_Org__c = '1100';
        orderList.add(o2);
        
        orderItem oi = new orderItem();
        oi.orderId = o2.id;
        oi.quantity = 20;
        oi.pricebookEntryId = pbe[0].id;
        oi.unitPrice = 33;
        oi.Material__c = '9080638445';
        orderItemList.add(oi);
        
        orderItem oi1 = new orderItem();
        oi1.orderId = o1.id;
        oi1.quantity = 201;
        oi1.pricebookEntryId = pbe[1].id;
        oi1.unitPrice = 331;
        oi1.Material__c = '90806384451';
        orderItemList.add(oi1);
        
        
        insert orderList;
        
         invoice__c i1 = new invoice__c();
        i1.Order__c = o1.Id;
        i1.Order_Number__c = '123';
        invoiceList.add(i1);
        
        invoice__c i2 = new invoice__c();
        i2.Order__c = o2.Id;
        invoiceList.add(i2);
        insert invoiceList;
        
        //upsert orderItemList;
        
        case c = new case();
        c.status = 'New';
        //c.AccountId = a.Id;
        c.origin = 'Email';
        c.order__c = o1.id;
        //c.invoice__c = i1.id;
        c.Campaign__c = 'MECH';
        caseList.add(c);
        
        case c1 = new case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.order__c = o1.id;
        //c1.AccountId = a.Id;
        c1.Campaign__c = 'MECH';
        caseList.add(c1);
        
        case c2 = new case();
        c2.status = 'New';
        c2.origin = 'Email';
        //c2.invoice__c = i2.id;
        //c2.AccountId = a.Id;
        c2.Campaign__c = 'MECH';
        caseList.add(c2);
        
        case c3 = new case();
        c3.status = 'New';
        c3.origin = 'Email';
        c3.order__c = o2.id;
        //c3.AccountId = a.Id;
        c3.Campaign__c = 'MECH';
        caseList.add(c3);
        insert caseList;
        
        case_order_items__c coi = new case_order_items__c();
        coi.case__c = c.id;
        coi.currency__c = 'USD';
        coi.product__c = p.id;
        coi.Quantity__c = 20.00;
        caseItemsList.add(coi);
        
        case_order_items__c coi1 = new case_order_items__c();
        coi1.case__c = c1.id;
        coi1.currency__c = 'USD';
        coi1.product__c = p.id;
        coi1.Quantity__c = 20.00;
        coi1.Total_Price__c = 10.00;
        caseItemsList.add(coi1);
        
        case_order_items__c coi2 = new case_order_items__c();
        coi2.case__c = c1.id;
        coi2.currency__c = 'USD';
        coi2.product__c = p.id;
        coi2.Quantity__c = 20.00;
        coi2.Total_Price__c = 10.00;
        caseItemsList.add(coi2);
        
        case_order_items__c coi3 = new case_order_items__c();
        coi3.case__c = c2.id;
        coi3.currency__c = 'USD';
        coi3.product__c = p.id;
        coi3.Quantity__c = 20.00;
        coi3.Total_Price__c = 10.00;
        coi3.inserted_from_trigger__c = true;
        caseItemsList.add(coi3);
        
        insert caseItemsList;
        coi3.CR__c = true;
        coi3.RB__c = true;
        coi3.IS__c = true;
        update coi3;
        
        coi3.CR__c = false;
        coi3.RB__c = false;
        coi3.IS__c = false;
        update coi3;
        
        coi2.CR__c = true;
        coi2.RB__c = true;
        coi2.IS__c = true;
        update coi2;
        
        coi2.CR__c = false;
        coi2.RB__c = false;
        coi2.IS__c = false;
        update coi2;
        Test.startTest(); 
        CT_CaseItemController.fetchCaseItemsData(c2.Id);
        //String caseItemsJson = '{"insertedFromTrigger":true,"isEdit":false,"isSave":true,"itemCR":true,"itemId":"'+coi3.Id+'","itemIS":true,"itemName":"'+coi3.Name+'","itemRB":false,"productCode":"NOKPI","quantity":"4.00","quantityAvailable":"4.00","totalPrice":"40.00","unitPrice":"10.00"}';
       // String caseItemsJson = JSON.serialize(coi3);
        String caseItemsJson = '{"insertedFromTrigger":true,"isEdit":true,"isSave":false,"itemCR":false,"itemId":"'+coi3.Id+'","itemIS":true,"itemName":"'+coi3.Name+'","itemRB":false,"productCode":"NOKPI","quantity":"4.00","quantityAvailable":"4.00","totalPrice":"40.00","unitPrice":"10.00"}';
        //system.debug('caseITemsJSON'+caseItemsJson);
        String caseItemsJsonList = '[{"insertedFromTrigger":true,"isEdit":true,"isSave":false,"itemCR":false,"itemId":"'+coi3.Id+'","itemIS":true,"itemName":"'+coi3.Name+'","itemRB":false,"productCode":"NOKPI","quantity":"4.00","quantityAvailable":"4.00","totalPrice":"40.00","unitPrice":"10.00"},{"insertedFromTrigger":true,"isEdit":true,"isSave":false,"itemCR":false,"itemId":"'+coi2.Id+'","itemIS":true,"itemName":"'+coi2.Name+'","itemRB":true,"quantity":"10.00","quantityAvailable":"10.00","totalPrice":"100.00","unitPrice":"10.00"}]';

               CT_CaseItemController.updateCaseOrderItems(caseItemsJson);
               CT_CaseItemController.updateCaseOrderItemList(caseItemsJsonList);
              // Test.startTest(); 
            CT_CaseItemController.getCaseDetails(c3.Id);
            Test.stopTest();
    }
}