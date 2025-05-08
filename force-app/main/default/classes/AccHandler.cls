public class AccHandler {
    public static void accUser(List<Account>lstAcc){
        // List<User> UserList = [Select Id,Alias from USER where Alias =: AliasNames];
        List<Account> lstac = new List<Account>();
        for (Account acc : lstAcc){           
            if(acc.Account_status__c == 'Verification Needed'){
                        User UserList = [Select Id,Name,LastName from USER where Name =: 'rohit chormalle'];
                   acc.OwnerId = UserList.LastName;
                lstac.add(acc);
                system.debug('ownerd id >>'+UserList.id );
                }
            }
        update lstac;
        }
        /** showDetailClaim - is used to show the detail info of
         * Selected Claim on the Experiance UI.
        */
        public static void  showDetailClaim(){
        
        }
          /** showDetailClaim2 - is used to show the detail info of
         * Selected Claim on the Experiance UI.
        */
        public static void  showDetailClaim2(){
            // Code to commit-1
        
        }

}
}
