public class sendEmailNotificationonlead {
 public static void sendingemailtolead(List<Lead>LeadList){
      System.debug('LeadList ====' + LeadList);
        List<Messaging.SingleEmailMessage> emailist = new List<Messaging.SingleEmailMessage>();
        List<Lead> LeadList1 = [select id, LastName,OwnerId,FirstName,Email from Lead where Email!=null LIMIT 2];
      for(Lead ld :LeadList1 ){
            System.debug('===ld=== ' + ld);
            if(ld.Email != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
       string [] toAddress = new string[]{ld.Email};
      mail.setToAddresses(toAddress);
      mail.setTargetObjectId(ld.OwnerId);
      mail.setReplyTo('komala.cheera@gmail.com');
      mail.setSenderDisplayName('Soham Technologies');   
      mail.setSubject(' Email off Lead creation');
      String body = 'Dear komala cheera lead created successfully' + ' Thank you  ';    
      mail.setHtmlBody(body);  
           System.debug('=====body=== ' + body);     
      emailist.add(mail);
            }
        }
         Messaging.sendEmail(emailist);
  }
}