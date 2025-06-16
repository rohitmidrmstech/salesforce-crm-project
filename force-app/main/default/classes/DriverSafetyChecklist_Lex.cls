/**
 *  Purpose      :  This class is used to hold custom logic for Lightning experience page of Driver Safety Audit.
 *
 *  Created By    :  Padmesh Soni (Appirio Offshore)
 *
 *  Created Date  :  11/7/2017
 *
 *  Current Version  :  V_1.0
 *
 *  Revision Log  :  V_1.0 - Created - S-523609
 **/
public with sharing class DriverSafetyChecklist_Lex {

    @AuraEnabled
    public static Driver_Safety__c getdriverSafety() {
      
      return new Driver_Safety__c();
    }
    
    @AuraEnabled
    public static List<DriverQuestionaireWrapper> getDriverQuestionaires() {
      
      List<DriverQuestionaireWrapper> driverQuestionaires = new List<DriverQuestionaireWrapper>();
      List<DriverSafetyChecklist__c> driversSafety = DriverSafetyChecklist__c.getAll().values();
      
      for(DriverSafetyChecklist__c dSChecklist : driversSafety) {
        
        String answer = '';
        driverQuestionaires.add(new DriverQuestionaireWrapper(dSChecklist.Question_Type__c, dSChecklist.Question__c, answer, Integer.valueOf(dSChecklist.Name)));
      }
      driverQuestionaires.sort();
      return driverQuestionaires;
    }
    
    @AuraEnabled
    public static String submitValues(Driver_Safety__c driverSafetyInstance, String driverQuestionaireWrappers) {
      
      try {
        
        Driver_Safety__c driverSafety = new Driver_Safety__c(Observer__c = driverSafetyInstance.Observer__c,
                                                                Driver__c = driverSafetyInstance.Driver__c,
                                                                Date__c = driverSafetyInstance.Date__c,
                                                                Auditor_s_Comments__c = driverSafetyInstance.Auditor_s_Comments__c,
                                                                Self_Evaluation__c = driverSafetyInstance.Self_Evaluation__c);
        
        System.debug('%%%  self evaluation is ' + driverSafetyInstance.Self_Evaluation__c);
            List<DriverQuestionaireWrapper> driverQuestionaires = (List<DriverQuestionaireWrapper>) JSON.deserializeStrict(driverQuestionaireWrappers, List<DriverQuestionaireWrapper>.class);
        
        List<DriverSafetyChecklist__c> driversSafety = DriverSafetyChecklist__c.getAll().values();
      
        for(DriverQuestionaireWrapper currentQuestionaire : driverQuestionaires) {
          
          for(DriverSafetyChecklist__c dSChecklist : driversSafety) {
            
            if(currentQuestionaire.question == dSChecklist.Question__c) {
              
              driverSafety.put(dSChecklist.Field_Name__c, currentQuestionaire.answer);
            }
          }
        }
        
        System.debug('driverSafety :::'+ driverSafety);
        
        insert driverSafety;
        
            sendMail(driverSafety.Driver__c, driverSafety.Id);
            
            return (String) driverSafety.get('Id');
        } catch(Exception e) {
          
            //throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage());
            throw new AuraHandledException('Please enter the Driver Value');
            //return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static void sendMail(String driverId, String redirectId) {
        
        try {
            User u = [Select Email from User where Id =: driverId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            mail.setSubject('Driver Safety Audit');
            mail.htmlBody = 'A new driver safety form has been entered for you. Click the link to view it.' + '<a href="'+URL.getOrgDomainUrl().toExternalForm()+ '/' + redirectId + '">' + URL.getOrgDomainUrl().toExternalForm() + '/' + redirectId + '</a>';
            //mail.setToAddresses(new String[] {'arpit.vashishtha.developer@gmail.com'});
            mail.setToAddresses(new String[] {u.Email});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});

        } catch(Exception e) {
            throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
}