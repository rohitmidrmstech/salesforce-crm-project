@isTest
public class AccountTestHandlertest {
@istest
    public static void InsertRecord(){
     List<Account> Accountlist = new List<Account>() ;
        for(integer i = 0 ; i<= 5 ; i++){
          Account accold =new Account();
            accold.Name = 'Test off Trigger' + i;
            accold.CopybillingToShipping__c = true;
            accold.BillingCity = 'B1';
            accold.BillingCountry = 'BCountry';
            accold.BillingPostalCode = '344884';
            accold.BillingStreet = 'BStreet';
            accold.BillingState = 'Bstate';
            Accountlist.add(accold);
        }
        test.startTest();
        insert Accountlist;
        test.stopTest();
        Account newacc = [select id ,ShippingCity	 FROM Account WHERE Id  =: Accountlist[3].id];
        system.assertEquals(Accountlist[3].BillingCity, newacc.ShippingCity);
    }
    @isTest
    public static void updaterecord(){
     List<Account> Accountlist = new List<Account>() ;
        for(integer i = 0 ; i<= 5 ; i++){
          Account accold =new Account();
            accold.Name = 'Test off Trigger' + i;
            //accold.CopybillingToShipping__c = true;
            accold.BillingCity = 'B1';
            accold.BillingCountry = 'BCountry';
            accold.BillingPostalCode = '344884';
            accold.BillingStreet = 'BStreet';
            accold.BillingState = 'Bstate';
            Accountlist.add(accold);
        }
        test.startTest();       
        insert Accountlist;
        for(integer i = 0 ; i<= 3 ;i++){
            Accountlist[i].CopybillingToShipping__c = true;
        }
        update Accountlist;
        test.stopTest();
        Account newacc = [select id ,ShippingCity	 FROM Account WHERE Id  =: Accountlist[3].id];
        system.assertEquals(Accountlist[3].BillingCity, newacc.ShippingCity);
    }
}