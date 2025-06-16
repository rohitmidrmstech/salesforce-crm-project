/*********************************************************************************
* Test Class: {TestBusinessPlan}
* Created by Alan Brown 4/19
********************************************************************************/
@isTest
private class TestOpportunityProduct {

    static testMethod void create() {
        
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingState = 'North York';
        a.BillingCity = 'ON';
        insert a;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpp';
        opp.Accountid = a.id;
        opp.CloseDate = System.today();
        opp.Industry__c = 'Hospitality';
        opp.StageName ='Design';
        opp.Description = 'This is test description';
        insert opp;
        
        Plants__c  Testingplant3 = new Plants__c();
        Testingplant3.Name ='Testing2324';
        Testingplant3.Plant_Manager__c = UserInfo.getUserId();
        Testingplant3.SAP_Plant__c = 'test SAP';       
        insert Testingplant3;
        
        Product2 p = new product2();
        p.name='TestProductAlan';
        p.productCode = 'test12';
        p.Sales_Org__c = '1101';
        p.SAP_Material__c = '9081638445_1101';
        p.ApprovingPlant__c = Testingplant3.id;
        insert p; 
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook1', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
        Pricebook2Id = customPB.Id, Product2Id = p.Id,
        UnitPrice = 12000, IsActive = true,UseStandardPrice=false);
        insert customPrice;
        
        
        List<OpportunityLineItem> oppProdList = new List<OpportunityLineItem>();
        
        oppProdList.add(new OpportunityLineItem(Opportunityid = opp.Id,
                                                Product2id = p.id,
                                                PricebookEntryId=customPrice.Id,
                                                Quantity =3,
                                                TotalPrice = 100));
        
        System.debug('test@@@'+ oppProdList );
        
        insert oppProdList;
        
        OpportunityLineItem oppItem = [select id, product2id, newProduct2__c from opportunityLineItem where opportunityid = :opp.id].get(0);
        //System.assertEquals(oppItem.product2id, oppItem.newProduct2__c);
        

    }
}