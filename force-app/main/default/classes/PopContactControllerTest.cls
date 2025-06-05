// Created by Sneha on 1-Aug-2017 for S-503818

@isTest 
public class PopContactControllerTest
{
    static testMethod void testMethod1() 
    {
    
        Contact con= new Contact();
        con.LastName='testLast';
        con.MobilePhone='+8094588885';
        con.mailingstreet ='test street';
        con.MailingPostalCode ='119199';
        con.MailingCity ='New York';
        con.MailingState ='NY';
        con.MailingCountry ='US';
        con.Phone='123654789';
        insert con;
    
         Test.setCurrentPageReference(Page.PopContactVFPage);
         System.currentPageReference().getParameters().put('ANI', '+8094588885');
            
         PopContactController  obj= new PopContactController();
         obj.autoRun();
         

    
    
    }
    
    static testMethod void testMethod2() 
    {
    
        Contact con= new Contact();
        con.LastName='testLast';
        con.MobilePhone='8094588885';
        con.mailingstreet ='test street';
        con.MailingPostalCode ='119199';
        con.MailingCity ='New York';
        con.MailingState ='NY';
        con.MailingCountry ='US';
        con.Phone='123654789';
        insert con;
    
         Test.setCurrentPageReference(Page.PopContactVFPage);
         System.currentPageReference().getParameters().put('ANI', '8094588885');
            
         PopContactController  obj= new PopContactController();
         obj.autoRun();
         

   }
   
    static testMethod void testMethod3() 
    {
    
        Contact con= new Contact();
        con.LastName='testLast';
        con.MobilePhone='809-458-888-5';
        con.mailingstreet ='test street';
        con.MailingPostalCode ='119199';
        con.MailingCity ='New York';
        con.MailingState ='NY';
        con.MailingCountry ='US';
        con.Phone='123654789';
        insert con;
    
         Test.setCurrentPageReference(Page.PopContactVFPage);
         System.currentPageReference().getParameters().put('ANI', '809-458-888-5');
            
         PopContactController  obj= new PopContactController();
         obj.autoRun();
         

   }
}