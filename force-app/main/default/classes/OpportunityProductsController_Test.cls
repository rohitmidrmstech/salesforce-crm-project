// Created by Sneha on 2-Aug-2017 for S-503818
@isTest
public class OpportunityProductsController_Test {
    public static testMethod void testMyController() {
         
        
        Account a = new Account(Name='testAccount',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId()); //Added by Purnima for Story S-562343
         insert a; 
         System.debug('a'+a);
        
         Id pricebookId = Test.getStandardPricebookId();
        system.debug('value of pricebook = ' + pricebookId);
        //Pricebook2 objPriceBook = new Pricebook2();
        //objPriceBook.Id = pricebookId;
        //Insert objPriceBook;
       //System.debug('objPriceBook'+objPriceBook);

          

        system.debug('@@@@@'+pricebookId );
        
        if( pricebookId != null ) {            
            Product2 prod = new Product2(Name = 'Laptop X20056',  isActive = true,
                                     Family = 'Hardware');
            insert prod;
            Profile profile = [Select Id From Profile where Name = 'System Administrator' limit 1];
            User usr1= new User();
            usr1.ProfileID = profile.Id;
            usr1.Username = 'Neha@acme.com';
            usr1.LastName = 'TestUserLastName';
            usr1.Email = 'Test@gmail.com'; 
            usr1.Alias = 'Test1';
            usr1.TimeZoneSidKey = 'America/Los_Angeles';
            usr1.EmailEncodingKey = 'UTF-8';
            usr1.LanguageLocaleKey = 'en_US';
            usr1.LocaleSidKey = 'en_US';
            
                //all other required field.
            insert usr1;
            System.runAs(usr1){
            }
                
            List<PriceBookEntry> pbe = [Select id from PriceBookEntry where Product2Id=:prod.id and Pricebook2Id=:pricebookId LIMIT 1];
            System.debug('pbe.size()'+pbe.size());
            if (pbe.size() > 0) {
              pbe[0].UnitPrice=99;
              pbe[0].IsActive=true;
            } 
            else {        
            PricebookEntry pb = new PricebookEntry(
                 Pricebook2Id=pricebookId,
                 Product2Id=prod.id,
                 UnitPrice=3000,
                 UseStandardPrice=false,
                 isActive=true
            );
               pbe.add(pb);
           }
           upsert pbe;
            
            Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook Test class1', isActive=true);
            insert customPB;
            
            PricebookEntry customPrice = new PricebookEntry(
                Pricebook2Id = customPB.Id, Product2Id = prod.Id,
                UnitPrice = 12000, IsActive = true,UseStandardPrice=false);
            insert customPrice;
           
            
            Plants__c plantObj = new Plants__c();
            plantObj.Name = 'New Plant';
            plantObj.City__c =  'ajmer';
            plantObj.SAP_Plant__c = 'test SAP';  
            insert plantObj;
            
            String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id; 
            Product2 productType = new Product2();        
            productType.ProductCode = 'End';
            productType.Name ='New product1';
            productType.Guideline_Code__c = 'ECO';
            productType.Stocking_to_Selling_Conversion_Factor__c = 20;
            productType.SELL_UOM__c = 'CA';
            productType.RecordTypeId = strRecordTypeId; 
            productType.Request_Status__c = 'Rejected';
            productType.Sales_Org__c = '1101';
            productType.ApprovingPlant__c = plantObj.Id;
            insert productType;
            
            
            
            Opportunity opp = new Opportunity(Name='Testing', 
                                              Account = a, 
                                             // Product__c='GRI Retail',
                                              NextStep='testing',
                                              PriceBook2 = customPB,
                                              CloseDate = System.today(),
                                              AccountId=a.Id, 
                                             // Opportunity_Name__c='testOpp',
                                             // Product_Family__c='Retail',
                                             Industry__c='Other',
                                             Description='TestTestTest',
                                             StageName='Closed Won - One Time' 
                                             );
           
            insert opp; 
            opp.PriceBook2 =customPB;
            update opp;
         
         List<OpportunityLineItem> oppProdList = new List<OpportunityLineItem>();
         for(Integer i=1;i<=10;i++)
             oppProdList.add(new OpportunityLineItem(Opportunityid = opp.Id,Product2id = productType.id,PricebookEntryId=customPrice.Id,Quantity =3,TotalPrice = 100));
             System.debug('test@@@'+ oppProdList );        
             insert oppProdList;
         
             //ApexPages.StandardSetController sc = new ApexPages.StandardSetController(oppProdList);
    
           // PageReference pageRef; //= Page.OpportunityProducts;
            //pageRef.getParameters().put('id', opp.id);
           //Test.setCurrentPage(pageRef);
        
        //Test.setCurrentPageReference(Page.OpportunityProducts);
        
        /*OpportunityProductsController obj= new OpportunityProductsController();
        obj.cancel();
        obj.getJDEProductRTId();
        obj.setProd();*/
        
        OpportunityProductsController obj= new OpportunityProductsController();
        obj.selectedRowNum=1;
        obj.selectedRowProdId=productType.id;
        obj.selectedRowProdName=productType.Name;
        obj.cOpp=opp;
        List<OpportunityLineItem> testopp= new List<OpportunityLineItem>();
        obj.clstOppProds=oppProdList;
        List<OpportunityLineItem> testOpps= new  List<OpportunityLineItem>();
        obj.clstDelOppProds=oppProdList;
        
        obj.getJDEProductRTId();
       
        //Product_Type__c pt = new Product_Type__c(id='test', name='test');
        System.debug('clstOppProds==>' + obj.clstOppProds);
            System.debug('clstDelOppProds==>' + obj.clstDelOppProds);
        
        PageReference pg = obj.doSave(); 
        PageReference pg1 = obj.addNew(); 
        //PageReference pg3 = obj.setProd(); //this method can not call because this error has occur
        // https://salesforce.stackexchange.com/questions/129314/product2id-is-not-writeable-any-work-around-for-that 
        PageReference pg2 = obj.removeRow(); 
        
        obj.cancel();
        }
    }
}