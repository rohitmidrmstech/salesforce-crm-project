@istest
public class AccountTriggerHandlerTest {
  @istest
    public static void SortAccount(){
       Account acc = new Account(Name = 'Test Account 1') ;
        insert acc;
        List<opportunity> lstopp = new List<opportunity>();
        integer nooffrecord = 10;          
        for(integer i = 1 ; i<nooffrecord ; i++){
            opportunity opp = new opportunity();
            opp.Name = 'Test class 1' + i ;
            opp.StageName = 'Closed won';
            opp.AccountId = acc.Id;
            opp.CloseDate = system.today() .addmonths(4);
            lstopp.add(opp);
        }
        insert lstopp;
       // List<Account> lstacc = [SELECT ID , Name FROM Account];
       test.startTest();
        delete acc;
        /*try{
                   delete acc;
        } catch (system.Exception ex){
            
        }*/
           
        test.stopTest();
    }
}