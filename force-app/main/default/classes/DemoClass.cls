public class DemoClass {
public static void updateaccrecord() {
       list<Account> lstacc = new list<Account>() ;
        for(Account acc : [SELECT id, Name, phone FROM Account WHERE CreatedDate = LAST_WEEK ]){
            acc.Phone = '9766222805';
            
        }
        update lstacc;
    }        
        
}