@istest
public class CompleteNextStepActivities_Test {
    @istest
    public static void runtest(){
        Account acc = new Account();
        acc.Name='test acc';
        insert acc;
        
        Task tk = new Task();
        tk.Subject='Next Step';
        tk.Status='Open';
        tk.WhatId=acc.Id;
        insert tk;
        
        list<Id> lstid= new list<id>();
        lstid.add(tk.WhatId);
        CompleteNextStepActivities.updateExistingActivtyRecords(lstid);
    }
    
}