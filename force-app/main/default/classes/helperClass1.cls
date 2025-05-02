public class helperClass1 {
 public void showAccount() {
        ParentAccount objParent = new ParentAccount();
        List<Account> lstAccs = objParent.showAccounts();
        
        for(Account acc :  lstAccs) {
            System.debug(acc.Name + ' - ' + acc.BillingCountry );
        }
    }

}