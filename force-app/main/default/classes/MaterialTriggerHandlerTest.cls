@isTest
public class MaterialTriggerHandlerTest {
       @testsetup static void createMaterials(){
        List<RecordType> rtypes = [SELECT Id,Name FROM RecordType WHERE SobjectType=: constants.materialObjAPIName AND Name =:constants.materialNewPrrodRTName];
        Map<String,String> rTypMap = new Map<String,String>{};
            
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User usr = new User();
        usr.Alias = 'standt';
        usr.Email='teststandarduser2@testorg.com';
        usr.EmailEncodingKey='UTF-8';
        usr.LastName='Testing';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.ProfileId = p.Id;
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.UserName='teststandarduser2@testorg.com';      
        insert usr;
       List<Plants__c> newPlantRecords = new List<Plants__c>();
           //SAP_Plant__c,Name,Plant_Queue_Id__c 
      //  Plants__c whouse = new Plants__c();
       // whouse.Name = 'Meridian';
       // whouse.SAP_Plant__c = '0813';
       // insert whouse;
      
      //  Plants__c whouse1 = new Plants__c();
       // whouse1.Name = 'SteerCeilings';
       // whouse1.SAP_Plant__c = '0823';
       // insert whouse1;
        //  newPlanstRecord.add(whouse1);  
           
           
               
             
          
         
        /*   Plants__c  Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        insert Testingplant1; */

       /* Product2  newProdectRecord = new Product2();
           newProdectRecord.Name = 'Test Product';
           newProdectRecord.ProductCode = '123456';
           newProdectRecord.Stocking_to_Selling_Conversion_Factor__c = 0.50;
           newProdectRecord.Sales_Org__c = '1003';
           newProdectRecord.RecordTypeId = rtypes[0].id;
           newProdectRecord.ApprovingPlant__c =newPlantRecords[0].Id;
           insert newProdectRecord; */
           
           /* Start: This Code Not Covered By Trigger Directly, So We Called Handler Method Directly*/
           newPlantRecords.add(new Plants__c(SAP_Plant__c ='0813',Name ='GYP Malvern',Plant_Manager__c = UserInfo.getUserId()));
           newPlantRecords.add(new Plants__c(SAP_Plant__c ='0823',Name ='GYP Cambridge Reload',Plant_Manager__c = UserInfo.getUserId()));
           newPlantRecords.add(new Plants__c(SAP_Plant__c ='0636',Name ='Ecophon',Plant_Manager__c = UserInfo.getUserId()));
           newPlantRecords.add(new Plants__c(SAP_Plant__c ='217900',Name ='Rancho',Plant_Manager__c = UserInfo.getUserId()));
           insert newPlantRecords;  
           List<Product2> newProductRecords1 = new List <Product2>();
           List<Product2> newProductRecords2 = new List <Product2>();
           newProductRecords1.add(new Product2(Name ='Test Product', ProductCode ='123456', Plants__c = '0813',Product_Family__c ='Grid', RecordTypeId = rtypes[0].id, ApprovingPlant__c = newPlantRecords[0].Id, Sales_Org__c ='1003', CORP_CLASS__c = 'CTC TECHSTYLE'));
           newProductRecords2.add(new Product2(Name ='Test Product2', ProductCode ='12356',Plants__c = '0813', Product_Family__c ='Fiberglass', RecordTypeId = rtypes[0].id, ApprovingPlant__c = newPlantRecords[0].Id, Sales_Org__c ='1003'));
           insert newProductRecords1;
           insert newProductRecords2;
           MaterialTriggerHandler.setProductOwnerasPlantManager(newProductRecords2);
           /* End: This Code Not Covered By Trigger Directly, So We Called Handler Method Directly*/
           
      /*  List<Product2> lst_products = new List<Product2>();
           for(Integer i=0; i <10; i++){
               Product2 prod = new Product2();       
                prod.Name = 'Test Product';
                prod.ProductCode = '123456';
                prod.Stocking_to_Selling_Conversion_Factor__c = 0.50;
                prod.Sales_Org__c = '1003';
                prod.RecordTypeId = rtypes[0].id;
                 prod.ApprovingPlant__c =newPlantRecords[0].Id;
               system.debug('****prod.RecordTypeId*****'+prod.RecordTypeId);
               if(i==0){
                  prod.Plants__c = '0813'; 
                  prod.Stocking_to_Selling_Conversion_Factor__c = null;
                  prod.MSF_MS_Conversion__c = 1;
               }
               else if(i==1){
                  prod.Plants__c = '0813';
                  prod.Product_Family__c = 'Ecophon';
                  prod.Stocking_to_Selling_Conversion_Factor__c = null;
                  prod.MSF_MS_Conversion__c = null;
               }    
               else if(i==2){
                  prod.Plants__c = '0813';
                  prod.Product_Family__c = 'Ecophon';
               }  
               else if(i==3){
                  prod.Plants__c = '0813';                 
               }  
               lst_products.add(prod);
           }
           insert lst_products;      */                   
        
    }  
    public static testMethod void testCaseTrigger(){
       /*Kondal List<product2> lst_Products = [SELECT ID,Name,Plants__c,Plant_Names__c FROM product2];
        List<product2> updlst_Products = new List<product2>();
         Test.startTest(); 
         for(product2 objProd : lst_Products){
             objProd.Plants__c = '0812';
            updlst_Products.add(objProd);
             
         }        
          update updlst_Products;                            
         Test.stopTest(); Kondal */
         
        Plants__c  Testingplant2 = new Plants__c();
        Testingplant2.Name ='Testing2324';
        Testingplant2.SAP_Plant__c ='0823';
        Testingplant2.Plant_Manager__c = UserInfo.getUserId();
        insert Testingplant2;
        
                Product2 prod = new Product2();       
                prod.Name = 'Test Product';
                prod.ProductCode = '123456';
                prod.Stocking_to_Selling_Conversion_Factor__c = 0.50;
                prod.Sales_Org__c = '1003'; 
                prod.Plants__c = '0813';
                prod.ApprovingPlant__c = Testingplant2.Id;
                prod.CORP_CLASS__c = 'CTC TECHSTYLE';
                insert prod;
                
               product2 lst_Products = [SELECT ID,Name,Plants__c,Plant_Names__c FROM product2 where id=:prod.id];
               lst_Products.Plants__c = '0812';
               update lst_Products;
                     
    }
}