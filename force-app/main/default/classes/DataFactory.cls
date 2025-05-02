public class DataFactory {
    public static Account_Relation__c CreateAccrec(string Name , Id setid){
        Account_Relation__c objrel = new Account_Relation__c();
        objrel.Name = Name;
        objrel.Account__c = setid;
        return objrel;
    }
}