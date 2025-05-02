public class CreateAccRelatedRelation implements database.Batchable<sobject>,Database.stateful {
    public Set<String> setErrorMessages = new Set<String>();
    public Set<String> setSuccessIds = new Set<String>();
    
    public  database.QueryLocator start(database.BatchableContext bc ){
        // List<Account> lstacc = 'Select id ,Name FROM Account';
        string query = 'Select id ,Name FROM Account';
        return database.getQueryLocator(query);
    }
    public  void execute(database.BatchableContext bc , List<Account> Lstacc){
        soloution(Lstacc);     
    }
    public  void finish(database.BatchableContext bc ){
        sendEmail(setErrorMessages,setSuccessIds);
    }
    public  void soloution(List<Account> Lstacc){
        set<id> setaccid = new set<id>();
        Map<id,Account> MapAcc = new map<id,Account>(Lstacc);
        List<Account_Relation__c> lstTorel = new List<Account_Relation__c>();
        set<id> setrelId = new set<id>();
        for(Account acc : Lstacc){
            setaccid.add(acc.id);
        }
        List<Account_Relation__c> lstrelacc = [SELECT ID ,Name,Account__c, Account__r.Name FROM Account_Relation__c WHERE Account__c  IN : setaccid];
        for(Account_Relation__c	 Lstrel :lstrelacc ){
            setrelId.add(Lstrel.Account__c);                
        }
        for(ID setid :setaccid ){
            if(!setrelId.contains(setid)){
                string relname = MapAcc.get(setid).Name + 'Relationship';
                lstTorel.add(DataFactory.CreateAccrec(relname ,setid));
            }          
        }
        if(!lstTorel.isEmpty()){
            List<database.SaveResult> saveresult   = database.insert(lstTorel,false);
            for(database.SaveResult result : saveresult){
                if(result.issuccess()){
                    setSuccessIds.add(result.getId());                 
                }
                else {
                    List<Database.Error> lstErrors = result.getErrors();
                    for( Database.Error error : lstErrors ) {
                        // System.debug('Error Fields :: ' + error.getFields() );
                        // System.debug('Error Message :: ' + error.getMessage() );
                        setErrorMessages.add( error.getFields() + ' ::- ' + error.getMessage() );
                    }   
                }
                
            }
        }
        
    }
    public void sendEmail(Set<String> setSuccess, Set<String> setErrors) {
        
        // setSuccess.add('3223ewqas3r325');
        
        Messaging.SingleEmailMessage objSingleEmailMessage = new  Messaging.SingleEmailMessage();
        String[] arrToAddresses = new String[] { 'corpovisiontech@gmail.com' };
            
            // Setting email parameters
            objSingleEmailMessage.setToAddresses(arrToAddresses);
        objSingleEmailMessage.setReplyTo('xyz@gmail.com');
        objSingleEmailMessage.setSenderDisplayName('CorpoVision Technologies PVT. LTD.');
        objSingleEmailMessage.setSubject('CorpoVision Technologies Batch Alert');
        objSingleEmailMessage.setBccSender(false);
        
        // Setting HTML format body of email
        String htmlBody = '<h2> BatchCreateAccRelationship Result </h2> <br/>';
        htmlBody += '<h3 style="color: green;"> Success Ids :  </h3>';
        htmlBody += '<p>' + String.join(new List<String>(setSuccess), ' , ')  +  '<p/><hr/>';
        htmlBody += '<h3 style="color: red;"> Failure Messages :  </h3>';
        htmlBody += '<p>' + String.join(new List<String>(setErrors), ' , ')  +  '<p/>';        
        objSingleEmailMessage.setHtmlBody(htmlBody);
    }
}