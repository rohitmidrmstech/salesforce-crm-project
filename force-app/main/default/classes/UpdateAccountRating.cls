public class UpdateAccountRating {
    public static void AccountRating(){
  set<id> setAccid = new set<id>() ;
    List<Account> lstAcc = new List<Account>();
        for(contact con : [SELECT Id ,Name ,AccountId FROM contact WHERE Name like '%test%' AND AccountId != null]){
            if(!setAccid.contains(con.AccountId)){
                Account acc = new Account ();
                acc.Name = 'test Account';
                acc.Rating = 'Hot';
                acc.Id = con.Accountid;
                //sert acc;
                lstAcc.add(acc);
                 setAccid.add(con.Accountid);
            }
                
            }
        if(!setAccid.isEmpty()){
          update lstAcc;
        }
            
        }
            
        }