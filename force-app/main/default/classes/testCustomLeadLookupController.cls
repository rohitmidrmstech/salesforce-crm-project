@isTest (seeAllData = true)
public class testCustomLeadLookupController
{

        
    static testMethod void CustomLeadLookupControllertest()
    {
        
        CustomLeadLookupController con = new CustomLeadLookupController();
        PageReference pr = con.search();
       
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'class';
        l.Company = 'testCompany';
        insert l;
      
        string s1 = con.getFormTag();       
        string s =  con.getTextBox();
        
    }
}