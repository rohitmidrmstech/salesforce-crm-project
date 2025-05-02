public class PreventUsertoUpdateLegacyAmount {
    public static void preventForUpdatingLegacy(List<opportunity> newList , Map<Id, opportunity> oldmap){
         set<Id> optyIds = oldmap.keySet();       
         for(Opportunity opp :newList){
         if(opp.Migrated__c == true && ((oldmap.get(opp.Id).Total_Retail_Price_to_Use__c )!= opp.Total_Retail_Price_to_Use__c )){
           opp.Total_Retail_Price_to_Use__c.adderror('We can not update Legacy Total Retail Price for migrated orders');   
             }
             if((opp.Upgraded__c == true || opp.Migrated__c == true) &&  ((oldmap.get(opp.Id).Legacy_Amount__c )!= opp.Legacy_Amount__c  )){
              opp.Legacy_Amount__c.adderror('We can not update Legacy Total Retail Price for migrated orders');

             }

         }
           
    }       

}