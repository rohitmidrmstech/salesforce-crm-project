public class ArchieveOpportunityRecord {
        public void insertionoffRecord(){
            
            list<opportunity> lstopp = new list<opportunity>();
            list<Opportunity_Archieve__c> lstArchieveOpp = new list<Opportunity_Archieve__c>() ;
            for(Account acc : [SELECT ID ,Name ,(SELECT ID,Name ,StageName ,CloseDate FROM Opportunities) FROM Account]){
                for(Opportunity accopp : acc.Opportunities) {
                    Opportunity_Archieve__c aropp1 = new Opportunity_Archieve__c();
                    aropp1.close_Date__c = accopp.CloseDate;
                    aropp1.Stage_Name__c = accopp.StageName;
                    aropp1.Name = accopp.Name + 'itsrealtime';
                    aropp1.Account__c = acc.Id;
                    lstArchieveOpp.add(aropp1);
                    lstopp.add(accopp);
                }    
                
            }          
            insert lstArchieveOpp ;
            delete lstopp;             
            
            
            
            
        }
        public static void Updateaccountnumber(){
            list<Account> lstacc = new list<Account>();
            for(Account acc : [SELECT Id ,Name ,phone FROM Account]){
                acc.phone = '9766222805';
                lstacc.add(acc);
                update lstacc;
            }
         } 
    
    public void deleterecord(){
        set<Id> setaccid = new set<Id>{'0015j00000UCZCf','0015j00000UCZAZ'};
      list<Account> lstacc = [SELECT Id ,Name , isDeleted , (SELECT id ,Name FROM contacts) FROM Account All rows ]; 
       undelete lstacc;
        
    }
    
    public void updatephonetocontact(){
     list<contact> lstacc = [SELECT ID,Name ,phone ,Account.id,Account.phone FROM contact WHERE Accountid != null];
        for(contact con : lstacc){
            if(con.phone == NULL){
               con.phone =con.Account.phone; 
            }
            
            
        }
        update lstacc;
    } 
    }