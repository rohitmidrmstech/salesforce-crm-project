/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* This test class will cover all the classes related to the case trigger. 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Gautam Kumar (gkumar@liquidhub.com)
* @verstion       1.0
* @created        2017-05-24
*/

// see all data is needed as the trigger testing needs to see the Standard price book entry 
//  that was created in the setup by the CT_Product2 trigger.  For some odd reason Salesforce
//  testing does not allow that to be visibile
@isTest(SeeAllData=true)
private class CT_CasetriggerHandler_Test {
    
    static testMethod void test1(){
        
        List<case> caseList = new List<case>();
        List<case_order_items__c> caseItemsList = new List<case_order_items__c>();
        List<order> orderList = new List<order>();
        List<orderItem> orderItemList = new List<orderItem>();
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        Set<id> contentVersionIdSet = new Set<id>();
        
        account a = new account();
        a.name ='Test Acc';
        insert a;
        
        Plants__c  Testingplant3 = new Plants__c();
        Testingplant3.Name ='Testing2324';
        Testingplant3.Plant_Manager__c = UserInfo.getUserId();
        Testingplant3.SAP_Plant__c = 'TW';
        insert Testingplant3;

        
        Product2 p = new product2();
        p.name='TestProduct11332345';
        p.productCode = 'islabor34';
        p.Sales_Org__c = '1100';
        p.SAP_Material__c = '9081638445_1100';
        p.ApprovingPlant__c = Testingplant3.id;
        insert p; 
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = [select id,product2Id,pricebook2Id,Product2.Name,PriceBook2.isStandard from PricebookEntry where pricebook2Id=:pricebookId limit 1];
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
        Product2 p1 = new Product2();
        p1.SAP_Material__c = '9080638445-1100';
        p1.Sales_Org__c = '1100';
        p1.productCode = 'islabor34';
        p1.RecordTypeId = strRecordTypeId;
        p1.Name ='Testig1233';
        p1.ApprovingPlant__c =Testingplant3.id;
        insert p1;
        
        order o1 = new order();
        o1.accountId = a.id;
        o1.effectiveDate = Date.Today();
        o1.status = 'Draft';
       
        //o1.invoice__c = i2.id;
        o1.Sales_Org__c = '1100';
        orderList.add(o1);
        
        order o2 = new order();
        o2.accountId = a.id;
        o2.effectiveDate = Date.Today();
        o2.status = 'Draft';
       
        // o2.invoice__c = i2.id;
        o2.Pricebook2Id = pbe.Pricebook2Id;
        o2.Sales_Org__c = '1100';
        orderList.add(o2);
        insert orderList;
        
        invoice__c i1 = new invoice__c();
        i1.Order__c = o1.Id;
        i1.Order_Number__c = '123';
        i1.Sold_To__c = '12345675';
        i1.Curr__c = 'CAN';
        i1.Billing_Date__c = system.today();
        i1.BPCS_Invoice_No__c = '00123435';
        i1.Carrier__c = 'Test1';
        i1.Carrier_Name__c = ' Test';
        
        
        invoiceList.add(i1);
        invoice__c i2 = new invoice__c();
        i2.Order__c = o2.Id;
        invoiceList.add(i2);
        insert invoiceList;
        
        orderItem oi = new orderItem();
        oi.orderId = o2.id;
        oi.quantity = 20;
        oi.pricebookEntryId = pbe.id;
        oi.unitPrice = 33;
        oi.Material__c = '9080638445';
        orderItemList.add(oi);
        
       /* orderItem oi1 = new orderItem();
        oi1.orderId = o2.id;
        oi1.quantity = 20;
        oi1.pricebookEntryId = pbe.id;
        oi1.unitPrice = 33;
        oi1.Material__c = '9080638445';
        //orderItemList.add(oi1);
        insert orderItemList;*/
        
        case c = new case();
        c.status = 'New';
        c.AccountId = a.id;
        c.origin = 'Email';
        c.order__c = o1.id;
        c.invoice__c = i1.id;
        c.Sold_to_Name__c = a.Id;
        c.Ship_To_Company__c = a.Id;
        c.Debit_Order__c = '123';
        c.Credit_Order__c = '123';
        c.Secondary_Quality_Category__c = 'Goodwill';
        caseList.add(c);
        
        case c1 = new case();
        c1.status = 'New';
        c1.AccountId = a.Id;
        c1.origin = 'Email';
        c1.order__c = o1.id;
        c1.Sold_to_Name__c = a.Id;
        c1.Ship_To_Company__c = a.Id;
        c1.Secondary_Quality_Category__c = 'Goodwill';
        caseList.add(c1);
        
        case c2 = new case();
        c2.status = 'New';
        c2.origin = 'Email';
        c2.AccountId = a.Id;
        c2.invoice__c = i1.id;
        c2.Secondary_Quality_Category__c = 'Goodwill';
        caseList.add(c2);
        
        case c3 = new case();
        c3.status = 'New';
        c3.origin = 'Email';
        c3.AccountId = a.Id;
        c3.Secondary_Quality_Category__c = 'Goodwill';
        c3.order__c = o2.id;
        caseList.add(c3);
        insert caseList;
        
        
        case_order_items__c coi = new case_order_items__c();
        coi.case__c = c.id;
        coi.currency__c = 'USD';
        coi.product__c = p.id;
        caseItemsList.add(coi);
        
        case_order_items__c coi1 = new case_order_items__c();
        coi1.case__c = c1.id;
        coi1.currency__c = 'USD';
        coi1.product__c = p.id;
        caseItemsList.add(coi1);
        
        case_order_items__c coi2 = new case_order_items__c();
        coi2.case__c = c1.id;
        coi2.currency__c = 'USD';
        coi2.product__c = p.id;
        caseItemsList.add(coi2);
        
        case_order_items__c coi3 = new case_order_items__c();
        coi3.case__c = c2.id;
        coi3.currency__c = 'USD';
        coi3.product__c = p.id;
        caseItemsList.add(coi3);
        
        case_order_items__c coi4 = new case_order_items__c();
        coi4.case__c = c1.id;
        coi4.currency__c = 'USD';
        coi4.product__c = p.id;
        caseItemsList.add(coi4);
        
        case_order_items__c coi5 = new case_order_items__c();
        coi5.case__c = c1.id;
        coi5.currency__c = 'USD';
        coi5.product__c = p.id;
        caseItemsList.add(coi5);
        
        insert caseItemsList;

        //contentVersion contentVersion_1 = new contentVersion();
        //contentVersion_1.title = 'Penguins';
        //contentVersion_1.pathOnClient = 'Penguins.jpg';
        //contentVersion_1.versionData = Blob.valueOf('Test Content');
        //contentVersion_1.IsMajorVersion = true;
        //insert contentVersion_1;
        
        //contentVersion contentVersion_3 = new contentVersion();
        //contentVersion_3.title = 'Penguins';
        //contentVersion_3.pathOnClient = 'Penguins.jpg';
        //contentVersion_3.versionData = Blob.valueOf('Test Content');
        //contentVersion_3.IsMajorVersion = true;
        //insert contentVersion_3;
        //contentVersionIdSet.add(contentVersion_1.id);
        //contentVersionIdSet.add(contentVersion_3.id);
        //List<ContentVersion> contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id in :contentVersionIdSet];
        //List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        
        //contentDocumentLink cdl = new contentDocumentLink();
        //cdl.ContentDocumentId = documents.get(0).id;
        //cdl.linkedEntityId = coi1.id;
        //cdl.shareType = 'V';
        //insert cdl;
        //contentDocumentLink cdl1 = new contentDocumentLink();
        //cdl1.ContentDocumentId = documents.get(0).id;
        //cdl1.linkedEntityId = coi2.id;
        //cdl1.shareType = 'V';
        //insert cdl1;
        
        //caseList.clear();
        //c.status='Submitted For Approval';
        //caseList.add(c);
        //c1.status='Submitted For Approval';
        //caseList.add(c1);
        //c2.order__c = o2.id;
        //caseList.add(c2);
        //Database.update(caseList,false);
        
    }
    
