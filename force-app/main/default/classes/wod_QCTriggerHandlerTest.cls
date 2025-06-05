/*
ClassName    : WOD_QCTriggerHandlerTest
CreatedOn    : 11/15/2021
Author		 : K Vishal
Description  : Test class for WOD_QCTriggerHandler
*/
@isTest
public class wod_QCTriggerHandlerTest {
    private static testmethod void statusChangeTest(){
        Account acc=WOD_TestDataFactory.createAccount('Test','','Customer');
        insert acc;
        WOD_2__Claim__c clm1=WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        insert clm1;
        WOD_2__Claim__c clm2=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm2.Product_Group__c = 'Solar';
        
        insert clm2;
        
        WOD_2__Claim__c clm3=WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        clm3.WOD_2__Claim_Status__c='Closed';
        insert clm3;
        
         WOD_2__Claim__c clm4=WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        clm4.WOD_2__Claim_Status__c='Claim';
        insert clm4;
       
        WOD_QC__c qc1=new WOD_QC__c();
        qc1.Claim__c=clm1.Id;
        qc1.Active__c=true;
        qc1.Lab_Status__c='Settle';
        insert qc1;
        
        WOD_QC__c qc2=new WOD_QC__c();
        qc2.Claim__c=clm2.Id;
        qc2.Active__c=true;
        qc2.isClassAction__c=true;
        qc2.Lab_Status__c='Settle';
        insert qc2;
        
        WOD_QC__c qc3=new WOD_QC__c();
        qc3.Claim__c=clm3.Id;
        qc3.Active__c=true;
        qc3.isClassAction__c=true;
        qc3.Lab_Status__c='Settle';
        insert qc3;
        
        WOD_QC__c qc4=new WOD_QC__c();
        qc4.Claim__c=clm4.Id;
        qc4.Active__c=true;
        qc4.isClassAction__c=true;
        qc4.Lab_Status__c='Settle';
        insert qc4;
        
        Test.startTest();
        
        WOD_UpdateQCStatus.statusChange(qc1.Id);
        WOD_UpdateQCStatus.statusChange(qc2.Id);
        qc2.Ownership_Type__c = 'Second';
        qc2.Date_of_Transfer__c = date.today();
        Update qc2;
        qc2.Ownership_Type__c = 'First';
        Update qc2;
        delete qc2;
        delete qc1;
        
        try{
            delete qc3;
        	
        }catch(Exception e){
           System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }
         try{
             delete qc4; 
        	
        }catch(Exception e){
           System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        }
      
        Test.stopTest();
        
    }

}