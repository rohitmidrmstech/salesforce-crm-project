/**********************************************************************
Name:  WOD_CTUtilTest
===============================================================
Purpose: Test data set up class                                                                                                               
===============================================================
===============================================================
History                                                            
-------                                                            
AUTHOR        DATE            DETAIL                        
Tavant     28/05/2021      INITIAL DEVELOPMENT            
***********************************************************************/
@isTest(seealldata=false)
public class wod_zipperFutureTest {
    public static testMethod void zipperFutureTest()
    {
        WOD_ZipFile__c zip=new WOD_ZipFile__c();
        zip.name='word/document';
        zip.Business_Unit__c ='Roofing';
        insert zip;
        
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert claim;
        
        Attachment att1=new Attachment();
        att1.ParentId=zip.Id;
        att1.Name='word/document.docx';
        att1.Body=Blob.valueof('test');
        insert att1;
        
        Attachment att2=new Attachment();
        att2.ParentId=zip.Id;
        att2.Name='word/document.xml';
        att2.Body= Blob.valueOf('asd«Name»dfdfdfdsdsd');
        insert att2;
        
        wod_zipperFuture.sendMail(zip.name,claim.Id);
        
    }
}