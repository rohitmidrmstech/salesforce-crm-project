@isTest
public class TestaiuWtuOpportunity {
	static testMethod void createOpportunity() {
        Account a1 = new Account();
		a1.Name = 'Test Account1';
		a1.Short_Name__c = 'TA';
		insert a1;
        Opportunity obj_Opp = new Opportunity();
        obj_Opp.Name = 'Test Opp';
        obj_Opp.AccountId = a1.Id;
        obj_Opp.CloseDate = Date.today();
        obj_Opp.StageName = 'open'; 
        obj_Opp.WTU_Notes__c = 'Test Notes';
        insert obj_Opp;
     }
}