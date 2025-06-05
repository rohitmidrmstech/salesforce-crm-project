@isTest
public class HandleCustomExceptionLogsTest {
     @isTest
      public static void CreateAccount() {
        try {
            Account m = new Account();
            insert m;
        } catch (Exception e) {
            HandleCustomLogsException.LogException(e);
        }    
    } 

}