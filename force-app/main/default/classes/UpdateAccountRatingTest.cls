@isTest
public class UpdateAccountRatingTest {
    @isTest
    public static void Checkacc(){
        Account Accls = new Account();
        Accls.Name = 'test';
        Accls.Rating = 'warm';
        insert Accls;
        contact con = new contact() ;
        con.LastName = 'test off maahi';
        //con.Accountnumber__c = '98374983';
        con.AccountId = Accls.Id;
        insert con;
       /* UpdateAccountRating.AccountRating();
        
        Account acclst = [SELECT ID ,Name, Rating  FROM Account WHERE id =: Accls.Id];
        system.assertEquals('Hot', acclst.Rating);*/
        
    }     
}