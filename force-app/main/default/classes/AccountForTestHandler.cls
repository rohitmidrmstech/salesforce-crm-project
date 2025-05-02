public class AccountForTestHandler {
    public static void InsertBulkAcc (List<Account> Acclst){
        for(Account acc : Acclst)  {
            if(acc.CopybillingToShipping__c == true){
                acc.ShippingStreet = acc.BillingStreet;
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingState = acc .BillingState;
                
            }  
        }
    }
}