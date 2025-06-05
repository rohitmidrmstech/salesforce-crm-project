public class EmailUtil {
  public static void sendMessage(String[] toAddresses, String body, String subject){
        // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        Messaging.reserveSingleEmailCapacity(2);
        
        // Processes and actions involved in the Apex transaction occur next,
        // which conclude with sending a single email.
        
        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        
        // Specify the address used when the recipients reply to the email. 
        mail.setReplyTo('donotreply@mydomain.com');
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName('CT CoE - SFDC');
        
        // Specify the subject line for your email address.
        mail.setSubject(subject);
        
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        
        // Optionally append the Salesforce email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the text content of the email.
        mail.setPlainTextBody(body);
       
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}