    static testMethod void test2(){
        
        List<case> caseList = new List<case>();
        List<case_order_items__c> caseItemsList = new List<case_order_items__c>();
        List<order> orderList = new List<order>();
        List<order> orderList1 = new List<order>();
        List<order> orderList2 = new List<order>();
        List<order> orderList3 = new List<order>();
        List<orderItem> orderItemList = new List<orderItem>();
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        List<Invoice_Line_Item__c> invoiceLineItemList = new List<Invoice_Line_Item__c>();
        Set<id> contentVersionIdSet = new Set<id>();
        
        Id issuesRecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Issues').getRecordTypeId();
        Id qualityRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Case').getRecordTypeId();
        Id serviceRecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId();
        Id pricingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Case').getRecordTypeId();
        Id shipToRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship-To').getRecordTypeId();
        Account a = new account();
        a.name ='Test Acc new'; 
        a.RecordTypeId = shipToRecordTypeId;
        a.LOB__c='1502';
        insert a;
        
        Territory__c t1 = new Territory__c();
        t1.Name = 'test territory';
        
        insert t1;
        
        
        Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testin12g2324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c = 'TW';
        insert Testingplant1;
        
        Product2 p = new product2();
        p.name='TestProduct11332345';
        p.productCode = 'islabor3456';
        p.Sales_Org__c = '1100';
        p.SAP_Material__c = '9081638445-1100';
        p.ApprovingPlant__c = Testingplant1.id;
        insert p; 
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = [select id,product2Id,pricebook2Id,Product2.Name,PriceBook2.isStandard from PricebookEntry where pricebook2Id=:pricebookId limit 1];
        
        if(pbe != null)
        {
         //PricebookEntry pbe=new PricebookEntry(UnitPrice = 1,Product2Id=p.id,Pricebook2Id=pricebookId,isActive=true);
         //insert pbe;
         
        Plants__c Testingplant2 = new Plants__c();
        Testingplant2.Name ='Testin54512g2324';
        Testingplant2.Plant_Manager__c = UserInfo.getUserId();
        Testingplant2.SAP_Plant__c = 'TW';
        insert Testingplant2;
        
        Product2 p1 = new Product2();
        p1.SAP_Material__c = '9080638445-1100';
        p1.Sales_Org__c = '1100';
        p1.productCode = 'islabor3456';
        p1.Name ='Testing23523';
        p1.ApprovingPlant__c = Testingplant2.id;
        insert p1;
        
        order o1 = new order();
       
        o1.accountId = a.id;
        o1.effectiveDate = Date.Today();
        o1.PriceBook2Id=pricebookId;
        o1.status = 'Draft';
        //o1.invoice__c = i2.id;
        o1.Sales_Org__c = '1100';
        insert o1;
        //orderList.add(o1);
        //insert orderList;
        
        Account a1 = new account();
        a1.name ='Test Acc1';   
        a1.LOB__c='1502';
        insert a1;
        
        order o2 = new order();
        o2.accountId = a1.id;        
        o2.effectiveDate = Date.Today();         
        o2.status = 'Draft';
        
        // o2.invoice__c = i2.id;
        o2.PriceBook2Id=pricebookId;
        o2.Sales_Org__c = '1003';
        insert o2;
        //orderList1.add(o2);
        //insert orderList1;
        
        Account a2 = new account();
        a2.name ='Test Acc11'; 
        a2.LOB__c='1502';
        insert a2;
        
        order o3 = new order();
        o3.accountId = a2.id;
        o3.effectiveDate = Date.Today();
        o3.status = 'Draft';
        // o2.invoice__c = i2.id;
        o3.Pricebook2Id = pbe.Pricebook2Id;
        o3.Sales_Org__c = '1100';
        insert o3;
        //orderList2.add(o3);
        //insert orderList2;
        
        Account a3 = new account();
        a3.name ='Test Acc11';    
        a3.LOB__c='1502';
        insert a3;
        
        order o4 = new order();
        o4.accountId = a3.id;
        o4.effectiveDate = Date.Today();
        o4.status = 'Draft';
        // o2.invoice__c = i2.id;
        o4.Pricebook2Id = pbe.Pricebook2Id;
        o4.Sales_Org__c = '1100';
        //o4.Header_Condition_1__c = 'ZFS2|Stop Fee|245.00';
        insert o4;
        //orderList3.add(o4);
        
       //insert orderList3;
        
        invoice__c i1 = new invoice__c();
        i1.Order__c = o1.Id;
        i1.Ship_To_Lookup__c =a1.id;
        i1.Header_Condition_1__c ='ZENG|Engineering Fees|20';
        invoiceList.add(i1);
        invoice__c i2 = new invoice__c();
        i2.Order__c = o2.Id;
        i2.Ship_To_Lookup__c =a2.id;
        invoiceList.add(i2);
        invoice__c i3 = new invoice__c();
        
        insert invoiceList;
        
        Invoice_Line_Item__c invli1 = new Invoice_Line_Item__c();
        invli1.name = 'test invli1';
        invli1.Invoice__c = i1.Id;
        invli1.Product__c = p.Id;
        invoiceLineItemList.add(invli1);
        
        Invoice_Line_Item__c invli2 = new Invoice_Line_Item__c();
        invli2.name = 'test invli2';
        invli2.Invoice__c = i2.Id;
        invli2.Product__c = p1.Id;
        invoiceLineItemList.add(invli2);
        
        Invoice_Line_Item__c invli3 = new Invoice_Line_Item__c();
        invli3.name = 'test invli3';
        invli3.Invoice__c = i1.Id;
        invli3.Material__c = '9081638445';
        invoiceLineItemList.add(invli3);
        
        Invoice_Line_Item__c invli4 = new Invoice_Line_Item__c();
        invli4.name = 'test invli4';
        invli4.Invoice__c = i2.Id;
        invli4.Material__c = '9081638445';
        invoiceLineItemList.add(invli4);
        insert invoiceLineItemList;
        
        Test.StartTest();
        
        orderItem oi = new orderItem();
        oi.orderId = o2.id;
        oi.quantity = 25;
        oi.pricebookEntryId = pbe.id;
        oi.unitPrice = 33;
        oi.Material__c = '9080638445';
        oi.Line_Number__c = 65;
        //orderItemList.add(oi);
        insert oi;
        
        orderItem oi1 = new orderItem();
        oi1.orderId = o2.id;
        oi1.quantity = 20;
        oi1.pricebookEntryId = pbe.id;
        oi1.unitPrice = 35;
        oi1.Material__c = '9080638444';
        oi1.Line_Number__c = 55;
        //orderItemList.add(oi1);
        insert oi1;
        
        orderItem oi2 = new orderItem();
        oi2.orderId = o3.id;
        oi2.quantity = 30;
        oi2.pricebookEntryId = pbe.id;
        oi2.unitPrice = 38;
        oi2.Material__c = '9080638442';
        oi2.Line_Number__c = 45;
        //orderItemList.add(oi2);
        insert oi2;
       
        //insert orderItemList;
        
        Case c = new case();
        //c.RecordTypeId = shipToRecordTypeId;
        c.status = 'New';
        c.AccountId = a.Id;
        c.origin = 'Email';
        c.order__c = o1.id;
        c.invoice__c = i1.id;
        c.Sold_to_Name__c = a.Id;
        c.Ship_To_Company__c = a.Id;
        c.Secondary_Quality_Category__c = 'Goodwill';
        c.Created_From_Order__c = true;
        c.Portal_Subject__c = 'Internal Service Case';
        caseList.add(c);
        
        case c1 = new case();
        c1.status = 'New';
        c1.Secondary_Quality_Category__c = 'Goodwill';
        c1.origin = 'Email';
        c1.order__c = o1.id;
        c1.Sold_to_Name__c = a.Id;
        c1.Ship_To_Company__c = a.Id;
        c1.AccountId = a.Id;
        c1.Territory__c = 'terr';
        c1.Portal_Subject__c = 'Internal Service Case';
        
        caseList.add(c1);
        
        case c2 = new case();
        c2.status = 'New';
        c2.Secondary_Quality_Category__c = 'Goodwill';
        c2.origin = 'Email';
        c2.invoice__c = i1.id;
        c2.AccountId = a.Id;
        c2.Portal_Subject__c = 'Internal Service Case';
        caseList.add(c2);
        
        case c3 = new case();
        c3.status = 'New';
        c3.origin = 'Email';
        c3.Secondary_Quality_Category__c = 'Goodwill';
        c3.order__c = o2.id;
        c3.AccountId = a.Id;
        c3.RecordTypeId = qualityRecordTypeId;
        c3.Portal_Subject__c = 'Internal Service Case';
        c3.Investigator__c = UserInfo.getUserId();
        c3.Pre_Approver_1a__c = UserInfo.getUserId();
        caseList.add(c3);
        
        case c4 = new case();
        c4.status = 'New';
        c4.origin = 'Email';
        c4.order__c = o3.id;
        c4.AccountId = a.Id;
        c4.Secondary_Quality_Category__c = 'Goodwill';
        c4.RecordTypeId = serviceRecordTypeId;
        c4.Portal_Subject__c = 'Internal Service Case';
        c4.Investigator__c = UserInfo.getUserId();
        caseList.add(c4);
        
        case c5 = new case();
        c5.status = 'New';
        c5.origin = 'Email';
        c5.Secondary_Quality_Category__c = 'Goodwill';
        c5.order__c = o4.id;
        c2.invoice__c = i1.id;
        c5.AccountId = a.Id;
        c5.Credit_Order__c ='456';
        c5.Debit_Order__c ='456';
        c5.Portal_Subject__c = 'Internal Service Case';
        c5.RecordTypeId = serviceRecordTypeId;
        c5.Investigator__c = UserInfo.getUserId();
        caseList.add(c5);
        
        insert caseList;
        
        Invoice__c i4 = new Invoice__c();
        i4.Order__c = o4.Id;
        i4.Order_Number__c ='456';
        insert i4;
        
        case_order_items__c coi = new case_order_items__c();
        coi.case__c = c.id;
        coi.currency__c = 'USD';
        coi.product__c = p.id;
        caseItemsList.add(coi);
        
        case_order_items__c coi1 = new case_order_items__c();
        coi1.case__c = c1.id;
        coi1.currency__c = 'USD';
        coi1.product__c = p.id;
        caseItemsList.add(coi1);
        
        case_order_items__c coi2 = new case_order_items__c();
        coi2.case__c = c1.id;
        coi2.currency__c = 'USD';
        coi2.product__c = p.id;
        caseItemsList.add(coi2);
        
        
        case_order_items__c coi3 = new case_order_items__c();
        coi3.case__c = c2.id;
        coi3.currency__c = 'USD';
        coi3.product__c = p.id;
        coi3.inserted_from_trigger__c = true;
        caseItemsList.add(coi3);
        
        insert caseItemsList;
        
        
        Issues__c iss = new Issues__c();
        iss.Case__c = c2.Id;
        iss.Case_Order_Item__c = coi3.Id;
        iss.RecordTypeId = issuesRecordTypeId;
        insert iss;
        
        
        caseList.clear();
        c.status='Pending TM';
        c.Rebill_Different_Customers__c ='Yes';
        c.Rebill_Ship_To__c =a.Id;
        caseList.add(c);

        c1.status='Pending TM';
        caseList.add(c1);
        c2.order__c = o2.id;
        caseList.add(c2);

        c3.Order__c = null;
        c3.Invoice__c = i2.Id;
        c3.Status = 'Pending TM';
        caseList.add(c3);

        Database.update(caseList,false);

        caseList.clear();
         c.Ship_To_Company__c = a.id;
        caseList.add(c);

        c1.Rebill_Different_Customers__c = 'No';
        c1.Rebill_Ship_To__c =a.Id;
        caseList.add(c1);

        c2.Rebill_Different_Customers__c = 'Yes';
        //c2.Rebill_Ship_To__c =a.Id; 
        caseList.add(c2);
        
        c3.Status = 'Closed';
        caseList.add(c3); 
        Database.update(caseList,false);
        
        i1.Payer__c = '7943';
        update i1;
        
        invli1.Carrier_Name__c ='tst';
        update invli1;
        
//        oi.Line_Type__c = 'test';
        oi.Item_Condition_1__c = 'ZENG|Engineering Fees|20';
        update oi;
         Test.StopTest();
        
        Map<Id, Case> caseMap = new Map<Id, Case>();
        for(Case record : caseList){
            caseMap.put(record.Id, record);
        }
        caseList[0].status = 'New';
        Database.Update(caseList,false);
        
       } 
    }
    testMethod public static void mapInvoiceToCaseTest(){
        Account a3 = new account();
        a3.name ='Test Acc11';        
        insert a3;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = [select id,product2Id,pricebook2Id,Product2.Name,PriceBook2.isStandard from PricebookEntry where pricebook2Id=:pricebookId limit 1];
       
        
        order o4 = new order();
        o4.accountId = a3.id;
        o4.effectiveDate = Date.Today();
        o4.status = 'Draft';
        // o2.invoice__c = i2.id;
        o4.Pricebook2Id = pbe.Pricebook2Id;
        o4.Sales_Org__c = '1100';
        //o4.Header_Condition_1__c = 'ZFS2|Stop Fee|245.00';
        insert o4;
        
        Invoice__c i4 = new Invoice__c();
        i4.Order__c = o4.Id;
        i4.Order_Number__c ='456';
        insert i4;

        List<Case> caseList = new List<Case>();
        Case c = new case();
        //c.RecordTypeId = shipToRecordTypeId;
        c.status = 'New';
        c.AccountId = a3.Id;
        c.origin = 'Email';
        c.order__c = o4.id;
        c.invoice__c = i4.id;
        c.Sold_to_Name__c = a3.Id;
        c.Ship_To_Company__c = a3.Id;
        c.Secondary_Quality_Category__c = 'Goodwill';
        c.Created_From_Order__c = true;
        c.Portal_Subject__c = 'Internal Service Case';
        caseList.add(c);
        insert caseList;
        
        CT_CaseTriggerHandler handler = new CT_CaseTriggerHandler();
        Test.startTest();
        Map<Id, Case> caseMap = new Map<Id, Case>();
        for(Case record : caseList){
            caseMap.put(record.Id, record);
        }
        handler.beforeUpdateHandler(caseList,caseMap);
        handler.mapInvoiceToCase(c,i4);
        Test.stopTest();
        
        Id ceilingGypsumRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portal').getRecordTypeId();
        caseList = new List<Case>();
        c = new case();
        c.RecordTypeId = ceilingGypsumRT;
        c.status = 'New';
        c.AccountId = a3.Id;
        c.origin = 'Email';
        c.order__c = o4.id;
        c.invoice__c = i4.id;
        c.Sold_to_Name__c = a3.Id;
        c.Ship_To_Company__c = a3.Id;
        c.Secondary_Quality_Category__c = 'Goodwill';
        c.Created_From_Order__c = true;
        c.Portal_Subject__c = 'Internal Service Case';
        caseList.add(c);
        insert caseList;
        
        aiuCaseUtil.portalCaseAssignment(caseList);
        aiuCaseUtil.caseSharing(new Set<String>{c.Id + '::::' + UserInfo.getUserId()});
    }
    testMethod public static void mapInvoiceToCaseTest1(){
        Account a4 = new account();
        a4.name ='Test Acc11443';        
        insert a4;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = [select id,product2Id,pricebook2Id,Product2.Name,PriceBook2.isStandard from PricebookEntry where pricebook2Id=:pricebookId limit 1];
       
        
        order o4 = new order();
        o4.accountId = a4.id;
        o4.effectiveDate = Date.Today();
        o4.status = 'Draft';
        // o2.invoice__c = i2.id;
        o4.Pricebook2Id = pbe.Pricebook2Id;
        o4.Sales_Org__c = '1502';
        //o4.Header_Condition_1__c = 'ZFS2|Stop Fee|245.00';
        insert o4;
        
        Invoice__c i4 = new Invoice__c();
        i4.Order__c = o4.Id;
        i4.Order_Number__c ='456';
        insert i4;
        Id creditRequestId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Credit Request').getRecordTypeId();
        List<Case> caseList = new List<Case>();
        Case c = new case();
        c.RecordTypeId = creditRequestId;
        c.status = 'New';
        c.AccountId = a4.Id;
        c.Subject ='test sub';
        c.Description ='test Description';
        c.origin = 'Email';
        c.order__c = o4.id;
        c.invoice__c = i4.id;
        c.Sold_to_Name__c = a4.Id;
        c.Ship_To_Company__c = a4.Id;
        c.Priority ='Medium';
        c.Secondary_Quality_Category__c = 'Goodwill';
        c.Created_From_Order__c = true;
        c.Portal_Subject__c = 'Internal Service Case';
        c.Sales_Org__c ='1502';
        c.Add_to_VOC__c =false;
        caseList.add(c);
        insert caseList;
        //c.Add_to_VOC__c =true;
        //caseList.add(c);
        //update caseList;
        
        VOC_Data_Entry__c voc = new VOC_Data_Entry__c();
        voc.Account__c = c.AccountId;
        voc.Subject__c = c.Subject;
        voc.Note__c = c.Description;
        voc.Priority__c = c.Priority;
        voc.Category__c = 'Miscellaneous';
        insert voc;
        
        CT_CaseTriggerHandler handler = new CT_CaseTriggerHandler();
        Test.startTest();
        Map<Id, Case> caseMap = new Map<Id, Case>();
        for(Case record : caseList){
            caseMap.put(record.Id, record);
        }
        handler.beforeUpdateHandler(caseList,caseMap);
        handler.mapInvoiceToCase(c,i4);
        Test.stopTest();
        
        Id ceilingGypsumRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portal').getRecordTypeId();
        caseList = new List<Case>();
        c = new case();
        c.RecordTypeId = ceilingGypsumRT;
        c.status = 'New';
        c.AccountId = a4.Id;
        c.Subject ='test sub';
        c.Description ='test Description';
        c.origin = 'Email';
        c.order__c = o4.id;
        c.invoice__c = i4.id;
        c.Sold_to_Name__c = a4.Id;
        c.Ship_To_Company__c = a4.Id;
        c.Secondary_Quality_Category__c = 'Goodwill';
        c.Created_From_Order__c = true;
        c.Portal_Subject__c = 'Internal Service Case';
        c.Sales_Org__c ='1502';
        c.Add_to_VOC__c =True;
        caseList.add(c);
        insert caseList;
        
        VOC_Data_Entry__c voc1 = new VOC_Data_Entry__c();
        voc1.Account__c = c.AccountId;
        voc1.Subject__c = c.Subject;
        voc1.Note__c = c.Description;
        voc1.Priority__c = c.Priority;
        voc1.Category__c = 'Miscellaneous';
        //insert voc;
        
        aiuCaseUtil.portalCaseAssignment(caseList);
        aiuCaseUtil.caseSharing(new Set<String>{c.Id + '::::' + UserInfo.getUserId()});
    }
    @isTest
    public static void testaiuCaseUtil(){
        List<Case> caseList = new List<Case>();
        Case c = new case();        
        Id ceilingGypsumRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portal').getRecordTypeId();
        c.RecordTypeId = ceilingGypsumRT;
        c.status = 'New';
        c.origin = 'Email';
        caseList.add(c);
        insert caseList;
        aiuCaseUtil.portalCaseAssignment(caseList);
        aiuCaseUtil.caseSharing(new Set<String>{c.Id + '::::' + UserInfo.getUserId()});
        new CT_CasetriggerHandler().handleOwnerUpdate(new Set<Id>{c.Id});
    }
}