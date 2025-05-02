public class newranger {
    
    // DML - Data Manipulation Language
    // insert, update, delete
    
    public Account createAccount(String accName, String accNumber) {
        Account objAcc = new Account();
        objAcc.Name = accName;
        objAcc.AccountNumber = accNumber;        
        insert objAcc;
        return objAcc;        
    }    
    
    public void createContact(Account objAcc, String conEmail) {
        Contact objCon = new Contact();
        objCon.FirstName = objAcc.AccountNumber;
        objCon.LastName = 'Contact';
        objCon.Title = 'Test Title';
        objCon.Email = conEmail;
        objCon.Phone = '1234567890';
        objCon.AccountId = objAcc.Id;
        insert objCon;
    }
}