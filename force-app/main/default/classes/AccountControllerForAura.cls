public class AccountControllerForAura {
    @AuraEnabled
    public static List<Account> getAccounts(){
        List<Account> acclist= new List<Account>();
        acclist = [SELECT Id ,Name,Phone FROM Account LIMIT 50];
        return acclist;
    } 
     @AuraEnabled
    public static List<contact> getContacts(Id recordId){
        return [SELECT Id ,Name ,Email,Phone FROM contact WHERE AccountId=:recordId];
    
    }   
    
}