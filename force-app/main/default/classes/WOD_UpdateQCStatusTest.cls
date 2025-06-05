/*
ClassName    : WOD_UpdateQCStatusTest
CreatedOn    : 04/14/2021
Author		 : Ashraf Iqbal
Description  : Test class for WOD_UpdateQCStatus
*/
@isTest
private class WOD_UpdateQCStatusTest{
    private static testmethod void statusChangeTest(){
        
        Product_Type__c productType= WOD_TestDataFactory.createProductType();
        insert productType;
        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        product.Product_Type__c =productType.Id;
        product.Item_Class__c='90';
        product.Sales_Org__c='1501';
        insert product;
        
        Account acc=WOD_TestDataFactory.createAccount('Test','','Customer');
        insert acc;
        WOD_2__Claim__c clm1=WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        insert clm1;
        WOD_2__Claim__c clm2=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm2.Product_Group__c = 'Solar';
        clm2.WOD_2__Warranty_Product__c=product.id;
        insert clm2;
       
        List<WOD_QC__c> qcList=new List<WOD_QC__c>();
        WOD_QC__c qc1=new WOD_QC__c();
        qc1.Claim__c=clm1.Id;
        qc1.Active__c=true;
        qc1.Lab_Status__c='Settle';
        qc1.isClassAction__c=true;
        qc1.Material__c=product.id;
        qcList.add(qc1);
        
        
        WOD_QC__c qc2=new WOD_QC__c();
        qc2.Claim__c=clm2.Id;
        qc2.Active__c=true;
        qc2.isClassAction__c=true;
        qc2.Lab_Status__c='Settle';
        qc2.Material__c=product.id;
        qcList.add(qc2);
        
        WOD_QC__c qc3=new WOD_QC__c();
        qc3.Claim__c=clm1.Id;
        qc3.Active__c=true;
        qc3.Lab_Status__c='Settle';
        qc3.is_Fiberglass_Horizon_Class_Action__c=true;
        qc3.Material__c=product.id;
        qcList.add(qc3);
        
        WOD_QC__c qc4=new WOD_QC__c();
        qc4.Claim__c=clm1.Id;
        qc4.Active__c=true;
        qc4.Lab_Status__c='Settle';
        qc4.isClassAction__c=false;
        qc4.Material__c=product.id;
        qcList.add(qc4);
        
        insert qcList;
        
        
        WOD_UpdateQCStatus.statusChange(qc1.Id);
        WOD_UpdateQCStatus.statusChange(qc2.Id);
        WOD_UpdateQCStatus.statusChange(qc3.Id);
        WOD_UpdateQCStatus.statusChange(qc4.Id);
    }
    
     private static testmethod void getAllQCAssociatedWithClaim(){
        Account acc=WOD_TestDataFactory.createAccount('Test','','Customer');
        insert acc;
      
        WOD_2__Claim__c clm2=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        insert clm2;
       
        WOD_QC__c qc2=new WOD_QC__c();
        qc2.Claim__c=clm2.Id;
        qc2.Active__c=true;
        qc2.isClassAction__c=true;
        qc2.Lab_Status__c='Settle';
        insert qc2;
        
        WOD_UpdateQCStatus.getAllQCAssociatedWithClaim(clm2.Id);
    }
}