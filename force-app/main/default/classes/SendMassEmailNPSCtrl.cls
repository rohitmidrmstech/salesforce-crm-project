public with sharing class SendMassEmailNPSCtrl{
    
    NPS_Survey_Week_Counter__c nps = new NPS_Survey_Week_Counter__c();
    double weekCount;
    
    public SendMassEmailNPSCtrl(ApexPages.StandardSetController controller) {
        System.debug('Constructor Working');
        nps = [SELECT Week_Counter__c,Total_Week__c FROM NPS_Survey_Week_Counter__c];
        System.debug('nps'+nps);
         System.debug('nps Week_Counter__c'+nps.Week_Counter__c);
        if(nps.Week_Counter__c != null){
            weekCount = nps.Week_Counter__c;
            System.debug('weekCount'+weekCount);
        }    
    }
    
    public Integer contactCount {get;set;}
    public String listView {get;set;}
    public String emailTemplate {get;set;}
    public List<SelectOption> listViewOptions {get;set;}
    public List<SelectOption> emailTemplateOptions {get;set;}
    public Map<String, String> listViewFilterMap;
    
    public SendMassEmailNPSCtrl(ApexPages.StandardController stdController) {}
    
    public void actionOnLoad() {
        listView = '';
        emailTemplate = '';
        listViewOptions = new List<SelectOption>();
        emailTemplateOptions = new List<SelectOption>();
        listViewFilterMap = new Map<String, String>();
        
        for(EmailTemplate et : [Select Id, Name from EmailTemplate Where Name LIKE 'Gypsum NPS Survey %']) {
            emailTemplateOptions.add(new SelectOption(et.Id, et.Name));
        }
        
        for (NPS_Survey_Filters__mdt filter : [SELECT Label, Where_Condition__c FROM NPS_Survey_Filters__mdt]) {
            listViewOptions.add(new SelectOption(filter.Label, filter.Label));
            listViewFilterMap.put(filter.Label, filter.Where_Condition__c);
        }
        
    }
    
    public void sendEmailToContacts() {
        System.debug('listVieww '+listView+' emailTemplatee '+emailTemplate);
        
        String whereCondtion = listViewFilterMap.get(listView);
        System.debug('whereCondtion '+whereCondtion);
        contactCount = Database.countQuery('SELECT COUNT() FROM Contact '+whereCondtion);
        system.debug('ContactCount---->'+ contactCount);
        
        System.debug('emailTemplatee '+emailTemplate);
        
        if (contactCount != null && contactCount > 0) {
            contactCount = (contactCount/weekCount).intValue();
            List<Contact> conList = Database.query('SELECT Name, Email FROM Contact '+whereCondtion+' LIMIT '+contactCount);
            system.debug('==========conList========'+conList.size());
            List<String> toAddresses = new List<String>();
            List<Contact> conToUpdate = new List<Contact>();
            //List<Messaging.Email> emailList = new List<Messaging.Email>();
            List<Id> conIds = new List<Id>();
            
            for(Contact con : conList) {
                if(con.Email != null || con.Email != ''){
                    toAddresses.add(con.Email);
                    conIds.add(con.Id);
                   // con.Survey_Email_Sent__c = TRUE;
                   // con.Survey_Sent_Date__c = System.Today();
                   conToUpdate.add(con);
                }
            }
            
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            //mail.setToAddresses(toAddresses);
            mail.setTargetObjectIds(conIds);
            mail.setSaveAsActivity(false);
            System.debug('emailTemplate'+emailTemplate);
            mail.setTemplateId(emailTemplate);                                
            //emailList.add(mail);
            
            try {
                if(!conToUpdate.isEmpty()){
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
                    if(weekCount > 1){
                        nps.Week_Counter__c = weekCount - 1;
                        update nps;
                    }
                    else{
                        if(nps.Total_Week__c > 1){
                            nps.Week_Counter__c = nps.Total_Week__c;
                            update nps;
                        }
                    }
                    
                    
                    Database.executeBatch(new SendMassEmailBatchClass(conIds));
                    //Update conToUpdate;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Survey emails have been sent successfully!'));
                }
                //System.debug('resultss '+results);
            } catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+ex.getMessage()));
                System.debug('Error: '+ex.getMessage());
            }
        }
    }
}