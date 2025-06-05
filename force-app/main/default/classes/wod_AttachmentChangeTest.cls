/**
 * @description Test class for wod_AttachmentChange 
*/
@isTest
public class wod_AttachmentChangeTest {
    /**
	 * @description method for test data set up
	*/
	private static testMethod void testOne() {
        WOD_ZipFile__c zip=new WOD_ZipFile__c();
        zip.name='test';
        zip.Business_Unit__c ='Roofing';
        insert zip;
      
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert claim;        
        
        Attachment att=new Attachment();
        att.ParentId=zip.Id;
        att.Name='word/document.xml';
        att.Body= Blob.valueOf('asd«Name»dfdfdfdsdsd');
        insert att;
        
        Attachment att3=new Attachment();
        att3.ParentId=zip.Id;
        att3.Name='word/documentOri.xml';
        att3.Body= Blob.valueOf('asd«Name»dfdfdfdsdsd');
        insert att3;
        
        Attachment att2=new Attachment();
        att2.ParentId=claim.Id;
        att2.Name='word/documentOri.xml';
        att2.Body=Blob.valueof('test');
        insert att2;
        
        wod_AttachmentChange objHandler = new wod_AttachmentChange();
        objHandler.FaultCodeFunc(claim.Id,zip.Id);
        
        contact obj = new contact();
        string StrVal = 'Account' + '.' + 'Account' ;
        try{
            wod_AttachmentChange.splitString(StrVal, obj);
            //wod_zipperFuture.sendMail(zip.name,claim.Id);
        } 
        catch(Exception e){}
    }
    /**
	 * @description method for test data set up
	*/
    private static testMethod void testTwo() {
        WOD_ZipFile__c zip=new WOD_ZipFile__c();
        zip.name='test';
        zip.Business_Unit__c ='Roofing';
        insert zip;
      
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert claim;
        
        
        Attachment att=new Attachment();
        att.ParentId=zip.Id;
        att.Name='word/document.xml';
        att.Body= Blob.valueOf('asd«Name»dfdfdfdsdsd');
        insert att;
               
        Attachment att2=new Attachment();
        att2.ParentId=claim.Id;
        att2.Name='word/documentOri.xml';
        att2.Body=Blob.valueof('test');
        insert att2;
        
        Attachment att3=new Attachment();
        att3.ParentId=zip.Id;
        att3.Name='test.docx';
        att3.Body= Blob.valueOf('asd«Name»dfdfdfdsdsd');
        insert att3;
        
        wod_AttachmentChange objHandler = new wod_AttachmentChange();
        objHandler.FaultCodeFunc(claim.Id,zip.Id);        
        objHandler.id=claim.Id;
        objHandler.logo='fsdfs';
        objHandler.header='gdfdg';
        objHandler.footer='dfasf';
        //wod_zipperFuture.sendMail(zip.name,claim.Id);
    }
}