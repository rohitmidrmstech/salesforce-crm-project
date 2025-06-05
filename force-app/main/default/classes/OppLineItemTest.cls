@isTest(seeAllData=false)
public class OppLineItemTest {
    @testSetup static void setup() {
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
        p.CanUseQuantitySchedule = true;            // Quantity Scheduling Enabled
        p.CanUseRevenueSchedule = true;
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
                                                Shipping_Start_Date__c = Date.Today(),
                                                Shipping_End_Date__c = Date.Today().addDays(3),
                                                TotalPrice = 100));
        insert oppProdList;
        OppLineItemScheduleTriggerHandler.isFirstRun = true;
        OpportunityLineItemSchedule scd = new OpportunityLineItemSchedule();
        scd.OpportunityLineItemId = oppProdList[0].id;
        scd.Type = 'Both'; //changed from Quantity to Both
        scd.ScheduleDate = Date.Today();
        scd.Quantity = 10;
        scd.Revenue = 4500;
        insert scd; 
        
        OppLineItemScheduleTriggerHandler.isFirstRun = true;
        delete scd; 
    }
 
    @isTest
    public static void testMethod2(){
        OpportunityLineItem opm = [Select id from OpportunityLineItem where Opportunity.Name ='TestOpp'];
        OpportunityLineItemTriggerHandler.isFirstRun =true;
     	Test.startTest();
        opm.Shipping_End_Date__c = Date.Today().addDays(120);
        update opm;
        Test.stopTest();
    }
        
}