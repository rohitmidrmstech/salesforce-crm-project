public class TriggerhandlerObjA {
    public static void preventduplicate(List<obiA__c> lstobj ,map<id,obiA__c> oldmap){
        /* //set<string> emailset = new set<string>();
set<id> setObjId = new set<id>();
for(obiA__c job : lstobj){
setObjId.add(job.id);
system.debug('setObjId>>>>' +setObjId );

}*/
        set<string> emailset = new set<string>();
        set<string> phoneset = new set<string>();       
        //List<obiA__c> lstobject = [SELECT email__c ,phone__c FROM obiA__c WHERE email__c!= null AND phone__c != null ];
        for(obiA__c acc : [SELECT id,email__c ,phone__c FROM obiA__c  ]){
            if(acc.email__c != null){
                emailset.add(acc.email__c);                        
                //phoneset.add(acc.phone__c); 
                system.debug('emailset>>>>' +emailset );
            }      
        }
        for(obiA__c acc : [SELECT email__c ,phone__c FROM obiA__c ]){
            if(acc.phone__c!= null){
                phoneset.add(acc.phone__c);                        
                //phoneset.add(acc.phone__c); 
                system.debug('emailset>>>>' +emailset );
            }      
        }
        
        for(obiA__c o1 : lstobj){
            if(emailset.contains(o1.email__c)){
                o1.email__c.adderror('email already exist');
                //o1.phone__c.adderror('phone already exist');
                system.debug('emailsetbefore insert>>>>' +emailset );
                
            }
        }for(obiA__c o1 : lstobj){
            if(emailset.contains(o1.phone__c)){
               // o1.email__c.adderror('email already exist');
                o1.phone__c.adderror('phone already exist');
                system.debug('emailsetbefore insert>>>>' +emailset );
                
            }
        }
    }
}