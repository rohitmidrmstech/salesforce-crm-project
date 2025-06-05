@isTest


public class Test_ProductAvailability{

    @isTest static void doGet() {
        Test.startTest();
    //create account
    Account acc = new Account();
    //enter details  
    acc.Name = 'Test Account';
    acc.Type ='test';
   acc.BillingStreet ='test';
    insert acc;
}
}