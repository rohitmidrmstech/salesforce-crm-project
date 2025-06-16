@isTest
public class Test_ProductAvailabilityController {
    
    
    @isTest static void doGet() {
       // Test.startTest();
        Profile int_PF = [SELECT ID, Name FROM Profile WHERE Name = 'Integration User'];
        Profile sr_PF = [SELECT ID, Name FROM Profile WHERE Name = 'Sales Rep'];
        
       
        User int_User = New User();
        int_User.LastName = 'Integration User';
        int_User.ProfileId = int_PF.id;
        int_User.Alias ='intuser';
        int_User.Role__c ='TM';
        int_User.Email = 'integration123@saint-gobain.com';
        int_User.Username = 'integration123@saint-gobain.com';
        int_User.TimeZoneSidKey = 'America/New_York';
        int_User.EmailEncodingKey = 'UTF-8';
        int_User.SAP_TM_number__c ='0000011284';
        int_User.LocaleSidKey = 'en_US';
        int_User.LanguageLocaleKey =  'en_US'; 
       
        insert int_User;
        
        User sr_User = New User();
        sr_User.LastName = 'SalesRep';
        sr_User.ProfileId = sr_PF.id;
        sr_User.Alias ='SalesRep';
         sr_User.Role__c ='TM';
        sr_User.Email = 'SalesRep@saint-gobain.com';
        sr_User.Username = 'SalesRep@saint-gobain.com';
        sr_User.TimeZoneSidKey = 'America/New_York';
        sr_User.EmailEncodingKey = 'UTF-8';
        sr_User.LocaleSidKey = 'en_US';
        sr_User.LanguageLocaleKey =  'en_US';
       
        insert sr_User;
      
        User sr_User1 = New User();
        sr_User1.LastName = 'SalesRep1';
        sr_User1.ProfileId = sr_PF.id;
        sr_User1.Alias ='SaleRep1';
        sr_User.Role__c='TM';
        sr_User1.Email = 'SalesRep1@saint-gobain.com';
        sr_User1.Username = 'SalesRep1@saint-gobain.com';
        sr_User1.TimeZoneSidKey = 'America/New_York';
        sr_User1.EmailEncodingKey = 'UTF-8';
        sr_User1.LocaleSidKey = 'en_US';
        sr_User1.LanguageLocaleKey =  'en_US'; 
        sr_User1.SAP_TM_Number__c = '789';
        //sr_User1.UserRoleId  = r.Id;
        insert sr_User1;
        //create account
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Type ='test';
        acc.BillingStreet ='test';
        insert acc;
        
        System.runAs(int_User){
            Region__c regNew = new Region__c();
            regNew.Name = 'test';
            regNew.Active__c = true;
            insert regNew;
            
            List<Territory__c> territoryList = new  List<Territory__c>();
            Territory__c terr1 = new Territory__c();
            terr1.Name = 'New Territory1';
            terr1.Active__c = true;
            terr1.Region__c= regNew.Id;
            terr1.Sales_Rep__c = sr_User.id;
             terr1.SAP_TM_number__c ='0000011284';
            terr1.SAP_TM_Name2__c = 'testSAP';
            terr1.Sales_Org__c='1501';
            territoryList.add(terr1) ;
            
            Territory__c terr2 = new Territory__c();
            terr2.Name = 'New Territory2';
            terr2.Territory_Code__c = '123';
            terr2.Active__c = true;
            terr2.Region__c = regNew.Id;
            terr2.Sales_Rep__c = sr_User1.id;
             terr2.SAP_TM_number__c ='0000011284';
             terr2.Sales_Org__c='1501';
            territoryList.add(terr2) ;
            
            Territory__c terr3 = new Territory__c();
            terr3.Name = 'national';
            terr3.Territory_Code__c = '999';
            terr3.Active__c = true;
            terr3.Region__c= regNew.Id;
            terr3.Sales_Rep__c = sr_User1.id;
             terr3.SAP_TM_number__c ='0000011284';
             terr3.Sales_Org__c='1102';
            territoryList.add(terr3);
           insert territoryList;
            System.debug('territoryList++'+territoryList);
            
            Plants__c pObj= new Plants__c();
            pObj.Name = 'test';
            pObj.SAP_Plant__c='0266';
            insert pObj;
            
            product2 productRecord1 = new product2();
            productRecord1.Name = 'TestProduct';
            productRecord1.ProductCode = 'p12345';
            productRecord1.Description = 'Test Product';
            productRecord1.Item_Class_Description__c = ' Test class';
            productRecord1.Item_Class__c =  ' Test Prodcut1';
            productRecord1.MKT_CLASS__c = 'Battery';
            productRecord1.Item_Sub_Family__c = 'testsub';
            productRecord1.Sales_Org__c='1501';
            productRecord1.PROD_TYPE__c ='PV Other';
            productRecord1.Plants__c='0266'; 
            Insert productRecord1;
    
            
            list<string>listOfTest = new list<string>();
            listOfTest.add('st1');
            listOfTest.add('st2');
            
             List<Plants__c> sapPlantList =[Select name,SAP_Plant__c,Id From Plants__c where name =:pObj.Name limit 50];
            //List<Territory__c> territoryList =[select id,name,Sales_Org__c from Territory__c where name= :territoryList[0].name and  Sales_Org__c in ('1501','1102') ];
            String sapPlant ='%' + sapPlantList[0].SAP_Plant__c+ '%';
            //Map<String, List<Territory__c>> territoryMap = new Map<String, List<Territory__c>>();
            //ProductAvailabilityController.territoryTypeMap  
            //public static List<String> getTerritories(){
            ProductAvailabilityController prod = new ProductAvailabilityController();
            ProductAvailabilityController.getTerritories ();
            
            ProductAvailabilityController ctrl = new ProductAvailabilityController();
            
            ctrl.displayMsg = null;
            ctrl.userId = null;
            ctrl.lstProductAvailabilityResponse = null;
            ProductAvailabilityController.plantesOption = null;
            ProductAvailabilityController.marketClassesOption = null;
            ProductAvailabilityController.productTypesOption = null;
            ProductAvailabilityController.itemDescriptionOption = null;
            ProductAvailabilityController.mapPlant = new Map<String, String>();
            
            try{
            ProductAvailabilityController.getProductTypes(pObj.Name,'Battery',sr_User1.id);
            }catch(exception e) {}
            try{
                ProductAvailabilityController.getItems(pObj.Name,'Battery','testsub',sr_User1.id,territoryList[0].Name);
            }catch(exception e) {}
            try{ ProductAvailabilityController.searchProducts(pObj.Name,'TestProduct',sr_User1.id);
                 ProductAvailabilityController.searchProducts(pObj.Name,'',sr_User1.id);
               }catch(exception e){
                   try{
                       ProductAvailabilityController.searchProducts(pObj.Name,'',sr_User1.id);
                   }catch(exception ex){}
               }
            try      {
                ProductAvailabilityController.getMarkets(pObj.Name,sr_User1.id);
            }catch(exception e)
            {}
            try      {
             System.debug('territoryList[0].id++'+territoryList[0].id);
              System.debug('sr_User1.id++'+sr_User1.id);
                ProductAvailabilityController.getPlantes(territoryList[0].Name,sr_User1.id);
                ProductAvailabilityController.getPlantes('',sr_User1.id);
             }
            catch(exception e)
            {}
            ApexPages.currentPage().getParameters().Put('territoryType','Residential');
             ApexPages.currentPage().getParameters().put('territoryId',String.valueOf(territoryList[0].Id));
            ProductAvailabilityResponse par = new ProductAvailabilityResponse();
            ProductAvailabilityController pro = new ProductAvailabilityController();
            pro.getLstSuccesses();
            pro.onPageLoad();
            //PageReference pageRef = Page.yourPageName;
          
             // pro.getLstSuccesses();
         }
     
    }
    public static testMethod void dotest1(){
        Profile sr_PF = [SELECT ID, Name FROM Profile WHERE Name = 'Sales Rep'];
        
        User sr_User = New User();
        sr_User.LastName = 'SalesRep';
        sr_User.ProfileId = sr_PF.id;
        sr_User.Alias ='SalesRep';
        sr_User.Role__c ='TM';
        sr_User.Email = 'SalesRep@saint-gobain.com';
        sr_User.Username = 'SalesRep@saint-gobain.com';
        sr_User.TimeZoneSidKey = 'America/New_York';
        sr_User.EmailEncodingKey = 'UTF-8';
        sr_User.LocaleSidKey = 'en_US';
        sr_User.LanguageLocaleKey =  'en_US';   
        insert sr_User;
        
         User sr_User2 = New User();
        sr_User2.LastName = 'SalesRep1';
        sr_User2.ProfileId = sr_PF.id;
        sr_User2.Alias ='Sales1';
        sr_User2.Role__c ='TM';
        sr_User2.Email = 'SalesRep1@saint-gobain.com';
        sr_User2.Username = 'SalesRep1@saint-gobain.com';
        sr_User2.TimeZoneSidKey = 'America/New_York';
        sr_User2.EmailEncodingKey = 'UTF-8';
        sr_User2.LocaleSidKey = 'en_US';
        sr_User2.LanguageLocaleKey =  'en_US';   
        insert sr_User2;
        
        Region__c regNew = new Region__c();
        regNew.Name = 'test';
        regNew.Active__c = true;
        insert regNew;
        
        Territory__c terr2 = new Territory__c();
        terr2.Name = 'New Territory2';
        terr2.Territory_Code__c = '123';
        terr2.Active__c = true;
        terr2.Region__c = regNew.Id;
        terr2.Sales_Rep__c = sr_User.id;
        terr2.SAP_TM_number__c ='0000011284';
        terr2.Sales_Org__c='1501';
        insert terr2 ;
        ApexPages.currentPage().getParameters().put('territoryId',String.valueOf(terr2.Id));
        ProductAvailabilityController pro = new ProductAvailabilityController();
        //ProductAvailabilityController.test();
        
        pro.onPageLoad();
        
        ApexPages.currentPage().getParameters().put('territoryId',null);
        
        ProductAvailabilityController.territoriesOption = new List<SelectOption>();
        ProductAvailabilityController.territoriesOption.add(new SelectOption(terr2.Id, 'Test1'));
        ProductAvailabilityController.territoriesOption.add(new SelectOption(terr2.Id, 'Test2'));
       // ProductAvailabilityController.getItems('pname','mname','ptname',sr_User2.id,terr2.Name);
        ProductAvailabilityController pro1 = new ProductAvailabilityController();
        //ProductAvailabilityController.test();
        
        pro1.onPageLoad();
    }
     public static testMethod void StockAvailabilityCallSuccess(){
        //Initialize the custom setting
        insert new WSDefaults__c(
            Stock_Availability_Endpoint__c = 'http://sap-wddev.certainteed.com/qa/StockAvailability/StockAvailability.asmx'
        );
        Test.startTest();
            //Set the mock response for a siding price call
            Test.setMock(HttpCalloutMock.class, new WSMockResponse(WSMockResponse.Type.STOCKAVAILSUCCESS));
            
            //Create the test request
           
                WS.StockAvailRequest request = new WS.StockAvailRequest();
                request.lstMaterials = new List<String>{'620990'}; //IvMat //Material
                    request.strPlant = '277'; //IvPlant //IPlant
                WS.StockAvailabiltyResponse r = WS.stockAvailabilityCall(request);
                System.assert(r.lstSuccesses.size() > 0); 
                ProductAvailabilityController pro = new ProductAvailabilityController();
                pro.getLstSuccesses();
           
        Test.stopTest();
    }
    
}